import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../database/collections/product.dart';
import '../../../../core/auth/retail_actor.dart';
import '../../../../database/collections/product_batch.dart';
import '../../../../database/collections/purchase.dart';
import '../../../../database/collections/purchase_return.dart';
import '../../../../database/collections/stock_movement.dart';
import '../../../../database/collections/supplier.dart';
import '../../../../database/isar_service.dart';
import '../../../../database/product_batch_store.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../utils/measure_units.dart';
import '../../domain/entities/purchase_entities.dart';

class PurchasesLocalDataSource {
  PurchasesLocalDataSource(this._isarService);

  final IsarService _isarService;

  Future<List<PurchaseRecord>> getPurchases({String query = ''}) async {
    final isar = _isarService.instance;
    final all = await isar.purchases.where().sortByPurchaseDateDesc().findAll();
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all.where((purchase) {
            return purchase.supplierName.toLowerCase().contains(q) ||
                purchase.invoiceNo.toLowerCase().contains(q);
          }).toList();
    return filtered.map(_mapPurchase).toList();
  }

  Future<List<SupplierItem>> getSuppliers({String query = ''}) async {
    final isar = _isarService.instance;
    final all = await isar.suppliers.where().sortByName().findAll();
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all.where((supplier) {
            return supplier.name.toLowerCase().contains(q) ||
                supplier.phone.contains(q);
          }).toList();
    return filtered.map(_mapSupplier).toList();
  }

  Future<List<PurchaseProductOption>> getProductOptions() async {
    final isar = _isarService.instance;
    final products = await isar.products
        .filter()
        .deletedAtIsNull()
        .isActiveEqualTo(true)
        .sortByName()
        .findAll();
    final batches = await isar.productBatchs.where().findAll();
    final nextByProduct = <int, int>{};
    for (final batch in batches) {
      final n = ProductBatchStore.parseBatchSequence(batch.batchCode);
      final current = nextByProduct[batch.productId] ?? 0;
      if (n > current) nextByProduct[batch.productId] = n;
    }
    return products
        .map(
          (product) => PurchaseProductOption(
            id: product.id,
            name: product.name,
            sku: product.sku,
            purchasePrice: product.purchasePrice,
            stock: product.stock,
            unit: product.unit,
            sellingPrice: product.sellingPrice,
            wholesalePrice: product.wholesalePrice,
            itemsPerBox: product.itemsPerBox > 0 ? product.itemsPerBox : 1,
            nextBatchNumber: (nextByProduct[product.id] ?? 0) + 1,
            lowStockThreshold: product.lowStockThreshold,
            expiryDate: product.expiryDate,
          ),
        )
        .toList();
  }

