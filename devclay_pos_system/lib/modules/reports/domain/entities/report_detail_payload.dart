import 'package:equatable/equatable.dart';

import 'report_entities.dart';

/// Unified payload for any report detail page.
class ReportDetailPayload extends Equatable {
  const ReportDetailPayload({
    required this.summary,
    this.trend = const [],
    this.topProducts = const [],
    this.payments = const [],
    this.lowStock = const [],
    this.categories = const [],
    this.expenseCategories = const [],
    this.salesMetrics,
    this.profitMetrics,
    this.expenseMetrics,
    this.inventoryMetrics,
    this.purchaseMetrics,
    this.salesByCategory = const [],
    this.salesByCashier = const [],
    this.profitByCategory = const [],
    this.expenseHistory = const [],
    this.stockMovementRows = const [],
    this.outOfStock = const [],
    this.expiryRows = const [],
    this.velocityRows = const [],
    this.supplierRows = const [],
    this.customerRows = const [],
    this.discountRows = const [],
    this.taxRows = const [],
    this.taxTrend = const [],
    this.purchaseHistory = const [],
    this.customerLedgerRows = const [],
    this.adjustmentRows = const [],
    this.usedBatchCost = false,
  });

  final ReportSummary summary;
  final List<ReportTrendPoint> trend;
  final List<ReportProductRow> topProducts;
  final List<ReportPaymentRow> payments;
  final List<ReportLowStockRow> lowStock;
  final List<ReportCategoryRow> categories;
  final List<ReportExpenseCategoryRow> expenseCategories;

  final SalesReportMetrics? salesMetrics;
  final ProfitReportMetrics? profitMetrics;
  final ExpenseReportMetrics? expenseMetrics;
  final InventoryReportMetrics? inventoryMetrics;
  final PurchaseReportMetrics? purchaseMetrics;

  final List<ReportCategorySalesRow> salesByCategory;
  final List<ReportNamedAmountRow> salesByCashier;
  final List<ReportCategoryProfitRow> profitByCategory;
  final List<ReportExpenseHistoryRow> expenseHistory;
  final List<ReportStockMovementRow> stockMovementRows;
  final List<ReportLowStockRow> outOfStock;
  final List<ReportExpiryRow> expiryRows;
  final List<ReportVelocityRow> velocityRows;
  final List<ReportSupplierRow> supplierRows;
  final List<ReportCustomerRow> customerRows;
  final List<ReportDiscountRow> discountRows;
  final List<ReportTaxRow> taxRows;
  final List<ReportTrendPoint> taxTrend;
  final List<ReportPurchaseHistoryRow> purchaseHistory;
  final List<ReportCustomerBalanceRow> customerLedgerRows;
  final List<ReportStockMovementRow> adjustmentRows;

  /// True when profit used batch/FEFO costs instead of only catalog cost.
  final bool usedBatchCost;

  /// Backward-compatible aggregate for legacy tab widgets.
  ReportsData get legacyData => ReportsData(
        summary: summary,
        trend: trend,
        topProducts: topProducts,
        payments: payments,
        lowStock: lowStock,
        categories: categories,
        expenseCategories: expenseCategories,
      );

  @override
  List<Object?> get props => [
        summary,
        trend,
        topProducts,
        payments,
        lowStock,
        categories,
        expenseCategories,
        salesMetrics,
        profitMetrics,
        expenseMetrics,
        inventoryMetrics,
        purchaseMetrics,
        usedBatchCost,
      ];
}

class SalesReportMetrics extends Equatable {
  const SalesReportMetrics({
    required this.grossSales,
    required this.discounts,
    required this.returns,
    required this.netSales,
    required this.receiptCount,
    required this.averageTransaction,
    required this.taxCollected,
  });

  final double grossSales;
  final double discounts;
  final double returns;
  final double netSales;
  final int receiptCount;
  final double averageTransaction;
  final double taxCollected;

