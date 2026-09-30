import 'package:equatable/equatable.dart';

import '../../../../utils/measure_units.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';

enum PosStockFilter { all, expired, lowStock }

class PosBatchLot extends Equatable {
  const PosBatchLot({
    required this.id,
    required this.quantity,
    required this.receivedAt,
    this.batchCode,
    this.manufactureDate,
    this.expiryDate,
  });

  final int id;
  final String? batchCode;
  final int quantity;
  final DateTime receivedAt;
  final DateTime? manufactureDate;
  final DateTime? expiryDate;

  String get displayCode => batchCode?.trim().isNotEmpty == true
      ? batchCode!.trim()
      : 'Unlabelled batch';

  bool get isExpired {
    final expiry = expiryDate;
    if (expiry == null) return false;
    final now = DateTime.now();
    return DateTime(
      expiry.year,
      expiry.month,
      expiry.day,
    ).isBefore(DateTime(now.year, now.month, now.day));
  }

  @override
  List<Object?> get props => [
    id,
    batchCode,
    quantity,
    receivedAt,
    manufactureDate,
    expiryDate,
  ];
}

class PosProduct extends Equatable {
  const PosProduct({
    required this.id,
    required this.sku,
    required this.barcode,
    required this.name,
    required this.category,
    this.brand,
    this.manufacturer,
    this.unit,
    this.sellType = 'piece',
    this.itemsPerBox = 0,
    required this.sellingPrice,
    this.wholesalePrice = 0,
    required this.purchasePrice,
    required this.taxRate,
    required this.taxInclusive,
    required this.stock,
    this.lowStockThreshold = 0,
    this.expiryDate,
    this.imagePath,
    this.batches = const [],
    this.hasVariants = false,
    this.variants = const [],
    this.selectedVariantId,
  });

  final int id;
  final String sku;
  final String barcode;
  final String name;
  final String category;
  final String? brand;
  final String? manufacturer;
  final String? unit;
  final String sellType;
  final int itemsPerBox;
  final double sellingPrice;
  final double wholesalePrice;
  final double purchasePrice;
  final double taxRate;
  final bool taxInclusive;
  final int stock;

  /// Custom alert level; `0` means use system default.
  final int lowStockThreshold;
  final DateTime? expiryDate;
  final String? imagePath;
  final List<PosBatchLot> batches;
  final bool hasVariants;
  final List<PosVariantOption> variants;
  final int? selectedVariantId;

  /// True when [expiryDate] is before today's calendar date.
  bool get isExpired {
    final expiry = expiryDate;
    if (expiry == null) return false;
    final today = DateTime.now();
    final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
    final todayDay = DateTime(today.year, today.month, today.day);
    return expiryDay.isBefore(todayDay);
  }

  bool get isLowStock {
    if (stock <= 0) return false;
    return stock <= resolveLowStockThreshold(lowStockThreshold);
  }

  SellType get sellTypeEnum => MeasureUnits.fromKey(sellType);

  bool get isVariable => MeasureUnits.isVariableUnit(unit);

  String get formattedStock =>
      MeasureUnits.formatStock(stock, unit, sellTypeEnum);

  String get formattedRate =>
      MeasureUnits.formatRate(sellingPrice, unit, sellTypeEnum);

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
    sellType,
    itemsPerBox,
    sellingPrice,
    wholesalePrice,
    purchasePrice,
    taxRate,
    taxInclusive,
    stock,
    lowStockThreshold,
    expiryDate,
    imagePath,
    batches,
    hasVariants,
    variants,
    selectedVariantId,
  ];
}

class PosVariantOption extends Equatable {
  const PosVariantOption({
    required this.id,
    required this.size,
    required this.color,
    required this.stock,
    this.barcode,
    this.sku,
    this.priceOverride = 0,
  });

  final int id;
  final String size;
  final String color;
  final int stock;
  final String? barcode;
  final String? sku;
  final double priceOverride;

  String get label => '$size / $color';

  @override
  List<Object?> get props =>
      [id, size, color, stock, barcode, sku, priceOverride];
}

/// Line-level discount input (% or fixed Rs).
typedef LineDiscountMode = CartDiscountMode;

