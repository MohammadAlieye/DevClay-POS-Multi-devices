import 'package:equatable/equatable.dart';

import '../../../../utils/measure_units.dart';

class InventoryProduct extends Equatable {
  const InventoryProduct({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.stock,
    required this.purchasePrice,
    required this.sellingPrice,
    required this.wholesalePrice,
    required this.isActive,
    this.unit,
    this.lowStockThreshold = 0,
    this.expiryDate,
    this.imagePath,
    this.itemsPerBox = 0,
    this.nextBatchNumber = 1,
    this.activeBatchCount = 0,
  });

  final int id;
  final String name;
  final String sku;
  final String category;

  /// Stock in base units (pcs / g / ml / mm).
  final int stock;
  final double purchasePrice;
  final double sellingPrice;
  final double wholesalePrice;
  final bool isActive;
  final String? unit;

  /// Custom alert level; `0` means use [kLowStockThreshold].
  final int lowStockThreshold;
  final DateTime? expiryDate;
  final String? imagePath;
  final int itemsPerBox;

  /// Next automatic batch sequence (1 becomes B-001).
  final int nextBatchNumber;
  final int activeBatchCount;

  String get suggestedBatchCode =>
      'B-${nextBatchNumber.toString().padLeft(3, '0')}';

  SellType get sellType => MeasureUnits.inferSellType(unit);

  bool get isVariable => MeasureUnits.isVariableUnit(unit);

  /// Human-facing quantity (e.g. 2 m, not 2000 mm).
  double get displayStock =>
      MeasureUnits.fromBaseUnits(stock, unit, sellType);

  String get formattedStock =>
      MeasureUnits.formatQuantity(stock, unit, sellType);

  /// Inventory value using purchase price per display unit (Rs/m, Rs/L, Rs/pc).
  double get stockValue => displayStock * purchasePrice;
  int get effectiveLowStockThreshold =>
      resolveLowStockThreshold(lowStockThreshold);
  bool get isLowStock => isStockAtOrBelowLowThreshold(stock, lowStockThreshold);
  bool get isOutOfStock => stock <= 0;

  bool get isExpired {
    final expiry = expiryDate;
    if (expiry == null) return false;
    final today = DateTime.now();
    final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
    final todayDay = DateTime(today.year, today.month, today.day);
    return expiryDay.isBefore(todayDay);
  }

  bool isExpiringSoon({int days = 30}) {
    final expiry = expiryDate;
    if (expiry == null || isExpired) return false;
    final today = DateTime.now();
    final todayDay = DateTime(today.year, today.month, today.day);
    final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
    final limit = todayDay.add(Duration(days: days));
    return !expiryDay.isAfter(limit);
  }

  @override
  List<Object?> get props => [
    id,
    name,
    sku,
    category,
    stock,
    purchasePrice,
    sellingPrice,
    wholesalePrice,
    isActive,
    unit,
    lowStockThreshold,
    expiryDate,
    imagePath,
    itemsPerBox,
    nextBatchNumber,
    activeBatchCount,
  ];
}

class InventoryPurchaseHistory extends Equatable {
  const InventoryPurchaseHistory({
    required this.invoiceNo,
    required this.supplierName,
    required this.purchaseDate,
    required this.quantity,
    required this.unitCost,
    this.batchCode,
    this.expiryDate,
    this.sellingPrice,
  });

  final String invoiceNo;
  final String supplierName;
  final DateTime purchaseDate;
  final int quantity;
  final double unitCost;
  final String? batchCode;
  final DateTime? expiryDate;
  final double? sellingPrice;

  @override
  List<Object?> get props => [
    invoiceNo,
    supplierName,
    purchaseDate,
    quantity,
    unitCost,
    batchCode,
    expiryDate,
    sellingPrice,
  ];
}

class InventoryLot extends Equatable {
  const InventoryLot({
    required this.quantity,
    required this.receivedAt,
    this.batchCode,
    this.expiryDate,
    this.manufactureDate,
    this.unitCost = 0,
  });

  final int quantity;
  final DateTime receivedAt;
  final String? batchCode;
  final DateTime? expiryDate;
  final DateTime? manufactureDate;
  final double unitCost;

  @override
  List<Object?> get props => [
    quantity,
    receivedAt,
    batchCode,
    expiryDate,
    manufactureDate,
    unitCost,
  ];
}

class InventoryProductDetail extends Equatable {
  const InventoryProductDetail({
    required this.product,
    required this.sellingPrice,
    required this.wholesalePrice,
    required this.lots,
    required this.purchases,
    this.barcode,
    this.brand,
  });

  final InventoryProduct product;
  final double sellingPrice;
  final double wholesalePrice;
  final String? barcode;
  final String? brand;
  final List<InventoryLot> lots;
  final List<InventoryPurchaseHistory> purchases;

  @override
  List<Object?> get props => [
    product,
    sellingPrice,
    wholesalePrice,
    barcode,
    brand,
    lots,
    purchases,
  ];
}

class StockMovementItem extends Equatable {
  const StockMovementItem({
    required this.id,
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.type,
    required this.quantityChange,
    required this.quantityAfter,
    required this.createdAt,
    this.note,
  });

  final int id;
  final int productId;
  final String productName;
  final String productSku;
  final String type;
  final int quantityChange;
  final int quantityAfter;
  final DateTime createdAt;
  final String? note;

  @override
  List<Object?> get props => [
    id,
    productId,
    productName,
    productSku,
    type,
    quantityChange,
    quantityAfter,
    createdAt,
    note,
  ];
}

class StockAdjustRequest extends Equatable {
  const StockAdjustRequest({
    required this.productId,
    required this.quantityChange,
    required this.type,
    this.note,
    this.expiryDate,
    this.manufactureDate,
    this.batchCode,
    this.purchasePrice,
    this.sellingPrice,
    this.wholesalePrice,
    this.itemsPerBox,
  });

  final int productId;
  final int quantityChange;
  final String type;
  final String? note;

  /// Used when adding stock / setting opening stock for the new lot.
  final DateTime? expiryDate;
  final DateTime? manufactureDate;
  final String? batchCode;
  final double? purchasePrice;
  final double? sellingPrice;
  final double? wholesalePrice;
  final int? itemsPerBox;

  @override
  List<Object?> get props => [
    productId,
    quantityChange,
    type,
    note,
    expiryDate,
    manufactureDate,
    batchCode,
    purchasePrice,
    sellingPrice,
    wholesalePrice,
    itemsPerBox,
  ];
}

/// Default low-stock alert level when a product has no custom threshold.
const int kLowStockThreshold = 10;

/// Resolves a product's alert level. Custom `> 0` wins; otherwise default.
int resolveLowStockThreshold(int customThreshold) {
  return customThreshold > 0 ? customThreshold : kLowStockThreshold;
}

bool isStockAtOrBelowLowThreshold(int stock, int customThreshold) {
  return stock <= resolveLowStockThreshold(customThreshold);
}