  Future<PurchaseRecord> createPurchase(PurchaseDraft draft) async {
    if (draft.lines.isEmpty) {
      throw ArgumentError('Add at least one product line.');
    }
    if (!draft.taxAmount.isFinite || draft.taxAmount < 0) {
      throw ArgumentError('Enter a valid purchase tax amount.');
    }
    if (!draft.paidAmount.isFinite ||
        draft.paidAmount < 0 ||
        draft.paidAmount > draft.total) {
      throw ArgumentError('Paid amount must be between 0 and total.');
    }
    for (final line in draft.lines) {
      if (line.quantity <= 0) {
        throw ArgumentError('Purchase quantity must be greater than zero.');
      }
      if (!line.unitCost.isFinite || line.unitCost < 0) {
        throw ArgumentError('Enter a valid purchase cost.');
      }
      if (line.manufactureDate != null &&
          line.expiryDate != null &&
          line.manufactureDate!.isAfter(line.expiryDate!)) {
        throw ArgumentError(
          'Manufacture date must be on or before expiry date.',
        );
      }
    }

    final isar = _isarService.instance;
    final supplier = await isar.suppliers.get(draft.supplierId);
    if (supplier == null) {
      throw StateError('Supplier not found.');
    }

    final invoiceNo = draft.invoiceNo.trim();
    if (invoiceNo.isEmpty) {
      throw ArgumentError('Invoice number is required.');
    }

    final existing = await isar.purchases
        .filter()
        .invoiceNoEqualTo(invoiceNo)
        .findFirst();
    if (existing != null) {
      throw StateError('Invoice $invoiceNo already exists.');
    }

    final paid = draft.paidAmount;
    final due = (draft.total - paid).clamp(0, double.infinity).toDouble();
    final status = due <= 0 ? 'paid' : 'open';
    final now = DateTime.now();

    late int id;
    await isar.writeTxn(() async {
      for (final line in draft.lines) {
        final product = await isar.products.get(line.productId);
        if (product == null) {
          throw StateError('Product ${line.productSku} not found.');
        }
        if (product.deletedAt != null) {
          throw StateError(
            '${product.name} is in the Recycle Bin. Restore it before purchasing.',
          );
        }

        if (line.sellingPrice != null && line.sellingPrice! > 0) {
          final compareCost = line.packageUnitCost ?? line.unitCost;
          if (compareCost > line.sellingPrice!) {
            throw ArgumentError(
              'Purchase cost cannot be higher than selling price for ${line.productName}.',
            );
          }
          product.sellingPrice = line.sellingPrice!;
        }
        if (line.wholesalePrice != null && line.wholesalePrice! > 0) {
          final wholesale = line.wholesalePrice!;
          final compareCost = line.packageUnitCost ?? line.unitCost;
          if (wholesale < compareCost ||
              (line.sellingPrice != null &&
                  line.sellingPrice! > 0 &&
                  wholesale > line.sellingPrice!)) {
            throw ArgumentError(
              'Wholesale must be between cost and selling for ${line.productName}.',
            );
          }
          product.wholesalePrice = wholesale;
        }
        final sellType = MeasureUnits.inferSellType(product.unit);
        product.sellType = MeasureUnits.sellTypeKey(sellType);
        product.purchasePrice = line.packageUnitCost ??
            (sellType == SellType.piece
                ? line.unitCost
                : line.unitCost * MeasureUnits.unitMultiplier(product.unit));
        if (line.packageUnit?.toLowerCase() == 'box' &&
            line.unitsPerPackage > 0) {
          product.itemsPerBox = line.unitsPerPackage;
        }
        await ProductBatchStore.receive(
          isar: isar,
          product: product,
          quantity: line.quantity,
          expiryDate: line.expiryDate,
          manufactureDate: line.manufactureDate,
          batchCode: line.batchCode,
          unitCost: line.unitCost,
          note: 'Purchase $invoiceNo',
          receivedAt: now,
        );

        final refreshed = await isar.products.get(product.id);
        await isar.stockMovements.put(
          StockMovement()
            ..productId = product.id
            ..productName = product.name
            ..productSku = product.sku
            ..type = 'purchase'
            ..quantityChange = line.quantity
            ..quantityAfter = refreshed?.stock ?? product.stock
            ..note = 'Purchase $invoiceNo'
            ..createdAt = now,
        );
      }

      id = await isar.purchases.put(
        Purchase()
          ..supplierId = supplier.id
          ..supplierName = supplier.name
          ..invoiceNo = invoiceNo
          ..purchaseDate = now
          ..linesJson = jsonEncode(draft.lines.map((e) => e.toJson()).toList())
          ..subtotal = draft.subtotal
          ..taxAmount = draft.taxAmount
          ..total = draft.total
          ..paidAmount = paid
          ..dueAmount = due
          ..status = status
          ..notes = _emptyToNull(draft.notes)
          ..createdAt = now,
      );
    });

    final saved = await isar.purchases.get(id);
    return _mapPurchase(saved!);
  }

  Future<PurchaseRecord> recordPayment({
    required int purchaseId,
    required double amount,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Payment amount must be greater than zero.');
    }

    final isar = _isarService.instance;
    final purchase = await isar.purchases.get(purchaseId);
    if (purchase == null) {
      throw StateError('Purchase not found.');
    }
    if (purchase.dueAmount <= 0) {
      throw StateError('This purchase is already fully paid.');
    }
    if (amount > purchase.dueAmount + 0.009) {
      throw ArgumentError('Payment cannot exceed the due amount.');
    }

    await isar.writeTxn(() async {
      await _applyPaymentToPurchase(isar, purchase, amount);
    });

    final saved = await isar.purchases.get(purchaseId);
    return _mapPurchase(saved!);
  }

