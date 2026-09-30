import 'dart:async';
import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../database/collections/account.dart';
import '../../../database/collections/customer.dart';
import '../../../database/collections/customer_ledger_entry.dart';
import '../../../database/collections/ledger_entry.dart';
import '../../../database/collections/product.dart';
import '../../../database/collections/product_variant.dart';
import '../../../database/collections/recent_sale.dart';
import '../../../database/collections/sale.dart';
import '../../../database/collections/stock_movement.dart';
import '../../../database/isar_service.dart';
import '../../../database/product_batch_store.dart';
import '../../../modules/sales/domain/entities/sale_entities.dart';
import '../../auth/retail_actor.dart';
import '../dtos/lan_dtos.dart';
import '../lan_api_errors.dart';

/// Host-side sale creation with FEFO, invoices, deposits, and khata ledger.
class SaleWriteService {
  SaleWriteService(this._isarService);

  final IsarService _isarService;
  final _lock = _AsyncLock();

  Isar get _isar => _isarService.instance;

  Future<Map<String, dynamic>> createSale(LanCreateSaleDto body) {
    return _lock.synchronized(() => _createSaleUnlocked(body));
  }

  Future<String> previewNextInvoiceNo() async {
    return _nextInvoiceNo(reserve: false);
  }

  Future<Map<String, dynamic>> _createSaleUnlocked(LanCreateSaleDto body) async {
    final now = DateTime.now();
    final invoiceNo = await _nextInvoiceNo(reserve: true);
    final linesRaw = jsonDecode(body.linesJson);
    if (linesRaw is! List || linesRaw.isEmpty) {
      throw LanApiException('Sale lines required', code: 'invalid_lines');
    }

    final methodKind = body.methodKind.trim().toLowerCase();
    late final int saleId;

    await _isar.writeTxn(() async {
      final saleLines = <SaleLineItem>[];
      for (final raw in linesRaw) {
        if (raw is! Map) continue;
        final map = Map<String, dynamic>.from(raw);
        final productId = (map['productId'] as num?)?.toInt();
        final qty = (map['quantity'] as num?)?.toInt() ?? 0;
        if (productId == null || qty <= 0) {
          throw LanApiException('Invalid line quantity', code: 'invalid_line');
        }
        final product = await _isar.products.get(productId);
        if (product == null || product.deletedAt != null) {
          throw LanApiException('Product not found', code: 'product_missing');
        }
        final variantId = (map['variantId'] as num?)?.toInt();
        final batchId = (map['batchId'] as num?)?.toInt();

        List<BatchAllocation> allocations;
        if (batchId != null) {
          allocations = await ProductBatchStore.deductFromBatch(
            isar: _isar,
            product: product,
            batchId: batchId,
            quantity: qty,
          );
        } else {
          allocations = await ProductBatchStore.deductFefo(
            isar: _isar,
            product: product,
            quantity: qty,
          );
        }

        if (variantId != null) {
          final variant = await _isar.productVariants.get(variantId);
          if (variant != null) {
            variant.stock = (variant.stock - qty).clamp(0, 1 << 30);
            await _isar.productVariants.put(variant);
            if (product.hasVariants) {
              final variants = await _isar.productVariants
                  .filter()
                  .productIdEqualTo(product.id)
                  .deletedAtIsNull()
                  .findAll();
              product.stock = variants
                  .where((v) => v.isActive)
                  .fold<int>(0, (s, v) => s + v.stock);
              await _isar.products.put(product);
            }
          }
        }

        final refreshed = await _isar.products.get(product.id);
        await _isar.stockMovements.put(
          StockMovement()
            ..productId = product.id
            ..productName = product.name
            ..productSku = product.sku
            ..type = 'sale'
            ..quantityChange = -qty
            ..quantityAfter = refreshed?.stock ?? 0
            ..note = 'LAN sale $invoiceNo'
            ..createdAt = now,
        );

        saleLines.add(
          SaleLineItem(
            productId: product.id,
            productName: '${map['name'] ?? product.name}',
            productSku: product.sku,
            quantity: qty,
            unitPrice: (map['unitPrice'] as num?)?.toDouble() ??
                product.sellingPrice,
            lineDiscount: (map['lineDiscount'] as num?)?.toDouble() ?? 0,
            lineTotal: (map['lineTotal'] as num?)?.toDouble() ??
                ((map['unitPrice'] as num?)?.toDouble() ??
                        product.sellingPrice) *
                    qty,
            unit: product.unit,
            quantityLabel: map['quantityLabel'] as String?,
            batchAllocations: allocations.map((a) => a.toJson()).toList(),
            itemsPerBox: product.itemsPerBox,
          ),
        );
      }

      Customer? customer;
      if (body.customerId != null) {
        customer = await _isar.customers.get(body.customerId!);
      }
      final customerLabel = customer?.name ??
          (body.customerName?.trim().isNotEmpty == true
              ? body.customerName!.trim()
              : 'Walk-in');

      saleId = await _isar.sales.put(
        Sale()
          ..invoiceNo = invoiceNo
          ..customerName = customerLabel
          ..customerId = customer?.id
          ..paymentMethod = body.paymentMethod
          ..subtotal = body.subtotal
          ..discount = body.discount
          ..tax = body.tax
          ..total = body.total
          ..amountPaid = body.amountPaid
          ..changeAmount = body.changeAmount
          ..itemCount = body.itemCount > 0 ? body.itemCount : saleLines.length
          ..linesJson = jsonEncode(saleLines.map((e) => e.toJson()).toList())
          ..notes = body.notes
          ..cashierId = body.cashierId
          ..cashierName = body.cashierName
          ..soldAt = now,
      );

      await _isar.recentSales.put(
        RecentSale()
          ..invoiceNo = invoiceNo
          ..customerName = customerLabel
          ..amount = body.total
          ..paymentMethod = body.paymentMethod
          ..soldAt = now,
      );

      final cashAccount = body.cashAccountId == null
          ? null
          : await _isar.accounts.get(body.cashAccountId!);
      final bankAccount = body.bankAccountId == null
          ? null
          : await _isar.accounts.get(body.bankAccountId!);

      if (methodKind == 'cash' && cashAccount != null) {
        await _deposit(cashAccount, body.total, invoiceNo, now, body);
      } else if (methodKind == 'card' && bankAccount != null) {
        await _deposit(bankAccount, body.total, invoiceNo, now, body);
      } else if (methodKind == 'split') {
        if (cashAccount != null && body.amountPaid > 0) {
          final cashDeposit = body.amountPaid.clamp(0, body.total).toDouble();
          if (cashDeposit > 0) {
            await _deposit(cashAccount, cashDeposit, invoiceNo, now, body);
          }
        }
        if (bankAccount != null && body.cardAmount > 0) {
          await _deposit(
            bankAccount,
            body.cardAmount.clamp(0, body.total).toDouble(),
            invoiceNo,
            now,
            body,
          );
        }
      } else if (methodKind == 'khata' && customer != null) {
        if (cashAccount != null && body.amountPaid > 0) {
          await _deposit(cashAccount, body.amountPaid, invoiceNo, now, body);
        }
        var running = customer.balance + body.total;
        await _isar.customerLedgerEntrys.put(
          CustomerLedgerEntry()
            ..customerId = customer.id
            ..customerName = customer.name
            ..type = 'debit'
            ..amount = body.total
            ..balanceAfter = running
            ..reference = invoiceNo
            ..note = 'POS Khata sale (LAN)'
            ..entryDate = now
            ..createdAt = now,
        );
        if (body.amountPaid > 0) {
          running -= body.amountPaid;
          await _isar.customerLedgerEntrys.put(
            CustomerLedgerEntry()
              ..customerId = customer.id
              ..customerName = customer.name
              ..type = 'credit'
              ..amount = body.amountPaid
              ..balanceAfter = running
              ..reference = invoiceNo
              ..note = 'Payment with POS sale (LAN)'
              ..entryDate = now
              ..createdAt = now,
          );
        }
        customer.balance = running;
        await _isar.customers.put(customer);
      }

      await RetailActorStore.audit(
        isar: _isar,
        action: 'sale.completed',
        entityType: 'sale',
        entityId: saleId,
        actor: RetailActor(
          id: body.cashierId,
          name: body.cashierName,
          role: 'cashier',
        ),
        details:
            '$invoiceNo · $customerLabel · ${saleLines.length} items · '
            'Rs ${body.total.toStringAsFixed(2)} · ${body.paymentMethod}',
        occurredAt: now,
      );
    });

    return {
      'id': saleId,
      'invoiceNo': invoiceNo,
      'soldAt': now.toIso8601String(),
      'total': body.total,
    };
  }