double resolveLineDiscountAmount({
  required double originalSubtotal,
  required double discountValue,
  required LineDiscountMode mode,
}) {
  if (discountValue <= 0 || originalSubtotal <= 0) return 0;
  return switch (mode) {
    LineDiscountMode.percent =>
      originalSubtotal * (discountValue.clamp(0, 100) / 100),
    LineDiscountMode.fixed => discountValue.clamp(0, originalSubtotal),
  };
}

double originalSubtotalFromFinalCharge({
  required double finalCharge,
  required double discountValue,
  required LineDiscountMode mode,
}) {
  if (finalCharge <= 0) return 0;
  return switch (mode) {
    LineDiscountMode.percent => () {
      final pct = discountValue.clamp(0, 100) / 100;
      if (pct >= 1) return finalCharge;
      return finalCharge / (1 - pct);
    }(),
    LineDiscountMode.fixed => finalCharge + discountValue,
  };
}

/// Caps discount so the line total never falls below purchase cost × qty.
double clampLineDiscountInput({
  required double originalSubtotal,
  required double minSubtotalBeforeTax,
  required double discountValue,
  required LineDiscountMode mode,
}) {
  final maxDiscount = (originalSubtotal - minSubtotalBeforeTax).clamp(
    0,
    double.infinity,
  );
  if (maxDiscount <= 0 || discountValue <= 0) return 0;
  final amount = resolveLineDiscountAmount(
    originalSubtotal: originalSubtotal,
    discountValue: discountValue,
    mode: mode,
  );
  if (amount <= maxDiscount + 0.0001) return discountValue;
  return switch (mode) {
    LineDiscountMode.fixed => maxDiscount.toDouble(),
    LineDiscountMode.percent => originalSubtotal > 0
        ? (maxDiscount / originalSubtotal * 100)
        : 0,
  };
}

class CartLine extends Equatable {
  const CartLine({
    required this.product,
    required this.quantity,
    this.lineDiscount = 0,
    this.lineDiscountMode = LineDiscountMode.fixed,
    this.overrideUnitPrice,
    this.overrideLineTotal,
    this.quantityLabel,
    this.isVariableSale = false,
    this.selectedBatch,
    this.batchAllocations = const [],
  });

  final PosProduct product;
  /// Base units: pieces, grams, or milliliters.
  final int quantity;
  /// Discount input: percent (e.g. 10) or fixed Rs (e.g. 100).
  final double lineDiscount;
  final LineDiscountMode lineDiscountMode;
  @Deprecated('Catalog price is always used; kept for held-sale decode only.')
  final double? overrideUnitPrice;
  final double? overrideLineTotal;
  final String? quantityLabel;
  final bool isVariableSale;
  final PosBatchLot? selectedBatch;
  final List<Map<String, dynamic>> batchAllocations;

  int get availableStock => selectedBatch?.quantity ?? product.stock;

  double get displayQuantity => MeasureUnits.fromBaseUnits(
    quantity,
    product.unit,
    product.sellTypeEnum,
  );

  double get qtyFactor =>
      isVariableSale || product.isVariable ? displayQuantity : quantity.toDouble();

  /// Always the catalog selling price — never overridden in cart.
  double get unitPrice => product.sellingPrice;

  double get originalSubtotal => unitPrice * qtyFactor;

  /// Minimum line total = purchase cost × quantity (cannot discount below this).
  double get minSubtotalBeforeTax => product.purchasePrice * qtyFactor;

  double get maxDiscountAmount {
    final margin = originalSubtotal - minSubtotalBeforeTax;
    return margin > 0 ? margin : 0;
  }

  double get effectiveLineDiscount => clampLineDiscountInput(
    originalSubtotal: originalSubtotal,
    minSubtotalBeforeTax: minSubtotalBeforeTax,
    discountValue: lineDiscount,
    mode: lineDiscountMode,
  );

  double get discountAmount => resolveLineDiscountAmount(
    originalSubtotal: originalSubtotal,
    discountValue: effectiveLineDiscount,
    mode: lineDiscountMode,
  );

  double get computedSubtotalBeforeTax {
    final raw = originalSubtotal - discountAmount;
    return raw < 0 ? 0 : raw;
  }

  double get subtotalBeforeTax =>
      overrideLineTotal ?? computedSubtotalBeforeTax;

  double get taxAmount {
    if (product.taxRate <= 0) return 0;
    if (product.taxInclusive) {
      return subtotalBeforeTax -
          (subtotalBeforeTax / (1 + product.taxRate / 100));
    }
    return subtotalBeforeTax * product.taxRate / 100;
  }