  Future<void> recordSupplierPayment({
    required int supplierId,
    required double amount,
  }) async {
    if (amount <= 0) {
      throw ArgumentError('Payment amount must be greater than zero.');
    }

    final isar = _isarService.instance;
    final supplier = await isar.suppliers.get(supplierId);
    if (supplier == null) {
      throw StateError('Supplier not found.');
    }

    final open = await isar.purchases
        .filter()
        .supplierIdEqualTo(supplierId)
        .findAll();
    final duePurchases = open.where((p) => p.dueAmount > 0.009).toList()
      ..sort((a, b) => a.purchaseDate.compareTo(b.purchaseDate));

    final invoiceDue = duePurchases.fold<double>(
      0,
      (sum, p) => sum + p.dueAmount,
    );
    final payableBalance = KhataBalanceRules.money(supplier.balance);
    final safePayable = payableBalance > 0.009 ? payableBalance : 0.0;
    final totalDue = invoiceDue + safePayable;

    if (totalDue <= 0.009) {
      throw StateError('No amount due for this supplier.');
    }
    if (amount > totalDue + 0.009) {
      throw ArgumentError('Payment cannot exceed total due.');
    }

    await isar.writeTxn(() async {
      var remaining = amount;

      if (safePayable > 0.009 && remaining > 0.009) {
        final pay = remaining > safePayable ? safePayable : remaining;
        supplier.balance = payableBalance - pay;
        remaining -= pay;
        await isar.suppliers.put(supplier);
      }

      for (final purchase in duePurchases) {
        if (remaining <= 0.009) break;
        final pay = remaining > purchase.dueAmount
            ? purchase.dueAmount
            : remaining;
        if (pay <= 0.009) continue;
        await _applyPaymentToPurchase(isar, purchase, pay);
        remaining -= pay;
      }
    });
  }

  Future<SupplierItem> adjustSupplierBalance({
    required int supplierId,
    required double amountChange,
    String? note,
  }) async {
    if (amountChange == 0) {
      throw ArgumentError('Balance change cannot be zero.');
    }

    final isar = _isarService.instance;
    final supplier = await isar.suppliers.get(supplierId);
    if (supplier == null) {
      throw StateError('Supplier not found.');
    }

    await isar.writeTxn(() async {
      supplier.balance =
          KhataBalanceRules.money(supplier.balance) + amountChange;
      if (note != null && note.trim().isNotEmpty) {
        final existingNotes = supplier.notes?.trim();
        supplier.notes = existingNotes == null || existingNotes.isEmpty
            ? note.trim()
            : '$existingNotes\n${note.trim()}';
      }
      await isar.suppliers.put(supplier);
    });

    final saved = await isar.suppliers.get(supplierId);
    return _mapSupplier(saved!);
  }

  Future<void> _applyPaymentToPurchase(
    Isar isar,
    Purchase purchase,
    double amount,
  ) async {
    final nextPaid = (purchase.paidAmount + amount)
        .clamp(0, purchase.total)
        .toDouble();
    final nextDue = (purchase.total - nextPaid)
        .clamp(0, double.infinity)
        .toDouble();
    purchase
      ..paidAmount = nextPaid
      ..dueAmount = nextDue
      ..status = nextDue <= 0 ? 'paid' : 'open';
    await isar.purchases.put(purchase);
  }

  Future<SupplierItem> saveSupplier(SupplierDraft draft, {int? id}) async {
    final name = draft.name.trim();
    final phone = draft.phone.trim();
    if (name.isEmpty) {
      throw ArgumentError('Supplier name is required.');
    }
    final email = draft.email?.trim() ?? '';
    if (email.isNotEmpty &&
        !RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(email)) {
      throw ArgumentError('Enter a valid supplier email address.');
    }

    final isar = _isarService.instance;

    if (id == null) {
      final openingBalance = draft.openingBalance.isFinite
          ? draft.openingBalance
          : 0.0;
      late int newId;
      await isar.writeTxn(() async {
        newId = await isar.suppliers.put(
          Supplier()
            ..name = name
            ..phone = phone
            ..email = _emptyToNull(draft.email)
            ..address = _emptyToNull(draft.address)
            ..notes = _emptyToNull(draft.notes)
            ..balance = openingBalance
            ..isActive = draft.isActive
            ..createdAt = DateTime.now(),
        );
      });
      final saved = await isar.suppliers.get(newId);
      return _mapSupplier(saved!);
    }

    final existing = await isar.suppliers.get(id);
    if (existing == null) {
      throw StateError('Supplier not found.');
    }

    await isar.writeTxn(() async {
      existing
        ..name = name
        ..phone = phone
        ..email = _emptyToNull(draft.email)
        ..address = _emptyToNull(draft.address)
        ..notes = _emptyToNull(draft.notes)
        ..isActive = draft.isActive;
      await isar.suppliers.put(existing);
    });

    final saved = await isar.suppliers.get(id);
    return _mapSupplier(saved!);
  }