  @override
  List<Object?> get props =>
      [grossSales, discounts, returns, netSales, receiptCount, averageTransaction, taxCollected];
}

class ProfitReportMetrics extends Equatable {
  const ProfitReportMetrics({
    required this.grossSales,
    required this.discounts,
    required this.returns,
    required this.cogs,
    required this.grossProfit,
    required this.expenses,
    required this.netProfit,
    required this.grossMarginPct,
    required this.netMarginPct,
  });

  final double grossSales;
  final double discounts;
  final double returns;
  final double cogs;
  final double grossProfit;
  final double expenses;
  final double netProfit;
  final double grossMarginPct;
  final double netMarginPct;

  @override
  List<Object?> get props =>
      [grossSales, discounts, returns, cogs, grossProfit, expenses, netProfit, grossMarginPct, netMarginPct];
}

class ExpenseReportMetrics extends Equatable {
  const ExpenseReportMetrics({
    required this.totalExpenses,
    required this.expenseCount,
  });

  final double totalExpenses;
  final int expenseCount;

  @override
  List<Object?> get props => [totalExpenses, expenseCount];
}

class InventoryReportMetrics extends Equatable {
  const InventoryReportMetrics({
    required this.activeProducts,
    required this.totalUnits,
    required this.stockValueAtCost,
    required this.lowStockCount,
    required this.outOfStockCount,
    required this.expiringSoonCount,
    required this.expiredCount,
  });

  final int activeProducts;
  final int totalUnits;
  final double stockValueAtCost;
  final int lowStockCount;
  final int outOfStockCount;
  final int expiringSoonCount;
  final int expiredCount;

  @override
  List<Object?> get props => [
        activeProducts,
        totalUnits,
        stockValueAtCost,
        lowStockCount,
        outOfStockCount,
        expiringSoonCount,
        expiredCount,
      ];
}

class PurchaseReportMetrics extends Equatable {
  const PurchaseReportMetrics({
    required this.totalPurchases,
    required this.paidAmount,
    required this.outstandingAmount,
    required this.purchaseCount,
  });

  final double totalPurchases;
  final double paidAmount;
  final double outstandingAmount;
  final int purchaseCount;

  @override
  List<Object?> get props =>
      [totalPurchases, paidAmount, outstandingAmount, purchaseCount];
}

class ReportCategorySalesRow extends Equatable {
  const ReportCategorySalesRow({
    required this.category,
    required this.revenue,
    required this.units,
  });

  final String category;
  final double revenue;
  final int units;

  @override
  List<Object?> get props => [category, revenue, units];
}

class ReportCategoryProfitRow extends Equatable {
  const ReportCategoryProfitRow({
    required this.category,
    required this.revenue,
    required this.profit,
  });

  final String category;
  final double revenue;
  final double profit;

  @override
  List<Object?> get props => [category, revenue, profit];
}

class ReportNamedAmountRow extends Equatable {
  const ReportNamedAmountRow({
    required this.name,
    required this.amount,
    this.count = 0,
  });

  final String name;
  final double amount;
  final int count;

  @override
  List<Object?> get props => [name, amount, count];
}

class ReportExpenseHistoryRow extends Equatable {
  const ReportExpenseHistoryRow({
    required this.date,
    required this.category,
    required this.amount,
    required this.note,
  });

  final DateTime date;
  final String category;
  final double amount;
  final String note;

  @override
  List<Object?> get props => [date, category, amount, note];
}

class ReportStockMovementRow extends Equatable {
  const ReportStockMovementRow({
    required this.date,
    required this.productName,
    required this.sku,
    required this.type,
    required this.quantityChange,
    required this.quantityAfter,
    this.note,
  });

  final DateTime date;
  final String productName;
  final String sku;
  final String type;
  final int quantityChange;
  final int quantityAfter;
  final String? note;

  @override
  List<Object?> get props =>
      [date, productName, sku, type, quantityChange, quantityAfter, note];
}

