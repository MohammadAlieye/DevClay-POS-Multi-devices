import 'package:equatable/equatable.dart';

class DashboardData extends Equatable {
  const DashboardData({
    required this.todaySales,
    required this.todayProfit,
    required this.monthlySales,
    required this.monthlyProfit,
    required this.todaySalesChange,
    required this.todayProfitChange,
    required this.monthlySalesChange,
    required this.monthlyProfitChange,
    required this.todayKhataSales,
    required this.todayExpenses,
    required this.monthlyExpenses,
    required this.receivablesDue,
    required this.payablesDue,
    required this.cashOnHand,
    required this.heldSalesCount,
    required this.expiredProductCount,
    required this.expiringSoonCount,
    required this.lastBackupAt,
    required this.salesSeries,
    required this.topProducts,
    required this.recentSales,
    required this.lowStockItems,
    required this.expiryWatchItems,
    required this.topDebtors,
    required this.notifications,
  });

  final double todaySales;
  final double todayProfit;
  final double monthlySales;
  final double monthlyProfit;
  final double todaySalesChange;
  final double todayProfitChange;
  final double monthlySalesChange;
  final double monthlyProfitChange;

  /// Today's sales paid (fully or partly) via Khata / Udhar.
  final double todayKhataSales;
  final double todayExpenses;
  final double monthlyExpenses;

  /// Sum of positive customer balances (customers owe shop).
  final double receivablesDue;

  /// Sum of open purchase due amounts.
  final double payablesDue;

  /// Sum of active account balances.
  final double cashOnHand;

  final int heldSalesCount;
  final int expiredProductCount;
  final int expiringSoonCount;
  final DateTime? lastBackupAt;

  final List<SalesSeriesPoint> salesSeries;
  final List<TopProductItem> topProducts;
  final List<RecentSaleItem> recentSales;
  final List<LowStockAlert> lowStockItems;
  final List<ExpiryWatchItem> expiryWatchItems;
  final List<KhataDebtorItem> topDebtors;
  final List<DashboardNotification> notifications;

  int? get backupAgeDays {
    final at = lastBackupAt;
    if (at == null) return null;
    return DateTime.now().difference(at).inDays;
  }

  bool get backupNeedsAttention {
    final age = backupAgeDays;
    return age == null || age >= 7;
  }

  @override
  List<Object?> get props => [
        todaySales,
        todayProfit,
        monthlySales,
        monthlyProfit,
        todaySalesChange,
        todayProfitChange,
        monthlySalesChange,
        monthlyProfitChange,
        todayKhataSales,
        todayExpenses,
        monthlyExpenses,
        receivablesDue,
        payablesDue,
        cashOnHand,
        heldSalesCount,
        expiredProductCount,
        expiringSoonCount,
        lastBackupAt,
        salesSeries,
        topProducts,
        recentSales,
        lowStockItems,
        expiryWatchItems,
        topDebtors,
        notifications,
      ];
}

class SalesSeriesPoint extends Equatable {
  const SalesSeriesPoint({
    required this.date,
    required this.amount,
    required this.profit,
  });

  final DateTime date;
  final double amount;
  final double profit;

  @override
  List<Object?> get props => [date, amount, profit];
}

class TopProductItem extends Equatable {
  const TopProductItem({
    required this.name,
    required this.sku,
    required this.unitsSold,
    required this.revenue,
    required this.rank,
  });

  final String name;
  final String sku;
  final int unitsSold;
  final double revenue;
  final int rank;

  @override
  List<Object?> get props => [name, sku, unitsSold, revenue, rank];
}

class RecentSaleItem extends Equatable {
  const RecentSaleItem({
    required this.invoiceNo,
    required this.customerName,
    required this.amount,
    required this.paymentMethod,
    required this.soldAt,
  });

  final String invoiceNo;
  final String customerName;
  final double amount;
  final String paymentMethod;
  final DateTime soldAt;

  @override
  List<Object?> get props =>
      [invoiceNo, customerName, amount, paymentMethod, soldAt];
}

class LowStockAlert extends Equatable {
  const LowStockAlert({
    required this.name,
    required this.sku,
    required this.quantity,
    required this.reorderLevel,
  });

  final String name;
  final String sku;
  final int quantity;
  final int reorderLevel;

  @override
  List<Object?> get props => [name, sku, quantity, reorderLevel];
}

class ExpiryWatchItem extends Equatable {
  const ExpiryWatchItem({
    required this.name,
    required this.sku,
    required this.stock,
    required this.expiryDate,
    required this.isExpired,
  });

  final String name;
  final String sku;
  final int stock;
  final DateTime expiryDate;
  final bool isExpired;

  @override
  List<Object?> get props => [name, sku, stock, expiryDate, isExpired];
}

class KhataDebtorItem extends Equatable {
  const KhataDebtorItem({
    required this.name,
    required this.phone,
    required this.balance,
  });

  final String name;
  final String phone;
  final double balance;

  @override
  List<Object?> get props => [name, phone, balance];
}

class DashboardNotification extends Equatable {
  const DashboardNotification({
    required this.title,
    required this.body,
    required this.type,
    required this.createdAt,
    required this.isRead,
  });

  final String title;
  final String body;
  final String type;
  final DateTime createdAt;
  final bool isRead;

  @override
  List<Object?> get props => [title, body, type, createdAt, isRead];
}
