import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../database/collections/sale.dart';
import '../../../../core/auth/retail_actor.dart';
import '../../../../database/collections/account.dart';
import '../../../../database/collections/customer.dart';
import '../../../../database/collections/customer_ledger_entry.dart';
import '../../../../database/collections/ledger_entry.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/product_batch.dart';
import '../../../../database/collections/sale_return.dart';
import '../../../../database/collections/stock_movement.dart';
import '../../../../database/isar_service.dart';
import '../../../../database/product_batch_store.dart';
import '../../domain/entities/sale_entities.dart';

class SalesLocalDataSource {
  SalesLocalDataSource(this._isarService);

  final IsarService _isarService;

  Future<List<SaleRecord>> getSales({String query = ''}) async {
    final isar = _isarService.instance;
    final all = await isar.sales.where().sortBySoldAtDesc().findAll();
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all.where((sale) {
            return sale.invoiceNo.toLowerCase().contains(q) ||
                sale.customerName.toLowerCase().contains(q) ||
                sale.paymentMethod.toLowerCase().contains(q);
          }).toList();
    return filtered.map(_mapSale).toList();
  }

  Future<SaleRecord?> getSaleById(int id) async {
    final sale = await _isarService.instance.sales.get(id);
    if (sale == null) return null;
    return _mapSale(sale);
  }

  Future<SaleRecord?> getSaleByInvoice(String invoiceNo) async {
    final sale = await _isarService.instance.sales
        .filter()
        .invoiceNoEqualTo(invoiceNo)
        .findFirst();
    if (sale == null) return null;
    return _mapSale(sale);
  }

  Future<List<SaleReturnRecord>> getReturns() async {
    final records = await _isarService.instance.saleReturns
        .where()
        .sortByReturnedAtDesc()
        .findAll();
    return records.map((record) {
      final lines = jsonDecode(record.linesJson) as List<dynamic>;
      final itemCount = lines.fold<int>(
        0,
        (sum, item) =>
            sum + ((item as Map<String, dynamic>)['quantity'] as num).toInt(),
      );
      return SaleReturnRecord(
        returnNo: record.returnNo,
        invoiceNo: record.invoiceNo,
        customerName: record.customerName ?? 'Walk-in',
        itemCount: itemCount,
        refundAmount: record.refundAmount,
        refundMethod: record.refundMethod,
        reason: record.reason,
        isVoid: record.isVoid,
        cashierName: record.cashierName,
        approvedByName: record.approvedByName,
        returnedAt: record.returnedAt,
      );
    }).toList();
  }