  double get lineTotal {
    if (product.taxInclusive) return subtotalBeforeTax;
    return subtotalBeforeTax + taxAmount;
  }

  int get cartCountContribution => isVariableSale ? 1 : quantity;

  String get displayQuantityText =>
      quantityLabel ??
      MeasureUnits.formatQuantity(quantity, product.unit, product.sellTypeEnum);

  CartLine withClampedDiscount() {
    final clamped = effectiveLineDiscount;
    if (clamped == lineDiscount) return this;
    return copyWith(lineDiscount: clamped);
  }

  CartLine copyWith({
    int? quantity,
    double? lineDiscount,
    LineDiscountMode? lineDiscountMode,
    double? overrideUnitPrice,
    double? overrideLineTotal,
    String? quantityLabel,
    bool? isVariableSale,
    PosBatchLot? selectedBatch,
    List<Map<String, dynamic>>? batchAllocations,
    bool clearOverrideLineTotal = false,
  }) {
    return CartLine(
      product: product,
      quantity: quantity ?? this.quantity,
      lineDiscount: lineDiscount ?? this.lineDiscount,
      lineDiscountMode: lineDiscountMode ?? this.lineDiscountMode,
      overrideUnitPrice: overrideUnitPrice ?? this.overrideUnitPrice,
      overrideLineTotal: clearOverrideLineTotal
          ? null
          : (overrideLineTotal ?? this.overrideLineTotal),
      quantityLabel: quantityLabel ?? this.quantityLabel,
      isVariableSale: isVariableSale ?? this.isVariableSale,
      selectedBatch: selectedBatch ?? this.selectedBatch,
      batchAllocations: batchAllocations ?? this.batchAllocations,
    );
  }

  @override
  List<Object?> get props => [
    product,
    quantity,
    lineDiscount,
    lineDiscountMode,
    overrideUnitPrice,
    overrideLineTotal,
    quantityLabel,
    isVariableSale,
    selectedBatch,
    batchAllocations,
  ];
}

enum CartDiscountMode { percent, fixed }

/// Resolves cart-wide discount to a rupee amount.
double resolveCartDiscountAmount(
  List<CartLine> lines,
  double cartDiscount,
  CartDiscountMode mode,
) {
  if (cartDiscount <= 0) return 0;
  return switch (mode) {
    CartDiscountMode.percent => () {
      final subtotal = lines.fold<double>(
        0,
        (sum, line) => sum + line.subtotalBeforeTax,
      );
      return subtotal * (cartDiscount.clamp(0, 100) / 100);
    }(),
    CartDiscountMode.fixed => cartDiscount,
  };
}

class CartTotals extends Equatable {
  const CartTotals({
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.itemCount,
  });

  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final int itemCount;

  @override
  List<Object?> get props => [subtotal, discount, tax, total, itemCount];
}

class HeldSaleSummary extends Equatable {
  const HeldSaleSummary({
    required this.id,
    required this.holdCode,
    required this.customerName,
    required this.heldAt,
    required this.itemCount,
    required this.total,
  });

  final int id;
  final String holdCode;
  final String? customerName;
  final DateTime heldAt;
  final int itemCount;
  final double total;

  @override
  List<Object?> get props => [
    id,
    holdCode,
    customerName,
    heldAt,
    itemCount,
    total,
  ];
}

class CompletedSale extends Equatable {
  const CompletedSale({
    required this.invoiceNo,
    required this.lines,
    required this.totals,
    required this.paymentMethod,
    required this.amountPaid,
    required this.change,
    required this.customerName,
    required this.notes,
    required this.completedAt,
  });

  final String invoiceNo;
  final List<CartLine> lines;
  final CartTotals totals;
  final String paymentMethod;
  final double amountPaid;
  final double change;
  final String? customerName;
  final String? notes;
  final DateTime completedAt;

  @override
  List<Object?> get props => [
    invoiceNo,
    lines,
    totals,
    paymentMethod,
    amountPaid,
    change,
    customerName,
    notes,
    completedAt,
  ];
}

enum PaymentMethodKind { cash, card, split, khata }

class PosCustomer extends Equatable {
  const PosCustomer({
    required this.id,
    required this.name,
    required this.phone,
    required this.balance,
  });

  final int id;
  final String name;
  final String phone;
  final double balance;

  @override
  List<Object?> get props => [id, name, phone, balance];
}