  Future<void> _deposit(
    Account account,
    double amount,
    String invoiceNo,
    DateTime now,
    LanCreateSaleDto body,
  ) async {
    if (amount <= 0) return;
    account.balance =
        (account.balance + amount).clamp(-999999999, 999999999).toDouble();
    await _isar.accounts.put(account);
    await _isar.ledgerEntrys.put(
      LedgerEntry()
        ..accountId = account.id
        ..accountName = account.name
        ..type = 'income'
        ..category = 'Sales deposit'
        ..amount = amount
        ..reference = invoiceNo
        ..note = 'POS sale'
        ..userId = body.cashierId
        ..userName = body.cashierName
        ..entryDate = now
        ..createdAt = now,
    );
  }

  Future<String> _nextInvoiceNo({required bool reserve}) async {
    final last = await _isar.sales.where().sortBySoldAtDesc().findFirst();
    var seq = 1;
    final match = RegExp(r'(\d+)$').firstMatch(last?.invoiceNo ?? '');
    if (match != null) {
      seq = (int.tryParse(match.group(1)!) ?? 0) + 1;
    }
    var invoice = 'INV-${seq.toString().padLeft(6, '0')}';
    while (await _isar.sales.filter().invoiceNoEqualTo(invoice).findFirst() !=
        null) {
      seq += 1;
      invoice = 'INV-${seq.toString().padLeft(6, '0')}';
    }
    return invoice;
  }
}

class _AsyncLock {
  Future<void> _last = Future.value();

  Future<T> synchronized<T>(Future<T> Function() action) {
    final previous = _last;
    final completer = Completer<void>();
    _last = completer.future;
    return previous.then((_) => action()).whenComplete(completer.complete);
  }
}
