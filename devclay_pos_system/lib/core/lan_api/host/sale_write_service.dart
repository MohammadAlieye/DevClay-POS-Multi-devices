import 'dart:async';
import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../database/collections/account.dart';
import '../../../database/collections/app_setting.dart';
import '../../../database/collections/cash_shift.dart';
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
    return _nextInvoiceNo();
  }

  /// Allocates the next sequential invoice (INV-000001…) for solo or host.
  Future<String> allocateNextInvoiceNo() => _nextInvoiceNo();

  Future<Map<String, dynamic>> _createSaleUnlocked(LanCreateSaleDto body) async {
    final now = DateTime.now();
    final invoiceNo = await _nextInvoiceNo();
    final linesRaw = jsonDecode(body.linesJson);
    if (linesRaw is! List || linesRaw.isEmpty) {
      throw LanApiException('Sale lines required', code: 'invalid_lines');
    }

    final methodKind = body.methodKind.trim().toLowerCase();
    if (methodKind == 'khata' && body.customerId == null) {
      throw LanApiException(
        'Select a customer for Khata',
        code: 'khata_customer_required',
        statusCode: 400,
      );
    }

    final settings = await _isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings?.cashierShiftRequired == true && body.cashierId > 0) {
      final openShift = await _isar.cashShifts
          .filter()
          .userIdEqualTo(body.cashierId)
          .statusEqualTo('open')
          .findFirst();
      if (openShift == null) {
        throw LanApiException(
          'Open your cashier shift before completing a sale.',
          code: 'shift_required',
          statusCode: 400,
        );
      }
    }

    late final int saleId;
    late final double computedSubtotal;
    late final double computedDiscount;
    late final double computedTax;
    late final double computedTotal;

    try {
      await _isar.writeTxn(() async {
        final saleLines = <SaleLineItem>[];
        var linesGross = 0.0;
        var linesTax = 0.0;

        for (final raw in linesRaw) {
          if (raw is! Map) continue;
          final map = Map<String, dynamic>.from(raw);
          final productId = (map['productId'] as num?)?.toInt();
          final qty = (map['quantity'] as num?)?.toInt() ?? 0;
          if (productId == null || qty <= 0) {
            throw LanApiException(
              'Invalid line quantity',
              code: 'invalid_line',
            );
          }
          final product = await _isar.products.get(productId);
          if (product == null || product.deletedAt != null) {
            throw LanApiException(
              'Product not found',
              code: 'product_missing',
            );
          }
          if (!product.isActive) {
            throw LanApiException(
              'Product is inactive',
              code: 'product_inactive',
              statusCode: 400,
            );
          }

          final variantId = (map['variantId'] as num?)?.toInt();
          final batchId = (map['batchId'] as num?)?.toInt();
          final unitPrice = (map['unitPrice'] as num?)?.toDouble() ??
              product.sellingPrice;
          final lineDiscount =
              (map['lineDiscount'] as num?)?.toDouble() ?? 0;
          final lineGross = (unitPrice * qty) - lineDiscount;
          final lineTax = product.taxInclusive
              ? 0.0
              : lineGross * (product.taxRate / 100);
          linesGross += lineGross;
          linesTax += lineTax;

          List<BatchAllocation> allocations;
          try {
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
          } on StateError catch (e) {
            throw LanApiException(
              e.message,
              code: 'insufficient_stock',
              statusCode: 400,
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
              unitPrice: unitPrice,
              lineDiscount: lineDiscount,
              lineTotal: lineGross,
              unit: product.unit,
              quantityLabel: map['quantityLabel'] as String?,
              batchAllocations: allocations.map((a) => a.toJson()).toList(),
              itemsPerBox: product.itemsPerBox,
            ),
          );
        }

        if (saleLines.isEmpty) {
          throw LanApiException('Sale lines required', code: 'invalid_lines');
        }

        computedDiscount = body.discount.clamp(0, linesGross).toDouble();
        computedSubtotal = (linesGross - computedDiscount)
            .clamp(0, double.infinity)
            .toDouble();
        // Scale tax with cart discount proportionally.
        final taxScale = linesGross <= 0
            ? 0.0
            : computedSubtotal / linesGross;
        computedTax = (linesTax * taxScale).clamp(0, double.infinity).toDouble();
        computedTotal = computedSubtotal + computedTax;

        Customer? customer;
        if (body.customerId != null) {
          customer = await _isar.customers.get(body.customerId!);
          if (customer == null || !customer.isActive) {
            throw LanApiException(
              'Active customer required',
              code: 'customer_missing',
              statusCode: 400,
            );
          }
        }
        if (methodKind == 'khata' && customer == null) {
          throw LanApiException(
            'Select a customer for Khata',
            code: 'khata_customer_required',
            statusCode: 400,
          );
        }

        final customerLabel = customer?.name ??
            (body.customerName?.trim().isNotEmpty == true
                ? body.customerName!.trim()
                : 'Walk-in');

        final amountPaid = body.amountPaid.clamp(0, double.infinity).toDouble();
        final cardAmount = body.cardAmount.clamp(0, double.infinity).toDouble();
        final changeAmount = methodKind == 'khata'
            ? 0.0
            : (amountPaid +
                    (methodKind == 'split' ? cardAmount : 0) -
                    computedTotal)
                .clamp(0, double.infinity)
                .toDouble();

        saleId = await _isar.sales.put(
          Sale()
            ..invoiceNo = invoiceNo
            ..customerName = customerLabel
            ..customerId = customer?.id
            ..paymentMethod = body.paymentMethod
            ..subtotal = computedSubtotal
            ..discount = computedDiscount
            ..tax = computedTax
            ..total = computedTotal
            ..amountPaid = amountPaid
            ..changeAmount = changeAmount
            ..itemCount =
                body.itemCount > 0 ? body.itemCount : saleLines.length
            ..linesJson =
                jsonEncode(saleLines.map((e) => e.toJson()).toList())
            ..notes = body.notes
            ..cashierId = body.cashierId
            ..cashierName = body.cashierName
            ..soldAt = now,
        );

        await _isar.recentSales.put(
          RecentSale()
            ..invoiceNo = invoiceNo
            ..customerName = customerLabel
            ..amount = computedTotal
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
          await _deposit(cashAccount, computedTotal, invoiceNo, now, body);
        } else if ((methodKind == 'card' || methodKind == 'wallet') &&
            bankAccount != null) {
          await _deposit(bankAccount, computedTotal, invoiceNo, now, body);
        } else if (methodKind == 'split') {
          if (cashAccount != null && amountPaid > 0) {
            final cashDeposit =
                amountPaid.clamp(0, computedTotal).toDouble();
            if (cashDeposit > 0) {
              await _deposit(
                cashAccount,
                cashDeposit,
                invoiceNo,
                now,
                body,
              );
            }
          }
          if (bankAccount != null && cardAmount > 0) {
            await _deposit(
              bankAccount,
              cardAmount.clamp(0, computedTotal).toDouble(),
              invoiceNo,
              now,
              body,
            );
          }
        } else if (methodKind == 'khata' && customer != null) {
          if (cashAccount != null && amountPaid > 0) {
            await _deposit(cashAccount, amountPaid, invoiceNo, now, body);
          }
          var running = customer.balance + computedTotal;
          await _isar.customerLedgerEntrys.put(
            CustomerLedgerEntry()
              ..customerId = customer.id
              ..customerName = customer.name
              ..type = 'debit'
              ..amount = computedTotal
              ..balanceAfter = running
              ..reference = invoiceNo
              ..note = 'POS Khata sale (LAN)'
              ..entryDate = now
              ..createdAt = now,
          );
          if (amountPaid > 0) {
            running -= amountPaid;
            await _isar.customerLedgerEntrys.put(
              CustomerLedgerEntry()
                ..customerId = customer.id
                ..customerName = customer.name
                ..type = 'credit'
                ..amount = amountPaid
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
              'Rs ${computedTotal.toStringAsFixed(2)} · ${body.paymentMethod}',
          occurredAt: now,
        );
      });
    } on LanApiException {
      rethrow;
    } on StateError catch (e) {
      throw LanApiException(
        e.message,
        code: 'insufficient_stock',
        statusCode: 400,
      );
    }

    return {
      'id': saleId,
      'invoiceNo': invoiceNo,
      'soldAt': now.toIso8601String(),
      'total': computedTotal,
      'subtotal': computedSubtotal,
      'tax': computedTax,
      'discount': computedDiscount,
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

  /// Unified sequential invoice numbers for solo + host: INV-000001.
  Future<String> _nextInvoiceNo() async {
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
