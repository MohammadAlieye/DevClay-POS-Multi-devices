import 'package:equatable/equatable.dart';

import '../../../inventory/domain/entities/inventory_entities.dart';
import '../../../../utils/measure_units.dart';

enum PurchaseProductStockStatus { normal, lowStock, expired, outOfStock }

class SupplierItem extends Equatable {
  const SupplierItem({
    required this.id,
    required this.name,
    required this.phone,
    required this.isActive,
    this.balance = 0,
    this.email,
    this.address,
    this.notes,
  });

  final int id;
  final String name;
  final String phone;
  final bool isActive;
  final double balance;
  final String? email;
  final String? address;
  final String? notes;

  @override
  List<Object?> get props =>
      [id, name, phone, isActive, balance, email, address, notes];
}

class SupplierDraft extends Equatable {
  const SupplierDraft({
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.notes,
    this.isActive = true,
    this.openingBalance = 0,
  });

  final String name;
  final String phone;
  final String? email;
  final String? address;
  final String? notes;
  final bool isActive;

  /// Signed balance set only when creating a supplier.
  /// Positive = shop owes supplier. Negative = supplier owes shop.
  final double openingBalance;

  @override
  List<Object?> get props =>
      [name, phone, email, address, notes, isActive, openingBalance];
}

class PurchaseLineItem extends Equatable {
  const PurchaseLineItem({
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.quantity,
    required this.unitCost,
    this.manufactureDate,
    this.expiryDate,
    this.batchCode,
    this.packageQuantity,
    this.packageUnit,
    this.unitsPerPackage = 1,
    this.packageUnitCost,
    this.sellingPrice,
    this.wholesalePrice,
  });

  final int productId;
  final String productName;
  final String productSku;

  /// Base item quantity stored in inventory.
  final int quantity;

  /// Cost per base item.
  final double unitCost;
  final DateTime? manufactureDate;
  final DateTime? expiryDate;
  final String? batchCode;

  /// Packages entered by the user (e.g. 35 boxes).
  final int? packageQuantity;
  final String? packageUnit;

  /// Pieces inside one package (e.g. 6).
  final int unitsPerPackage;

  /// Cost entered per package (when buying by box).
  final double? packageUnitCost;

  /// Shop selling price per item, applied to the product catalog.
  final double? sellingPrice;
  final double? wholesalePrice;

  double get lineTotal => quantity * unitCost;

  double get lineTotalComputed {
    if (MeasureUnits.isVariableUnit(displayUnit)) {
      final perUnit = packageUnitCost ?? unitCost;
      return displayQuantity * perUnit;
    }
    return lineTotal;
  }