class ReportExpiryRow extends Equatable {
  const ReportExpiryRow({
    required this.productName,
    required this.sku,
    required this.batchCode,
    required this.quantity,
    required this.unit,
    required this.expiryDate,
    required this.daysRemaining,
    required this.unitCost,
    required this.stockValue,
    required this.supplierName,
  });

  final String productName;
  final String sku;
  final String batchCode;
  final int quantity;
  final String unit;
  final DateTime? expiryDate;
  final int daysRemaining;
  final double unitCost;
  final double stockValue;
  final String supplierName;

  @override
  List<Object?> get props =>
      [productName, sku, batchCode, quantity, unit, expiryDate, daysRemaining, unitCost, stockValue, supplierName];
}

class ReportVelocityRow extends Equatable {
  const ReportVelocityRow({
    required this.name,
    required this.sku,
    required this.unitsSold,
    required this.revenue,
    required this.stock,
    required this.daysSinceLastSale,
  });

  final String name;
  final String sku;
  final int unitsSold;
  final double revenue;
  final int stock;
  final int? daysSinceLastSale;

  @override
  List<Object?> get props =>
      [name, sku, unitsSold, revenue, stock, daysSinceLastSale];
}

class ReportSupplierRow extends Equatable {
  const ReportSupplierRow({
    required this.supplierName,
    required this.purchaseTotal,
    required this.purchaseCount,
    required this.outstanding,
  });

  final String supplierName;
  final double purchaseTotal;
  final int purchaseCount;
  final double outstanding;

  @override
  List<Object?> get props => [supplierName, purchaseTotal, purchaseCount, outstanding];
}

class ReportCustomerRow extends Equatable {
  const ReportCustomerRow({
    required this.customerName,
    required this.receiptCount,
    required this.total,
    required this.units,
  });

  final String customerName;
  final int receiptCount;
  final double total;
  final int units;

  @override
  List<Object?> get props => [customerName, receiptCount, total, units];
}

class ReportDiscountRow extends Equatable {
  const ReportDiscountRow({
    required this.label,
    required this.discountAmount,
    required this.saleTotal,
    required this.date,
  });

  final String label;
  final double discountAmount;
  final double saleTotal;
  final DateTime date;

  @override
  List<Object?> get props => [label, discountAmount, saleTotal, date];
}

class ReportTaxRow extends Equatable {
  const ReportTaxRow({
    required this.label,
    required this.taxAmount,
    required this.salesTotal,
  });

  final String label;
  final double taxAmount;
  final double salesTotal;

  @override
  List<Object?> get props => [label, taxAmount, salesTotal];
}

class ReportPurchaseHistoryRow extends Equatable {
  const ReportPurchaseHistoryRow({
    required this.invoiceNo,
    required this.supplierName,
    required this.date,
    required this.total,
    required this.paid,
    required this.due,
    required this.status,
  });

  final String invoiceNo;
  final String supplierName;
  final DateTime date;
  final double total;
  final double paid;
  final double due;
  final String status;

  @override
  List<Object?> get props => [invoiceNo, supplierName, date, total, paid, due, status];
}

class ReportCustomerBalanceRow extends Equatable {
  const ReportCustomerBalanceRow({
    required this.customerName,
    required this.balance,
    required this.creditLimit,
    required this.phone,
  });

  final String customerName;
  final double balance;
  final double creditLimit;
  final String phone;

  @override
  List<Object?> get props => [customerName, balance, creditLimit, phone];
}

class ReportFilterOptions extends Equatable {
  const ReportFilterOptions({
    this.categories = const [],
    this.paymentMethods = const [],
    this.suppliers = const [],
    this.customers = const [],
    this.products = const [],
  });

  final List<String> categories;
  final List<String> paymentMethods;
  final List<(int id, String name)> suppliers;
  final List<(int id, String name)> customers;
  final List<(int id, String name)> products;

  @override
  List<Object?> get props =>
      [categories, paymentMethods, suppliers, customers, products];
}
