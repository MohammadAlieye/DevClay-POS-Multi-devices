import 'package:equatable/equatable.dart';

class SaleLineItem extends Equatable {
  const SaleLineItem({
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.quantity,
    required this.unitPrice,
    required this.lineDiscount,
    required this.lineTotal,
    this.unit,
    this.quantityLabel,
    this.batchAllocations = const [],
    this.itemsPerBox = 0,
  });

  final int productId;
  final String productName;
  final String productSku;
  /// Base units for variable items (grams/ml) or piece count.
  final num quantity;
  final double unitPrice;
  final double lineDiscount;
  final double lineTotal;
  final String? unit;
  final String? quantityLabel;
  final List<Map<String, dynamic>> batchAllocations;
  final int itemsPerBox;

  String get displayQuantityText =>
      quantityLabel ??
      (quantity is int && quantity == quantity.round()
          ? '${quantity.toInt()}'
          : quantity.toString());

  String? get batchSummary {
    if (batchAllocations.isEmpty) return null;
    final parts = <String>[];
    for (final allocation in batchAllocations) {
      final rawCode = allocation['batchCode'] as String?;
      final code = rawCode?.trim().isNotEmpty == true
          ? rawCode!.trim()
          : 'Unlabelled';
      final quantity = (allocation['quantity'] as num?)?.toInt() ?? 0;
      parts.add(
        batchAllocations.length > 1 && quantity > 0
            ? '$code × $quantity'
            : code,
      );
    }
    return 'Batch ${parts.join(', ')}';
  }

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'productSku': productSku,
    'quantity': quantity,
    'unitPrice': unitPrice,
    'lineDiscount': lineDiscount,
    'lineTotal': lineTotal,
    if (unit != null) 'unit': unit,
    if (quantityLabel != null) 'quantityLabel': quantityLabel,
    if (batchAllocations.isNotEmpty) 'batchAllocations': batchAllocations,
    if (itemsPerBox > 1) 'itemsPerBox': itemsPerBox,
  };

  factory SaleLineItem.fromJson(Map<String, dynamic> json) {
    final rawAllocations = json['batchAllocations'];
    return SaleLineItem(
      productId: (json['productId'] as num?)?.toInt() ?? 0,
      productName: '${json['productName'] ?? json['name'] ?? ''}',
      productSku: '${json['productSku'] ?? json['sku'] ?? ''}',
      quantity: (json['quantity'] as num?) ?? 0,
      unitPrice: (json['unitPrice'] as num?)?.toDouble() ?? 0,
      lineDiscount: (json['lineDiscount'] as num?)?.toDouble() ?? 0,
      lineTotal: (json['lineTotal'] as num?)?.toDouble() ?? 0,
      unit: json['unit'] as String?,
      quantityLabel: json['quantityLabel'] as String?,
      batchAllocations: rawAllocations is List
          ? rawAllocations
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList()
          : const [],
      itemsPerBox: (json['itemsPerBox'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  List<Object?> get props => [
    productId,
    productName,
    productSku,
    quantity,
    unitPrice,
    lineDiscount,
    lineTotal,
    unit,
    quantityLabel,
    batchAllocations,
    itemsPerBox,
  ];
}

class SaleRecord extends Equatable {
  const SaleRecord({
    required this.id,
    required this.invoiceNo,
    required this.customerName,
    required this.paymentMethod,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.amountPaid,
    required this.changeAmount,
    required this.itemCount,
    required this.lines,
    required this.soldAt,
    this.notes,
    this.customerId,
    this.cashierId,
    this.cashierName,
    this.status = 'completed',
    this.returnedAmount = 0,
  });

  final int id;
  final String invoiceNo;
  final String customerName;
  final String paymentMethod;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final double amountPaid;
  final double changeAmount;
  final int itemCount;
  final List<SaleLineItem> lines;
  final DateTime soldAt;
  final String? notes;
  final int? customerId;
  final int? cashierId;
  final String? cashierName;
  final String status;
  final double returnedAmount;

  double get refundableAmount =>
      (total - returnedAmount).clamp(0, double.infinity).toDouble();
  double get netTotal => refundableAmount;
  double get remainingRatio =>
      total <= 0 ? 0 : (netTotal / total).clamp(0, 1).toDouble();
  bool get canReturn => refundableAmount > 0 && status != 'voided';

  bool get isToday {
    final now = DateTime.now();
    return soldAt.year == now.year &&
        soldAt.month == now.month &&
        soldAt.day == now.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final start = DateTime(
      now.year,
      now.month,
      now.day,
    ).subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 7));
    return !soldAt.isBefore(start) && soldAt.isBefore(end);
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return soldAt.year == now.year && soldAt.month == now.month;
  }

  bool isInPeriod(SalesPeriod period) {
    return switch (period) {
      SalesPeriod.all => true,
      SalesPeriod.today => isToday,
      SalesPeriod.week => isThisWeek,
      SalesPeriod.month => isThisMonth,
    };
  }

  @override
  List<Object?> get props => [
    id,
    invoiceNo,
    customerName,
    paymentMethod,
    subtotal,
    discount,
    tax,
    total,
    amountPaid,
    changeAmount,
    itemCount,
    lines,
    soldAt,
    notes,
    customerId,
    cashierId,
    cashierName,
    status,
    returnedAmount,
  ];
}

class SaleReturnLineRequest extends Equatable {
  const SaleReturnLineRequest({
    required this.productId,
    required this.quantity,
  });

  final int productId;
  final int quantity;

  @override
  List<Object?> get props => [productId, quantity];
}

class SaleReturnRequest extends Equatable {
  const SaleReturnRequest({
    required this.saleId,
    required this.lines,
    required this.reason,
    required this.approvedById,
    required this.approvedByName,
    this.isVoid = false,
  });

  final int saleId;
  final List<SaleReturnLineRequest> lines;
  final String reason;
  final int approvedById;
  final String approvedByName;
  final bool isVoid;

  @override
  List<Object?> get props => [
    saleId,
    lines,
    reason,
    approvedById,
    approvedByName,
    isVoid,
  ];
}

class SaleReturnResult extends Equatable {
  const SaleReturnResult({
    required this.returnNo,
    required this.refundAmount,
    required this.status,
  });

  final String returnNo;
  final double refundAmount;
  final String status;

  @override
  List<Object?> get props => [returnNo, refundAmount, status];
}

class SaleReturnRecord extends Equatable {
  const SaleReturnRecord({
    required this.returnNo,
    required this.invoiceNo,
    required this.customerName,
    required this.itemCount,
    required this.refundAmount,
    required this.refundMethod,
    required this.reason,
    required this.isVoid,
    required this.cashierName,
    required this.approvedByName,
    required this.returnedAt,
  });

  final String returnNo;
  final String invoiceNo;
  final String customerName;
  final int itemCount;
  final double refundAmount;
  final String refundMethod;
  final String reason;
  final bool isVoid;
  final String? cashierName;
  final String? approvedByName;
  final DateTime returnedAt;

  @override
  List<Object?> get props => [
    returnNo,
    invoiceNo,
    customerName,
    itemCount,
    refundAmount,
    refundMethod,
    reason,
    isVoid,
    cashierName,
    approvedByName,
    returnedAt,
  ];
}

class SaleReceiptData extends Equatable {
  const SaleReceiptData({
    required this.invoiceNo,
    required this.lines,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    required this.amountPaid,
    required this.changeAmount,
    required this.soldAt,
    this.customerName,
    this.notes,
    this.title = 'Sale Receipt',
    this.showSuccessIcon = false,
    this.businessName,
    this.businessAddress,
    this.businessPhone,
    this.taxNumber,
    this.receiptFooter,
    this.receiptLogoPath,
    this.receiptTerms,
    this.operatorName,
    this.counterName,
    this.systemName,
    this.fbrInvoiceEnabled = false,
    this.fbrPosFee = 1,
    this.fbrInvoiceNo,
    this.developerFooter,
    this.printedAt,
  });

  final String invoiceNo;
  final List<SaleLineItem> lines;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String paymentMethod;
  final double amountPaid;
  final double changeAmount;
  final DateTime soldAt;
  final String? customerName;
  final String? notes;
  final String title;
  final bool showSuccessIcon;
  final String? businessName;
  final String? businessAddress;
  final String? businessPhone;
  final String? taxNumber;
  final String? receiptFooter;
  final String? receiptLogoPath;
  final String? receiptTerms;
  final String? operatorName;
  final String? counterName;
  final String? systemName;
  final bool fbrInvoiceEnabled;
  final double fbrPosFee;
  final String? fbrInvoiceNo;
  final String? developerFooter;
  final DateTime? printedAt;

  int get totalItems => lines.length;

  int get totalQty =>
      lines.fold<int>(0, (sum, line) => sum + line.quantity.round());

  double get grossAmount => (total - tax).clamp(0, double.infinity);

  double get netAmount => total + (fbrInvoiceEnabled ? fbrPosFee : 0);

  factory SaleReceiptData.fromRecord(SaleRecord record) {
    return SaleReceiptData(
      invoiceNo: record.invoiceNo,
      lines: record.lines,
      subtotal: record.subtotal,
      discount: record.discount,
      tax: record.tax,
      total: record.total,
      paymentMethod: record.paymentMethod,
      amountPaid: record.amountPaid,
      changeAmount: record.changeAmount,
      soldAt: record.soldAt,
      customerName: record.customerName,
      notes: record.notes,
    );
  }

  SaleReceiptData copyWith({
    String? title,
    bool? showSuccessIcon,
    String? businessName,
    String? businessAddress,
    String? businessPhone,
    String? taxNumber,
    String? receiptFooter,
    String? receiptLogoPath,
    String? receiptTerms,
    String? operatorName,
    String? counterName,
    String? systemName,
    bool? fbrInvoiceEnabled,
    double? fbrPosFee,
    String? fbrInvoiceNo,
    String? developerFooter,
    DateTime? printedAt,
  }) {
    return SaleReceiptData(
      invoiceNo: invoiceNo,
      lines: lines,
      subtotal: subtotal,
      discount: discount,
      tax: tax,
      total: total,
      paymentMethod: paymentMethod,
      amountPaid: amountPaid,
      changeAmount: changeAmount,
      soldAt: soldAt,
      customerName: customerName,
      notes: notes,
      title: title ?? this.title,
      showSuccessIcon: showSuccessIcon ?? this.showSuccessIcon,
      businessName: businessName ?? this.businessName,
      businessAddress: businessAddress ?? this.businessAddress,
      businessPhone: businessPhone ?? this.businessPhone,
      taxNumber: taxNumber ?? this.taxNumber,
      receiptFooter: receiptFooter ?? this.receiptFooter,
      receiptLogoPath: receiptLogoPath ?? this.receiptLogoPath,
      receiptTerms: receiptTerms ?? this.receiptTerms,
      operatorName: operatorName ?? this.operatorName,
      counterName: counterName ?? this.counterName,
      systemName: systemName ?? this.systemName,
      fbrInvoiceEnabled: fbrInvoiceEnabled ?? this.fbrInvoiceEnabled,
      fbrPosFee: fbrPosFee ?? this.fbrPosFee,
      fbrInvoiceNo: fbrInvoiceNo ?? this.fbrInvoiceNo,
      developerFooter: developerFooter ?? this.developerFooter,
      printedAt: printedAt ?? this.printedAt,
    );
  }

  @override
  List<Object?> get props => [
    invoiceNo,
    lines,
    subtotal,
    discount,
    tax,
    total,
    paymentMethod,
    amountPaid,
    changeAmount,
    soldAt,
    customerName,
    notes,
    title,
    showSuccessIcon,
    businessName,
    businessAddress,
    businessPhone,
    taxNumber,
    receiptFooter,
    receiptLogoPath,
    receiptTerms,
    operatorName,
    counterName,
    systemName,
    fbrInvoiceEnabled,
    fbrPosFee,
    fbrInvoiceNo,
    developerFooter,
    printedAt,
  ];
}

enum SalesPeriod { all, today, week, month }

enum SalesViewTab { receipts, returns, products, payments, customers }

class ProductSalesSummary extends Equatable {
  const ProductSalesSummary({
    required this.productId,
    required this.productName,
    required this.productSku,
    required this.unitsSold,
    required this.revenue,
    required this.receiptCount,
  });

  final int productId;
  final String productName;
  final String productSku;
  final int unitsSold;
  final double revenue;
  final int receiptCount;

  @override
  List<Object?> get props => [
    productId,
    productName,
    productSku,
    unitsSold,
    revenue,
    receiptCount,
  ];
}

class PaymentSalesSummary extends Equatable {
  const PaymentSalesSummary({
    required this.paymentMethod,
    required this.receiptCount,
    required this.total,
  });

  final String paymentMethod;
  final int receiptCount;
  final double total;

  @override
  List<Object?> get props => [paymentMethod, receiptCount, total];
}

class CustomerSalesSummary extends Equatable {
  const CustomerSalesSummary({
    required this.customerName,
    required this.receiptCount,
    required this.total,
    required this.unitsSold,
  });

  final String customerName;
  final int receiptCount;
  final double total;
  final int unitsSold;

  @override
  List<Object?> get props => [customerName, receiptCount, total, unitsSold];
}