  Future<double> processPurchaseReturn(PurchaseReturnRequest request) async {
    if (request.lines.isEmpty) throw ArgumentError('Select items to return.');
    if (request.reason.trim().isEmpty) {
      throw ArgumentError('Supplier return reason is required.');
    }
    final isar = _isarService.instance;
    final purchase = await isar.purchases.get(request.purchaseId);
    if (purchase == null) throw StateError('Purchase not found.');
    final originalLines = _decodeLines(purchase.linesJson);
    final previous = await isar.purchaseReturns
        .filter()
        .purchaseIdEqualTo(purchase.id)
        .findAll();
    final returned = <int, int>{};
    for (final record in previous) {
      for (final item
          in (jsonDecode(record.linesJson) as List<dynamic>)
              .cast<Map<String, dynamic>>()) {
        final id = item['productId'] as int;
        returned[id] = (returned[id] ?? 0) + (item['quantity'] as int);
      }
    }
    final selected = <({PurchaseLineItem line, int quantity})>[];
    for (final item in request.lines) {
      final line = originalLines
          .where((line) => line.productId == item.productId)
          .firstOrNull;
      if (line == null || item.quantity <= 0) {
        throw ArgumentError('Invalid supplier return quantity.');
      }
      final available = line.quantity - (returned[line.productId] ?? 0);
      if (item.quantity > available) {
        throw StateError(
          'Only $available ${line.productName} can be returned.',
        );
      }
      selected.add((line: line, quantity: item.quantity));
    }
    final total = selected.fold<double>(
      0,
      (sum, item) => sum + item.quantity * item.line.unitCost,
    );
    final actor = await RetailActorStore.current(isar);
    final now = DateTime.now();
    final returnNo = 'PRET-${now.microsecondsSinceEpoch}';
    await isar.writeTxn(() async {
      final payload = <Map<String, dynamic>>[];
      for (final item in selected) {
        final product = await isar.products.get(item.line.productId);
        if (product == null) {
          throw StateError('${item.line.productName} no longer exists.');
        }
        await ProductBatchStore.deductFefo(
          isar: isar,
          product: product,
          quantity: item.quantity,
        );
        final refreshed = await isar.products.get(product.id);
        await isar.stockMovements.put(
          StockMovement()
            ..productId = product.id
            ..productName = product.name
            ..productSku = product.sku
            ..type = 'purchase_return'
            ..quantityChange = -item.quantity
            ..quantityAfter = refreshed?.stock ?? 0
            ..note = '$returnNo · ${request.reason.trim()}'
            ..createdAt = now,
        );
        payload.add({
          'productId': product.id,
          'productName': product.name,
          'productSku': product.sku,
          'quantity': item.quantity,
          'unitCost': item.line.unitCost,
          'total': item.quantity * item.line.unitCost,
        });
      }
      purchase.subtotal = (purchase.subtotal - total).clamp(0, double.infinity);
      purchase.total = (purchase.total - total).clamp(0, double.infinity);
      purchase.paidAmount = purchase.paidAmount.clamp(0, purchase.total);
      purchase.dueAmount = purchase.total - purchase.paidAmount;
      purchase.status = purchase.dueAmount <= 0 ? 'paid' : 'open';
      await isar.purchases.put(purchase);
      final id = await isar.purchaseReturns.put(
        PurchaseReturn()
          ..returnNo = returnNo
          ..purchaseId = purchase.id
          ..invoiceNo = purchase.invoiceNo
          ..supplierId = purchase.supplierId
          ..supplierName = purchase.supplierName
          ..linesJson = jsonEncode(payload)
          ..total = total
          ..reason = request.reason.trim()
          ..userId = actor?.id
          ..userName = actor?.name
          ..returnedAt = now,
      );
      await RetailActorStore.audit(
        isar: isar,
        action: 'purchase.returned',
        entityType: 'purchase_return',
        entityId: id,
        actor: actor,
        details:
            '${purchase.invoiceNo} · $returnNo · Rs ${total.toStringAsFixed(2)} '
            '· ${request.reason.trim()}',
        occurredAt: now,
      );
    });
    return total;
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  List<PurchaseLineItem> _decodeLines(String json) {
    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map((item) => PurchaseLineItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  PurchaseRecord _mapPurchase(Purchase purchase) {
    return PurchaseRecord(
      id: purchase.id,
      supplierId: purchase.supplierId,
      supplierName: purchase.supplierName,
      invoiceNo: purchase.invoiceNo,
      purchaseDate: purchase.purchaseDate,
      lines: _decodeLines(purchase.linesJson),
      subtotal: purchase.subtotal,
      taxAmount: purchase.taxAmount,
      total: purchase.total,
      paidAmount: purchase.paidAmount,
      dueAmount: purchase.dueAmount,
      status: purchase.status,
      createdAt: purchase.createdAt,
      notes: purchase.notes,
    );
  }

  SupplierItem _mapSupplier(Supplier supplier) {
    return SupplierItem(
      id: supplier.id,
      name: supplier.name,
      phone: supplier.phone,
      isActive: supplier.isActive,
      balance: KhataBalanceRules.money(supplier.balance),
      email: supplier.email,
      address: supplier.address,
      notes: supplier.notes,
    );
  }
}
