import 'package:equatable/equatable.dart';

import '../../../inventory/domain/entities/inventory_entities.dart';

class ProductItem extends Equatable {
  const ProductItem({
    required this.id,
    required this.sku,
    required this.barcode,
    required this.name,
    required this.category,
    required this.sellingPrice,
    required this.purchasePrice,
    required this.taxRate,
    required this.taxInclusive,
    required this.stock,
    required this.isActive,
    this.brand,
    this.manufacturer,
    this.unit,
    this.wholesalePrice = 0,
    this.lowStockThreshold = 0,
    this.manufactureDate,
    this.expiryDate,
    this.imagePath,
  });

  final int id;
  final String sku;
  final String barcode;
  final String name;
  final String category;
  final String? brand;
  final String? manufacturer;
  final String? unit;
  final double sellingPrice;
  final double wholesalePrice;
  final double purchasePrice;
  final double taxRate;
  final bool taxInclusive;
  final int stock;
  final bool isActive;
  /// Custom alert level; `0` means use system default.
  final int lowStockThreshold;
  final DateTime? manufactureDate;
  final DateTime? expiryDate;
  final String? imagePath;

  bool get isExpired {
    final expiry = expiryDate;
    if (expiry == null) return false;
    final today = DateTime.now();
    final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
    final todayDay = DateTime(today.year, today.month, today.day);
    return expiryDay.isBefore(todayDay);
  }

  /// Expires within [days] (inclusive), not already expired.
  bool isExpiringSoon({int days = 30}) {
    final expiry = expiryDate;
    if (expiry == null || isExpired) return false;
    final today = DateTime.now();
    final todayDay = DateTime(today.year, today.month, today.day);
    final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
    final limit = todayDay.add(Duration(days: days));
    return !expiryDay.isAfter(limit);
  }

  bool get isLowStock =>
      isStockAtOrBelowLowThreshold(stock, lowStockThreshold);

  bool get isOutOfStock => stock <= 0;

  ProductItem copyWith({
    String? sku,
    String? barcode,
    String? name,
    String? category,
    String? brand,
    String? manufacturer,
    String? unit,
    double? sellingPrice,
    double? wholesalePrice,
    double? purchasePrice,
    double? taxRate,
    bool? taxInclusive,
    int? stock,
    bool? isActive,
    int? lowStockThreshold,
    DateTime? manufactureDate,
    DateTime? expiryDate,
    String? imagePath,
    bool clearImage = false,
  }) {
    return ProductItem(
      id: id,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      name: name ?? this.name,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      manufacturer: manufacturer ?? this.manufacturer,
      unit: unit ?? this.unit,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      wholesalePrice: wholesalePrice ?? this.wholesalePrice,
      purchasePrice: purchasePrice ?? this.purchasePrice,
      taxRate: taxRate ?? this.taxRate,
      taxInclusive: taxInclusive ?? this.taxInclusive,
      stock: stock ?? this.stock,
      isActive: isActive ?? this.isActive,
      lowStockThreshold: lowStockThreshold ?? this.lowStockThreshold,
      manufactureDate: manufactureDate ?? this.manufactureDate,
      expiryDate: expiryDate ?? this.expiryDate,
      imagePath: clearImage ? null : (imagePath ?? this.imagePath),
    );
  }

  @override
  List<Object?> get props => [
        id,
        sku,
        barcode,
        name,
        category,
        brand,
        manufacturer,
        unit,
        sellingPrice,
        wholesalePrice,
        purchasePrice,
        taxRate,
        taxInclusive,
        stock,
        isActive,
        lowStockThreshold,
        manufactureDate,
        expiryDate,
        imagePath,
      ];
}

class ProductDraft extends Equatable {
  const ProductDraft({
    required this.sku,
    required this.barcode,
    required this.name,
    required this.category,
    required this.taxRate,
    required this.taxInclusive,
    required this.isActive,
    this.brand,
    this.manufacturer,
    this.unit,
    this.lowStockThreshold = 0,
    this.imagePath,
    this.pendingImageSourcePath,
    this.clearImage = false,
  });

  final String sku;
  final String barcode;
  final String name;
  final String category;
  final String? brand;
  final String? manufacturer;
  final String? unit;
  final double taxRate;
  final bool taxInclusive;
  final bool isActive;
  final int lowStockThreshold;
  final String? imagePath;
  final String? pendingImageSourcePath;
  final bool clearImage;

  @override
  List<Object?> get props => [
        sku,
        barcode,
        name,
        category,
        brand,
        manufacturer,
        unit,
        taxRate,
        taxInclusive,
        isActive,
        lowStockThreshold,
        imagePath,
        pendingImageSourcePath,
        clearImage,
      ];
}
