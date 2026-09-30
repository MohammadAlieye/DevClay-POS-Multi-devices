import 'package:isar_community/isar.dart';

import 'collections/product.dart';
import 'collections/product_batch.dart';

class BatchAllocation {
  const BatchAllocation({
    required this.batchId,
    required this.quantity,
    this.expiryDate,
    this.batchCode,
  });

  final int batchId;
  final int quantity;
  final DateTime? expiryDate;
  final String? batchCode;

  Map<String, dynamic> toJson() => {
    'batchId': batchId,
    'quantity': quantity,
    if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
    if (batchCode != null) 'batchCode': batchCode,
  };
}

/// FEFO (first-expiry-first-out) stock lots for products.
///
/// All mutating methods must be called inside an Isar [writeTxn].
abstract final class ProductBatchStore {
  static DateTime? _dayOnly(DateTime? value) {
    if (value == null) return null;
    return DateTime(value.year, value.month, value.day);
  }

  static int _compareFefo(ProductBatch a, ProductBatch b) {
    final aExpiry = a.expiryDate;
    final bExpiry = b.expiryDate;
    if (aExpiry == null && bExpiry == null) {
      return a.receivedAt.compareTo(b.receivedAt);
    }
    if (aExpiry == null) return 1;
    if (bExpiry == null) return -1;
    final byExpiry = aExpiry.compareTo(bExpiry);
    if (byExpiry != 0) return byExpiry;
    return a.receivedAt.compareTo(b.receivedAt);
  }

  static int parseBatchSequence(String? code) {
    if (code == null || code.trim().isEmpty) return 0;
    final match = RegExp(r'(\d+)\s*$').firstMatch(code.trim());
    return int.tryParse(match?.group(1) ?? '') ?? 0;
  }

  static String formatBatchCode(int sequence) =>
      'B-${sequence.toString().padLeft(3, '0')}';

  static Future<int> nextBatchSequence(Isar isar, int productId) async {
    final batches = await isar.productBatchs
        .filter()
        .productIdEqualTo(productId)
        .findAll();
    var max = 0;
    for (final batch in batches) {
      final n = parseBatchSequence(batch.batchCode);
      if (n > max) max = n;
    }
    return max + 1;
  }

  static Future<List<ProductBatch>> batchesForProduct(
    Isar isar,
    int productId, {
    bool onlyWithStock = true,
  }) async {
    final all = await isar.productBatchs
        .filter()
        .productIdEqualTo(productId)
        .findAll();
    final filtered = onlyWithStock
        ? all.where((b) => b.quantity > 0).toList()
        : all;
    filtered.sort(_compareFefo);
    return filtered;
  }

  static Future<DateTime?> nearestExpiry(Isar isar, int productId) async {
    final batches = await batchesForProduct(isar, productId);
    for (final batch in batches) {
      if (batch.expiryDate != null) return _dayOnly(batch.expiryDate);
    }
    return null;
  }

  static Future<int> totalBatchQty(Isar isar, int productId) async {
    final batches = await isar.productBatchs
        .filter()
        .productIdEqualTo(productId)
        .findAll();
    return batches.fold<int>(0, (sum, b) => sum + b.quantity);
  }

  /// Keeps [Product.stock] and [Product.expiryDate] in sync with lots.
  static Future<void> syncProduct(Isar isar, Product product) async {
    final batches = await isar.productBatchs
        .filter()
        .productIdEqualTo(product.id)
        .findAll();
    final withStock = batches.where((b) => b.quantity > 0).toList()
      ..sort(_compareFefo);
    product.stock = withStock.fold<int>(0, (sum, b) => sum + b.quantity);
    product.expiryDate = withStock.isEmpty
        ? null
        : _dayOnly(withStock.first.expiryDate);
    await isar.products.put(product);
  }

  /// Adds quantity to an existing lot with the same expiry day, or creates one.
  static Future<ProductBatch> receive({
    required Isar isar,
    required Product product,
    required int quantity,
    DateTime? expiryDate,
    DateTime? manufactureDate,
    String? batchCode,
    double? unitCost,
    String? note,
    DateTime? receivedAt,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError('Receive quantity must be positive.');
    }
    final expiryDay = _dayOnly(expiryDate);
    final now = receivedAt ?? DateTime.now();

    final existing = await isar.productBatchs
        .filter()
        .productIdEqualTo(product.id)
        .findAll();

    ProductBatch? match;
    for (final batch in existing) {
      final sameExpiry = _dayOnly(batch.expiryDate) == expiryDay;
      final sameCode =
          (batch.batchCode?.trim() ?? '') == (batchCode?.trim() ?? '');
      if (sameExpiry && sameCode) {
        match = batch;
        break;
      }
    }

    if (match != null) {
      match
        ..quantity = match.quantity + quantity
        ..unitCost = unitCost ?? match.unitCost
        ..manufactureDate = manufactureDate ?? match.manufactureDate
        ..note = note ?? match.note;
      await isar.productBatchs.put(match);
      await syncProduct(isar, product);
      return match;
    }

    final created = ProductBatch()
      ..productId = product.id
      ..batchCode = batchCode?.trim().isEmpty == true ? null : batchCode?.trim()
      ..manufactureDate = _dayOnly(manufactureDate)
      ..expiryDate = expiryDay
      ..quantity = quantity
      ..unitCost = unitCost ?? product.purchasePrice
      ..receivedAt = now
      ..note = note;
    await isar.productBatchs.put(created);
    await syncProduct(isar, product);
    return created;
  }

