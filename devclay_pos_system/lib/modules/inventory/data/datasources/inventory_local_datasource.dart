import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/lan_api/lan_mode_service.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/product_batch.dart';
import '../../../../database/collections/purchase.dart';
import '../../../../database/collections/stock_movement.dart';
import '../../../../database/isar_service.dart';
import '../../../../database/product_batch_store.dart';
import '../../../purchases/domain/entities/purchase_entities.dart';
import '../../domain/entities/inventory_entities.dart';

class InventoryLocalDataSource {
  InventoryLocalDataSource(this._isarService);

  final IsarService _isarService;

  Future<List<InventoryProduct>> getProducts({String query = ''}) async {
    final isar = _isarService.instance;
    final all = await isar.products
        .filter()
        .deletedAtIsNull()
        .sortByName()
        .findAll();
    final batches = await isar.productBatchs.where().findAll();
    final nextByProduct = <int, int>{};
    final activeCountByProduct = <int, int>{};
    for (final batch in batches) {
      final sequence = ProductBatchStore.parseBatchSequence(batch.batchCode);
      final current = nextByProduct[batch.productId] ?? 0;
      if (sequence > current) nextByProduct[batch.productId] = sequence;
      if (batch.quantity > 0) {
        activeCountByProduct.update(
          batch.productId,
          (count) => count + 1,
          ifAbsent: () => 1,
        );
      }
    }
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all.where((product) {
            return product.name.toLowerCase().contains(q) ||
                product.sku.toLowerCase().contains(q) ||
                product.category.toLowerCase().contains(q);
          }).toList();
    return filtered
        .map(
          (product) => _mapProduct(
            product,
            nextBatchNumber: (nextByProduct[product.id] ?? 0) + 1,
            activeBatchCount: activeCountByProduct[product.id] ?? 0,
          ),
        )
        .toList();
  }

  Future<List<StockMovementItem>> getMovements({int limit = 100}) async {
    final isar = _isarService.instance;
    final rows = await isar.stockMovements
        .where()
        .sortByCreatedAtDesc()
        .limit(limit)
        .findAll();
    return rows.map(_mapMovement).toList();
  }

  Future<InventoryProductDetail> getProductDetail(int productId) async {
    final isar = _isarService.instance;
    final product = await isar.products.get(productId);
    if (product == null || product.deletedAt != null) {
      throw StateError('Product not found.');
    }

    final lots = await ProductBatchStore.batchesForProduct(
      isar,
      productId,
      onlyWithStock: false,
    );
    final purchases = await isar.purchases
        .where()
        .sortByPurchaseDateDesc()
        .findAll();
    final history = <InventoryPurchaseHistory>[];
    for (final purchase in purchases) {
      final lines = _decodePurchaseLines(purchase.linesJson);
      for (final line in lines) {
        if (line.productId != productId) continue;
        history.add(
          InventoryPurchaseHistory(
            invoiceNo: purchase.invoiceNo,
            supplierName: purchase.supplierName,
            purchaseDate: purchase.purchaseDate,
            quantity: line.quantity,
            unitCost: line.unitCost,
            batchCode: line.batchCode,
            expiryDate: line.expiryDate,
            sellingPrice: line.sellingPrice,
          ),
        );
      }
    }

    return InventoryProductDetail(
      product: _mapProduct(product),
      sellingPrice: product.sellingPrice,
      wholesalePrice: product.wholesalePrice,
      barcode: product.barcode,
      brand: product.brand,
      lots: lots
          .map(
            (lot) => InventoryLot(
              quantity: lot.quantity,
              receivedAt: lot.receivedAt,
              batchCode: lot.batchCode,
              expiryDate: lot.expiryDate,
              manufactureDate: lot.manufactureDate,
              unitCost: lot.unitCost,
            ),
          )
          .toList(),
      purchases: history,
    );
  }