  Future<void> saveSale({
    required String invoiceNo,
    required String customerName,
    required String paymentMethod,
    required double subtotal,
    required double discount,
    required double tax,
    required double total,
    required double amountPaid,
    required double changeAmount,
    required int itemCount,
    required List<SaleLineItem> lines,
    required DateTime soldAt,
    String? notes,
  }) async {
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      await isar.sales.put(
        Sale()
          ..invoiceNo = invoiceNo
          ..customerName = customerName
          ..paymentMethod = paymentMethod
          ..subtotal = subtotal
          ..discount = discount
          ..tax = tax
          ..total = total
          ..amountPaid = amountPaid
          ..changeAmount = changeAmount
          ..itemCount = itemCount
          ..linesJson = jsonEncode(lines.map((line) => line.toJson()).toList())
          ..notes = _emptyToNull(notes)
          ..soldAt = soldAt,
      );
    });
  }

  Future<SaleReturnResult> processReturn(SaleReturnRequest request) async {
    if (request.lines.isEmpty) throw ArgumentError('Select items to return.');
    if (request.reason.trim().isEmpty) {
      throw ArgumentError('Return reason is required.');
    }
    final isar = _isarService.instance;
    final sale = await isar.sales.get(request.saleId);
    if (sale == null) throw StateError('Original sale not found.');
    if (sale.status == 'voided') throw StateError('Sale is already voided.');
    final originalLines = _decodeLines(sale.linesJson);
    final existingReturns = await isar.saleReturns
        .filter()
        .saleIdEqualTo(sale.id)
        .findAll();
    final alreadyReturned = <int, int>{};
    for (final record in existingReturns) {
      final decoded = jsonDecode(record.linesJson) as List<dynamic>;
      for (final item in decoded.cast<Map<String, dynamic>>()) {
        final productId = item['productId'] as int;
        alreadyReturned[productId] =
            (alreadyReturned[productId] ?? 0) + (item['quantity'] as int);
      }
    }

    final selected = <({SaleLineItem line, int quantity})>[];
    for (final requested in request.lines) {
      final line = originalLines
          .where((item) => item.productId == requested.productId)
          .firstOrNull;
      if (line == null || requested.quantity <= 0) {
        throw ArgumentError('Invalid return quantity.');
      }
      final available = line.quantity - (alreadyReturned[line.productId] ?? 0);
      if (requested.quantity > available) {
        throw StateError(
          'Only $available ${line.productName} can still be returned.',
        );
      }
      selected.add((line: line, quantity: requested.quantity));
    }

    final originalWeight = originalLines.fold<double>(
      0,
      (sum, line) => sum + line.lineTotal,
    );
    final selectedWeight = selected.fold<double>(
      0,
      (sum, item) =>
          sum + (item.line.lineTotal * item.quantity / item.line.quantity),
    );
    final refund = originalWeight <= 0
        ? 0.0
        : (sale.total * selectedWeight / originalWeight)
              .clamp(0, sale.total - sale.returnedAmount)
              .toDouble();
    if (refund <= 0) throw StateError('Return has no refundable amount.');

    final actor = await RetailActorStore.current(isar);
    final now = DateTime.now();
    final returnNo = 'RET-${now.microsecondsSinceEpoch}';
    final returnPayload = <Map<String, dynamic>>[];

    await isar.writeTxn(() async {
      for (final item in selected) {
        final product = await isar.products.get(item.line.productId);
        if (product == null) {
          throw StateError('${item.line.productName} no longer exists.');
        }
        var remaining = item.quantity;
        for (final allocation in item.line.batchAllocations) {
          if (remaining <= 0) break;
          final originallyTaken =
              (allocation['quantity'] as num?)?.toInt() ?? 0;
          if (originallyTaken <= 0) continue;
          final restore = remaining > originallyTaken
              ? originallyTaken
              : remaining;
          final batchId = (allocation['batchId'] as num?)?.toInt();
          final batch = batchId == null
              ? null
              : await isar.productBatchs.get(batchId);
          await ProductBatchStore.receive(
            isar: isar,
            product: product,
            quantity: restore,
            batchCode: batch?.batchCode ?? allocation['batchCode'] as String?,
            manufactureDate: batch?.manufactureDate,
            expiryDate:
                batch?.expiryDate ?? _parseDate(allocation['expiryDate']),
            unitCost: batch?.unitCost ?? product.purchasePrice,
            note: 'Customer return $returnNo',
            receivedAt: now,
          );
          remaining -= restore;
        }
        if (remaining > 0) {
          await ProductBatchStore.receive(
            isar: isar,
            product: product,
            quantity: remaining,
            unitCost: product.purchasePrice,
            note: 'Customer return $returnNo',
            receivedAt: now,
          );
        }
        final refreshed = await isar.products.get(product.id);
        await isar.stockMovements.put(
          StockMovement()
            ..productId = product.id
            ..productName = product.name
            ..productSku = product.sku
            ..type = request.isVoid ? 'sale_void' : 'sale_return'
            ..quantityChange = item.quantity
            ..quantityAfter = refreshed?.stock ?? 0
            ..note = '${sale.invoiceNo} · ${request.reason.trim()}'
            ..createdAt = now,
        );
        returnPayload.add({
          'productId': product.id,
          'productName': product.name,
          'productSku': product.sku,
          'quantity': item.quantity,
          'refundAmount':
              refund *
              (item.line.lineTotal * item.quantity / item.line.quantity) /
              selectedWeight,
        });
      }

      await _reversePayment(
        isar: isar,
        sale: sale,
        refund: refund,
        returnNo: returnNo,
        now: now,
      );
      sale.returnedAmount += refund;
      sale.status = request.isVoid
          ? 'voided'
          : sale.returnedAmount + 0.01 >= sale.total
          ? 'returned'
          : 'partially_returned';
      await isar.sales.put(sale);
      final returnId = await isar.saleReturns.put(
        SaleReturn()
          ..returnNo = returnNo
          ..saleId = sale.id
          ..invoiceNo = sale.invoiceNo
          ..customerId = sale.customerId
          ..customerName = sale.customerName
          ..linesJson = jsonEncode(returnPayload)
          ..refundAmount = refund
          ..refundMethod = sale.paymentMethod
          ..reason = request.reason.trim()
          ..isVoid = request.isVoid
          ..cashierId = actor?.id
          ..cashierName = actor?.name
          ..approvedById = request.approvedById
          ..approvedByName = request.approvedByName
          ..returnedAt = now,
      );
      await RetailActorStore.audit(
        isar: isar,
        action: request.isVoid ? 'sale.voided' : 'sale.returned',
        entityType: 'sale_return',
        entityId: returnId,
        actor: actor,
        details:
            '${sale.invoiceNo} · $returnNo · Rs ${refund.toStringAsFixed(2)} '
            '· approved by ${request.approvedByName} · ${request.reason.trim()}',
        occurredAt: now,
      );
    });

    return SaleReturnResult(
      returnNo: returnNo,
      refundAmount: refund,
      status: sale.status,
    );
  }

  Future<void> _reversePayment({
    required Isar isar,
    required Sale sale,
    required double refund,
    required String returnNo,
    required DateTime now,
  }) async {
    var cashRefund = refund;
    if (sale.paymentMethod.toLowerCase().contains('khata') &&
        sale.customerId != null) {
      final paidRatio = sale.total <= 0
          ? 0.0
          : (sale.amountPaid / sale.total).clamp(0.0, 1.0).toDouble();
      cashRefund = refund * paidRatio;
      final khataCredit = refund - cashRefund;
      final customer = await isar.customers.get(sale.customerId!);
      if (customer != null && khataCredit > 0) {
        customer.balance -= khataCredit;
        await isar.customers.put(customer);
        await isar.customerLedgerEntrys.put(
          CustomerLedgerEntry()
            ..customerId = customer.id
            ..customerName = customer.name
            ..type = 'credit'
            ..amount = khataCredit
            ..balanceAfter = customer.balance
            ..reference = returnNo
            ..note = 'Customer return against ${sale.invoiceNo}'
            ..entryDate = now
            ..createdAt = now,
        );
      }
    }

    if (cashRefund <= 0) return;

    final deposits = (await isar.ledgerEntrys.where().findAll())
        .where(
          (entry) =>
              entry.reference == sale.invoiceNo &&
              entry.category == 'Sales deposit' &&
              entry.type == 'income',
        )
        .toList();
    final depositedTotal = deposits.fold<double>(
      0,
      (sum, item) => sum + item.amount,
    );
    if (depositedTotal <= 0) return;
    for (final deposit in deposits) {
      final portion = cashRefund * deposit.amount / depositedTotal;
      final account = await isar.accounts.get(deposit.accountId);
      if (account == null) continue;
      account.balance -= portion;
      await isar.accounts.put(account);
      await isar.ledgerEntrys.put(
        LedgerEntry()
          ..accountId = account.id
          ..accountName = account.name
          ..type = 'expense'
          ..category = 'Sales refund'
          ..amount = portion
          ..reference = returnNo
          ..note = 'Refund against ${sale.invoiceNo}'
          ..movementKind = 'cashOut'
          ..entryDate = now
          ..createdAt = now,
      );
    }
  }

  DateTime? _parseDate(dynamic value) {
    if (value is! String) return null;
    return DateTime.tryParse(value);
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  List<SaleLineItem> _decodeLines(String json) {
    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map((item) => SaleLineItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  SaleRecord _mapSale(Sale sale) {
    return SaleRecord(
      id: sale.id,
      invoiceNo: sale.invoiceNo,
      customerName: sale.customerName,
      paymentMethod: sale.paymentMethod,
      subtotal: sale.subtotal,
      discount: sale.discount,
      tax: sale.tax,
      total: sale.total,
      amountPaid: sale.amountPaid,
      changeAmount: sale.changeAmount,
      itemCount: sale.itemCount,
      lines: _decodeLines(sale.linesJson),
      soldAt: sale.soldAt,
      notes: sale.notes,
      customerId: sale.customerId,
      cashierId: sale.cashierId,
      cashierName: sale.cashierName,
      status: sale.status,
      returnedAmount: sale.returnedAmount,
    );
  }
}