  int get displayQuantity => packageQuantity ?? quantity;
  String get displayUnit => packageUnit ?? 'Item';
  double get displayUnitCost => packageUnitCost ?? (unitCost * unitsPerPackage);

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'productSku': productSku,
    'quantity': quantity,
    'unitCost': unitCost,
    if (manufactureDate != null)
      'manufactureDate': manufactureDate!.toIso8601String(),
    if (expiryDate != null) 'expiryDate': expiryDate!.toIso8601String(),
    if (batchCode != null && batchCode!.isNotEmpty) 'batchCode': batchCode,
    if (packageQuantity != null) 'packageQuantity': packageQuantity,
    if (packageUnit != null) 'packageUnit': packageUnit,
    'unitsPerPackage': unitsPerPackage,
    if (packageUnitCost != null) 'packageUnitCost': packageUnitCost,
    if (sellingPrice != null) 'sellingPrice': sellingPrice,
    if (wholesalePrice != null) 'wholesalePrice': wholesalePrice,
  };

  factory PurchaseLineItem.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(String key) {
      final raw = json[key];
      if (raw is String && raw.isNotEmpty) return DateTime.tryParse(raw);
      return null;
    }

    return PurchaseLineItem(
      productId: json['productId'] as int,
      productName: json['productName'] as String,
      productSku: json['productSku'] as String,
      quantity: json['quantity'] as int,
      unitCost: (json['unitCost'] as num).toDouble(),
      manufactureDate: parseDate('manufactureDate'),
      expiryDate: parseDate('expiryDate'),
      batchCode: json['batchCode'] as String?,
      packageQuantity: json['packageQuantity'] as int?,
      packageUnit: json['packageUnit'] as String?,
      unitsPerPackage: (json['unitsPerPackage'] as num?)?.toInt() ?? 1,
      packageUnitCost: (json['packageUnitCost'] as num?)?.toDouble(),
      sellingPrice: (json['sellingPrice'] as num?)?.toDouble(),
      wholesalePrice: (json['wholesalePrice'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    productSku,
    quantity,
    unitCost,
    manufactureDate,
    expiryDate,
    batchCode,
    packageQuantity,
    packageUnit,
    unitsPerPackage,
    packageUnitCost,
    sellingPrice,
    wholesalePrice,
  ];
}

class PurchaseRecord extends Equatable {
  const PurchaseRecord({
    required this.id,
    required this.supplierId,
    required this.supplierName,
    required this.invoiceNo,
    required this.purchaseDate,
    required this.lines,
    required this.subtotal,
    required this.taxAmount,
    required this.total,
    required this.paidAmount,
    required this.dueAmount,
    required this.status,
    required this.createdAt,
    this.notes,
  });

  final int id;
  final int supplierId;
  final String supplierName;
  final String invoiceNo;
  final DateTime purchaseDate;
  final List<PurchaseLineItem> lines;
  final double subtotal;
  final double taxAmount;
  final double total;
  final double paidAmount;
  final double dueAmount;
  final String status;
  final DateTime createdAt;
  final String? notes;

  bool get isPaid => status == 'paid' || dueAmount <= 0;
  int get totalUnits => lines.fold(0, (sum, line) => sum + line.quantity);

  @override
  List<Object?> get props => [
    id,
    supplierId,
    supplierName,
    invoiceNo,
    purchaseDate,
    lines,
    subtotal,
    taxAmount,
    total,
    paidAmount,
    dueAmount,
    status,
    createdAt,
    notes,
  ];
}

class PurchaseReturnLineRequest extends Equatable {
  const PurchaseReturnLineRequest({
    required this.productId,
    required this.quantity,
  });

  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

class PurchaseReturnRequest extends Equatable {
  const PurchaseReturnRequest({
    required this.purchaseId,
    required this.lines,
    required this.reason,
  });

  final int purchaseId;
  final List<PurchaseReturnLineRequest> lines;
  final String reason;

  @override
  List<Object?> get props => [purchaseId, lines, reason];
}

class PurchaseProductOption extends Equatable {
  const PurchaseProductOption({
    required this.id,
    required this.name,
    required this.sku,
    required this.purchasePrice,
    required this.stock,
    this.unit,
    this.sellingPrice = 0,
    this.wholesalePrice = 0,
    this.itemsPerBox = 1,
    this.nextBatchNumber = 1,
    this.lowStockThreshold = 0,
    this.expiryDate,
  });

  final int id;
  final String name;
  final String sku;
  final double purchasePrice;
  final int stock;
  final String? unit;
  final double sellingPrice;
  final double wholesalePrice;
  final int itemsPerBox;

  /// Next auto batch sequence for this product (1 → B-001).
  final int nextBatchNumber;
  final int lowStockThreshold;
  final DateTime? expiryDate;

  String get suggestedBatchCode =>
      'B-${nextBatchNumber.toString().padLeft(3, '0')}';

  bool get isExpired {
    final expiry = expiryDate;
    if (expiry == null) return false;
    final today = DateTime.now();
    final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
    final todayDay = DateTime(today.year, today.month, today.day);
    return expiryDay.isBefore(todayDay);
  }

  PurchaseProductStockStatus get stockStatus {
    if (isExpired) return PurchaseProductStockStatus.expired;
    if (stock <= 0) return PurchaseProductStockStatus.outOfStock;
    if (isStockAtOrBelowLowThreshold(stock, lowStockThreshold)) {
      return PurchaseProductStockStatus.lowStock;
    }
    return PurchaseProductStockStatus.normal;
  }

  String? get statusLabel => switch (stockStatus) {
    PurchaseProductStockStatus.expired => 'Expired',
    PurchaseProductStockStatus.outOfStock => 'Out',
    PurchaseProductStockStatus.lowStock => 'Low stock',
    PurchaseProductStockStatus.normal => null,
  };

  @override
  List<Object?> get props => [
    id,
    name,
    sku,
    purchasePrice,
    stock,
    unit,
    sellingPrice,
    wholesalePrice,
    itemsPerBox,
    nextBatchNumber,
    lowStockThreshold,
    expiryDate,
  ];
}

class PurchaseDraft extends Equatable {
  const PurchaseDraft({
    required this.supplierId,
    required this.invoiceNo,
    required this.lines,
    required this.paidAmount,
    this.notes,
    this.taxAmount = 0,
  });

  final int supplierId;
  final String invoiceNo;
  final List<PurchaseLineItem> lines;
  final double paidAmount;
  final String? notes;
  final double taxAmount;

  double get subtotal => lines.fold(0, (sum, line) => sum + line.lineTotal);

  double get total => subtotal + taxAmount;

  @override
  List<Object?> get props => [
    supplierId,
    invoiceNo,
    lines,
    paidAmount,
    notes,
    taxAmount,
  ];
}