  /// Deducts using FEFO. Returns allocations used for the sale/adjustment.
  static Future<List<BatchAllocation>> deductFefo({
    required Isar isar,
    required Product product,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError('Deduct quantity must be positive.');
    }

    await ensureLegacyMigrated(isar, product);

    final batches = await batchesForProduct(isar, product.id);
    final available = batches.fold<int>(0, (sum, b) => sum + b.quantity);
    if (available < quantity) {
      if (available == 0 && product.stock >= quantity) {
        // No lots yet but product has stock — migrate then retry.
        await ensureLegacyMigrated(isar, product, force: true);
        return deductFefo(isar: isar, product: product, quantity: quantity);
      }
      throw StateError(
        'Insufficient stock for ${product.name}. '
        'Available: $available, requested: $quantity.',
      );
    }

    var remaining = quantity;
    final allocations = <BatchAllocation>[];

    for (final batch in batches) {
      if (remaining <= 0) break;
      final take = remaining > batch.quantity ? batch.quantity : remaining;
      if (take <= 0) continue;
      batch.quantity -= take;
      await isar.productBatchs.put(batch);
      allocations.add(
        BatchAllocation(
          batchId: batch.id,
          quantity: take,
          expiryDate: batch.expiryDate,
          batchCode: batch.batchCode,
        ),
      );
      remaining -= take;
    }

    await syncProduct(isar, product);
    return allocations;
  }

  /// Deducts stock from the exact lot selected by the cashier.
  static Future<List<BatchAllocation>> deductFromBatch({
    required Isar isar,
    required Product product,
    required int batchId,
    required int quantity,
  }) async {
    if (quantity <= 0) {
      throw ArgumentError('Deduct quantity must be positive.');
    }

    await ensureLegacyMigrated(isar, product);
    final batch = await isar.productBatchs.get(batchId);
    if (batch == null || batch.productId != product.id) {
      throw StateError(
        'The selected batch for ${product.name} is unavailable.',
      );
    }
    if (batch.quantity < quantity) {
      throw StateError(
        'Only ${batch.quantity} units remain in batch '
        '${batch.batchCode?.trim().isNotEmpty == true ? batch.batchCode : 'without a code'} '
        'for ${product.name}.',
      );
    }

    batch.quantity -= quantity;
    await isar.productBatchs.put(batch);
    await syncProduct(isar, product);
    return [
      BatchAllocation(
        batchId: batch.id,
        quantity: quantity,
        expiryDate: batch.expiryDate,
        batchCode: batch.batchCode,
      ),
    ];
  }

  /// Sets absolute on-hand qty (product editor / opening stock).
  static Future<void> setAbsoluteStock({
    required Isar isar,
    required Product product,
    required int targetStock,
    DateTime? expiryDate,
    DateTime? manufactureDate,
  }) async {
    final target = targetStock.clamp(0, 999999).toInt();
    await ensureLegacyMigrated(isar, product);

    final current = await totalBatchQty(isar, product.id);
    if (target == current) {
      await syncProduct(isar, product);
      return;
    }
    if (target > current) {
      await receive(
        isar: isar,
        product: product,
        quantity: target - current,
        expiryDate: expiryDate ?? product.expiryDate,
        manufactureDate: manufactureDate ?? product.manufactureDate,
        note: 'Stock set',
      );
      return;
    }
    await deductFefo(isar: isar, product: product, quantity: current - target);
  }

  /// Creates a legacy lot from [Product.stock] when no batches exist yet.
  static Future<void> ensureLegacyMigrated(
    Isar isar,
    Product product, {
    bool force = false,
  }) async {
    final existing = await isar.productBatchs
        .filter()
        .productIdEqualTo(product.id)
        .findAll();
    final qtyInLots = existing.fold<int>(0, (sum, b) => sum + b.quantity);
    if (!force && existing.isNotEmpty && qtyInLots > 0) return;
    if (!force && existing.isNotEmpty && product.stock <= qtyInLots) return;

    if (existing.isEmpty && product.stock > 0) {
      final batch = ProductBatch()
        ..productId = product.id
        ..expiryDate = _dayOnly(product.expiryDate)
        ..manufactureDate = _dayOnly(product.manufactureDate)
        ..quantity = product.stock
        ..unitCost = product.purchasePrice
        ..receivedAt = DateTime.now()
        ..note = 'Migrated opening stock';
      await isar.productBatchs.put(batch);
      return;
    }

    if (product.stock > qtyInLots) {
      final batch = ProductBatch()
        ..productId = product.id
        ..expiryDate = _dayOnly(product.expiryDate)
        ..manufactureDate = _dayOnly(product.manufactureDate)
        ..quantity = product.stock - qtyInLots
        ..unitCost = product.purchasePrice
        ..receivedAt = DateTime.now()
        ..note = 'Stock catch-up lot';
      await isar.productBatchs.put(batch);
    }
  }

  /// One-time migration for all products after schema add.
  static Future<void> migrateAllLegacyStock(Isar isar) async {
    final products = await isar.products.where().findAll();
    await isar.writeTxn(() async {
      for (final product in products) {
        if (product.deletedAt != null) continue;
        await ensureLegacyMigrated(isar, product);
        await syncProduct(isar, product);
      }
    });
  }
}
