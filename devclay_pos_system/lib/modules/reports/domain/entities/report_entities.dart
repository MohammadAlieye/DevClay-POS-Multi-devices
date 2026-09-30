import 'package:equatable/equatable.dart';

export 'report_filters.dart';
export 'report_catalog.dart';

enum ReportsViewTab { sales, profit, expenses, inventory, purchases }

class ReportSummary extends Equatable {
  const ReportSummary({
    required this.totalSales,
    required this.totalReceipts,
    required this.estimatedProfit,
    required this.totalPurchases,
    required this.totalPurchaseDue,
    required this.totalExpenses,
    required this.stockValue,
    required this.lowStockCount,
  });

  final double totalSales;
  final int totalReceipts;
  final double estimatedProfit;
  final double totalPurchases;
  final double totalPurchaseDue;
  final double totalExpenses;
  final double stockValue;
  final int lowStockCount;

  double get netEstimate => totalSales - totalPurchases - totalExpenses;

  @override
  List<Object?> get props => [
        totalSales,
        totalReceipts,
        estimatedProfit,
        totalPurchases,
        totalPurchaseDue,
        totalExpenses,
        stockValue,
        lowStockCount,
      ];
}

class ReportTrendPoint extends Equatable {
  const ReportTrendPoint({
    required this.date,
    required this.sales,
    required this.profit,
    this.purchases = 0,
    this.expenses = 0,
  });

  final DateTime date;
  final double sales;
  final double profit;
  final double purchases;
  final double expenses;

  @override
  List<Object?> get props => [date, sales, profit, purchases, expenses];
}

class ReportExpenseCategoryRow extends Equatable {
  const ReportExpenseCategoryRow({
    required this.category,
    required this.total,
    required this.count,
  });

  final String category;
  final double total;
  final int count;

  @override
  List<Object?> get props => [category, total, count];
}

class ReportProductRow extends Equatable {
  const ReportProductRow({
    required this.name,
    required this.sku,
    required this.unitsSold,
    required this.revenue,
    required this.estimatedProfit,
  });

  final String name;
  final String sku;
  final int unitsSold;
  final double revenue;
  final double estimatedProfit;

  @override
  List<Object?> get props =>
      [name, sku, unitsSold, revenue, estimatedProfit];
}

class ReportPaymentRow extends Equatable {
  const ReportPaymentRow({
    required this.method,
    required this.total,
    required this.count,
  });

  final String method;
  final double total;
  final int count;

  @override
  List<Object?> get props => [method, total, count];
}

class ReportLowStockRow extends Equatable {
  const ReportLowStockRow({
    required this.name,
    required this.sku,
    required this.stock,
    required this.value,
  });

  final String name;
  final String sku;
  final int stock;
  final double value;

  @override
  List<Object?> get props => [name, sku, stock, value];
}

class ReportCategoryRow extends Equatable {
  const ReportCategoryRow({
    required this.category,
    required this.stockValue,
    required this.productCount,
  });

  final String category;
  final double stockValue;
  final int productCount;

  @override
  List<Object?> get props => [category, stockValue, productCount];
}

class ReportsData extends Equatable {
  const ReportsData({
    required this.summary,
    required this.trend,
    required this.topProducts,
    required this.payments,
    required this.lowStock,
    required this.categories,
    this.expenseCategories = const [],
  });

  final ReportSummary summary;
  final List<ReportTrendPoint> trend;
  final List<ReportProductRow> topProducts;
  final List<ReportPaymentRow> payments;
  final List<ReportLowStockRow> lowStock;
  final List<ReportCategoryRow> categories;
  final List<ReportExpenseCategoryRow> expenseCategories;

  @override
  List<Object?> get props => [
        summary,
        trend,
        topProducts,
        payments,
        lowStock,
        categories,
        expenseCategories,
      ];
}

const int kLowStockReportThreshold = 10;