  List<PurchaseLineItem> _decodePurchaseLines(String json) {
    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded
        .map((item) => PurchaseLineItem.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<void> adjustStock(StockAdjustRequest request) async {
    if (sl<LanModeService>().isClient) {
      throw StateError('Adjust inventory on the shop host PC.');
    }
    if (request.quantityChange == 0) {
      throw ArgumentError('Quantity change cannot be zero.');
    }

    final isar = _isarService.instance;
    final product = await isar.products.get(request.productId);
    if (product == null) {
      throw StateError('Product not found.');
    }
    if (product.deletedAt != null) {
      throw StateError(
        '${product.name} is in the Recycle Bin. Restore it before adjusting stock.',
      );
    }

    await isar.writeTxn(() async {
      if (request.quantityChange > 0) {
        if (request.purchasePrice != null) {
          product.purchasePrice = request.purchasePrice!;
        }
        if (request.sellingPrice != null) {
          product.sellingPrice = request.sellingPrice!;
        }
        if (request.wholesalePrice != null) {
          product.wholesalePrice = request.wholesalePrice!;
        }
        if (request.itemsPerBox != null && request.itemsPerBox! > 0) {
          product.itemsPerBox = request.itemsPerBox!;
        }
        await ProductBatchStore.receive(
          isar: isar,
          product: product,
          quantity: request.quantityChange,
          expiryDate: request.expiryDate ?? product.expiryDate,
          manufactureDate: request.manufactureDate,
          batchCode: request.batchCode,
          unitCost: request.purchasePrice ?? product.purchasePrice,
          note: request.note ?? request.type,
        );
      } else {
        await ProductBatchStore.deductFefo(
          isar: isar,
          product: product,
          quantity: -request.quantityChange,
        );
      }

      final refreshed = await isar.products.get(product.id);
      final nextStock = refreshed?.stock ?? 0;
      await isar.stockMovements.put(
        StockMovement()
          ..productId = product.id
          ..productName = product.name
          ..productSku = product.sku
          ..type = request.type
          ..quantityChange = request.quantityChange
          ..quantityAfter = nextStock
          ..note = _emptyToNull(request.note)
          ..createdAt = DateTime.now(),
      );
    });
  }

  Future<void> recordSaleMovement({
    required int productId,
    required int quantitySold,
    required int quantityAfter,
  }) async {
    final isar = _isarService.instance;
    final product = await isar.products.get(productId);
    if (product == null) return;

    await isar.writeTxn(() async {
      await isar.stockMovements.put(
        StockMovement()
          ..productId = product.id
          ..productName = product.name
          ..productSku = product.sku
          ..type = 'sale'
          ..quantityChange = -quantitySold
          ..quantityAfter = quantityAfter
          ..createdAt = DateTime.now(),
      );
    });
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  InventoryProduct _mapProduct(
    Product product, {
    int nextBatchNumber = 1,
    int activeBatchCount = 0,
  }) {
    return InventoryProduct(
      id: product.id,
      name: product.name,
      sku: product.sku,
      category: product.category,
      stock: product.stock,
      purchasePrice: product.purchasePrice,
      sellingPrice: product.sellingPrice,
      wholesalePrice: product.wholesalePrice,
      isActive: product.isActive,
      unit: product.unit,
      lowStockThreshold: product.lowStockThreshold,
      expiryDate: product.expiryDate,
      imagePath: product.imagePath,
      itemsPerBox: product.itemsPerBox,
      nextBatchNumber: nextBatchNumber,
      activeBatchCount: activeBatchCount,
    );
  }

  StockMovementItem _mapMovement(StockMovement movement) {
    return StockMovementItem(
      id: movement.id,
      productId: movement.productId,
      productName: movement.productName,
      productSku: movement.productSku,
      type: movement.type,
      quantityChange: movement.quantityChange,
      quantityAfter: movement.quantityAfter,
      createdAt: movement.createdAt,
      note: movement.note,
    );
  }
}
