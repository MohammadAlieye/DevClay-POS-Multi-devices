import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../database/collections/account.dart';
import '../../../../database/collections/app_notification.dart';
import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/customer.dart';
import '../../../../database/collections/finance_expense.dart';
import '../../../../database/collections/held_sale.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/purchase.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/isar_service.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';
import '../../../sales/domain/entities/sale_entities.dart';
import '../../domain/entities/dashboard_data.dart';

class DashboardLocalDataSource {
  DashboardLocalDataSource(this._isarService);

  final IsarService _isarService;

  static const int _expirySoonDays = 30;

  Future<DashboardData> fetch() async {
    final isar = _isarService.instance;
    final now = DateTime.now();
    final todayStart = _dayStart(now);
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    final monthStart = DateTime(now.year, now.month, 1);
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final expirySoonEnd = todayStart.add(const Duration(days: _expirySoonDays));

    final sales = await isar.sales.where().findAll();
    final products = await isar.products.where().findAll();
    final customers = await isar.customers.where().findAll();
    final purchases = await isar.purchases.where().findAll();
    final accounts = await isar.accounts.where().findAll();
    final expenses = await isar.financeExpenses.where().findAll();
    final heldSales = await isar.heldSales.where().findAll();
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    final notifications =
        await isar.appNotifications.where().sortByCreatedAtDesc().findAll();

    final productCost = {
      for (final product in products) product.id: product.purchasePrice,
    };

    var todaySales = 0.0;
    var todayProfit = 0.0;
    var yesterdaySales = 0.0;
    var yesterdayProfit = 0.0;
    var monthlySales = 0.0;
    var monthlyProfit = 0.0;
    var lastMonthSales = 0.0;
    var lastMonthProfit = 0.0;
    var todayKhataSales = 0.0;

    final dailyTotals = <DateTime, _DailyTotals>{};
    final productTotals = <String, _ProductTotals>{};

    for (final sale in sales) {
      final soldAt = sale.soldAt;
      final lines = _decodeLines(sale.linesJson);
      var saleProfit = 0.0;

      for (final line in lines) {
        final qty = line.quantity.round();
        final cost = (productCost[line.productId] ?? 0) * qty;
        saleProfit += line.lineTotal - cost;

        productTotals.update(
          line.productSku,
          (value) => value.copyWith(
            unitsSold: value.unitsSold + qty,
            revenue: value.revenue + line.lineTotal,
          ),
          ifAbsent: () => _ProductTotals(
            name: line.productName,
            sku: line.productSku,
            unitsSold: qty,
            revenue: line.lineTotal,
          ),
        );
      }

      final isToday =
          !_isBefore(soldAt, todayStart) && soldAt.isBefore(tomorrowStart);
      if (isToday) {
        todaySales += sale.total;
        todayProfit += saleProfit;
        if (_isKhataPayment(sale.paymentMethod)) {
          todayKhataSales += sale.total;
        }
      } else if (!_isBefore(soldAt, yesterdayStart) &&
          soldAt.isBefore(todayStart)) {
        yesterdaySales += sale.total;
        yesterdayProfit += saleProfit;
      }

      if (!_isBefore(soldAt, monthStart) && soldAt.isBefore(nextMonthStart)) {
        monthlySales += sale.total;
        monthlyProfit += saleProfit;
      } else if (!_isBefore(soldAt, lastMonthStart) &&
          soldAt.isBefore(monthStart)) {
        lastMonthSales += sale.total;
        lastMonthProfit += saleProfit;
      }

      final day = _dayStart(soldAt);
      dailyTotals.update(
        day,
        (value) => value.copyWith(
          amount: value.amount + sale.total,
          profit: value.profit + saleProfit,
        ),
        ifAbsent: () => _DailyTotals(
          date: day,
          amount: sale.total,
          profit: saleProfit,
        ),
      );
    }

    var todayExpenses = 0.0;
    var monthlyExpenses = 0.0;
    for (final expense in expenses) {
      if (expense.deletedAt != null) continue;
      final entryDate = expense.entryDate;
      if (!_isBefore(entryDate, todayStart) &&
          entryDate.isBefore(tomorrowStart)) {
        todayExpenses += expense.amount;
      }
      if (!_isBefore(entryDate, monthStart) &&
          entryDate.isBefore(nextMonthStart)) {
        monthlyExpenses += expense.amount;
      }
    }

    final receivablesDue = customers
        .where((c) => c.isActive && c.balance > 0)
        .fold<double>(0, (sum, c) => sum + c.balance);

    final topDebtors = customers
        .where((c) => c.isActive && c.balance > 0)
        .toList()
      ..sort((a, b) => b.balance.compareTo(a.balance));

    final payablesDue = purchases
        .where((p) => p.dueAmount > 0.009)
        .fold<double>(0, (sum, p) => sum + p.dueAmount);

    final cashOnHand = accounts
        .where((a) => a.isActive)
        .fold<double>(0, (sum, a) => sum + a.balance);

    final heldSalesCount =
        heldSales.where((h) => h.deletedAt == null).length;

    final activeProducts = products
        .where((p) => p.isActive && p.deletedAt == null)
        .toList();

    final expiryCandidates = <ExpiryWatchItem>[];
    var expiredProductCount = 0;
    var expiringSoonCount = 0;
    for (final product in activeProducts) {
      final expiry = product.expiryDate;
      if (expiry == null) continue;
      final expiryDay = DateTime(expiry.year, expiry.month, expiry.day);
      final expired = expiryDay.isBefore(todayStart);
      final soon = !expired &&
          !expiryDay.isAfter(expirySoonEnd) &&
          product.stock > 0;
      if (expired && product.stock > 0) {
        expiredProductCount++;
        expiryCandidates.add(
          ExpiryWatchItem(
            name: product.name,
            sku: product.sku,
            stock: product.stock,
            expiryDate: expiryDay,
            isExpired: true,
          ),
        );
      } else if (soon) {
        expiringSoonCount++;
        expiryCandidates.add(
          ExpiryWatchItem(
            name: product.name,
            sku: product.sku,
            stock: product.stock,
            expiryDate: expiryDay,
            isExpired: false,
          ),
        );
      }
    }
    expiryCandidates.sort((a, b) {
      if (a.isExpired != b.isExpired) {
        return a.isExpired ? -1 : 1;
      }
      return a.expiryDate.compareTo(b.expiryDate);
    });

    final seriesStart = todayStart.subtract(const Duration(days: 13));
    final salesSeries = List.generate(14, (index) {
      final day = seriesStart.add(Duration(days: index));
      final totals = dailyTotals[day];
      return SalesSeriesPoint(
        date: day,
        amount: totals?.amount ?? 0,
        profit: totals?.profit ?? 0,
      );
    });

    final topProducts = productTotals.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    final recentSales = sales.toList()
      ..sort((a, b) => b.soldAt.compareTo(a.soldAt));

    final lowStock = activeProducts
        .where(
          (product) => isStockAtOrBelowLowThreshold(
            product.stock,
            product.lowStockThreshold,
          ),
        )
        .toList()
      ..sort((a, b) => a.stock.compareTo(b.stock));

    return DashboardData(
      todaySales: todaySales,
      todayProfit: todayProfit,
      monthlySales: monthlySales,
      monthlyProfit: monthlyProfit,
      todaySalesChange: _percentChange(todaySales, yesterdaySales),
      todayProfitChange: _percentChange(todayProfit, yesterdayProfit),
      monthlySalesChange: _percentChange(monthlySales, lastMonthSales),
      monthlyProfitChange: _percentChange(monthlyProfit, lastMonthProfit),
      todayKhataSales: todayKhataSales,
      todayExpenses: todayExpenses,
      monthlyExpenses: monthlyExpenses,
      receivablesDue: receivablesDue,
      payablesDue: payablesDue,
      cashOnHand: cashOnHand,
      heldSalesCount: heldSalesCount,
      expiredProductCount: expiredProductCount,
      expiringSoonCount: expiringSoonCount,
      lastBackupAt: settings?.lastBackupAt,
      salesSeries: salesSeries,
      topProducts: topProducts
          .take(5)
          .toList()
          .asMap()
          .entries
          .map(
            (entry) => TopProductItem(
              name: entry.value.name,
              sku: entry.value.sku,
              unitsSold: entry.value.unitsSold,
              revenue: entry.value.revenue,
              rank: entry.key + 1,
            ),
          )
          .toList(),
      recentSales: recentSales
          .take(8)
          .map(
            (sale) => RecentSaleItem(
              invoiceNo: sale.invoiceNo,
              customerName: sale.customerName,
              amount: sale.total,
              paymentMethod: sale.paymentMethod,
              soldAt: sale.soldAt,
            ),
          )
          .toList(),
      lowStockItems: lowStock
          .take(8)
          .map(
            (product) => LowStockAlert(
              name: product.name,
              sku: product.sku,
              quantity: product.stock,
              reorderLevel: resolveLowStockThreshold(product.lowStockThreshold),
            ),
          )
          .toList(),
      expiryWatchItems: expiryCandidates.take(8).toList(),
      topDebtors: topDebtors
          .take(5)
          .map(
            (c) => KhataDebtorItem(
              name: c.name,
              phone: c.phone,
              balance: c.balance,
            ),
          )
          .toList(),
      notifications: notifications
          .map(
            (entry) => DashboardNotification(
              title: entry.title,
              body: entry.body,
              type: entry.type,
              createdAt: entry.createdAt,
              isRead: entry.isRead,
            ),
          )
          .toList(),
    );
  }

  bool _isKhataPayment(String method) {
    final lower = method.toLowerCase();
    return lower.contains('khata') || lower.contains('udhar');
  }

  List<SaleLineItem> _decodeLines(String linesJson) {
    try {
      final decoded = jsonDecode(linesJson);
      if (decoded is! List) return const [];
      return decoded
          .whereType<Map>()
          .map((item) => SaleLineItem.fromJson(Map<String, dynamic>.from(item)))
          .toList();
    } catch (_) {
      return const [];
    }
  }

  DateTime _dayStart(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  bool _isBefore(DateTime value, DateTime boundary) =>
      value.isBefore(boundary);

  double _percentChange(double current, double previous) {
    if (previous == 0) return current > 0 ? 100 : 0;
    return ((current - previous) / previous) * 100;
  }
}

class _DailyTotals {
  const _DailyTotals({
    required this.date,
    required this.amount,
    required this.profit,
  });

  final DateTime date;
  final double amount;
  final double profit;

  _DailyTotals copyWith({double? amount, double? profit}) {
    return _DailyTotals(
      date: date,
      amount: amount ?? this.amount,
      profit: profit ?? this.profit,
    );
  }
}

class _ProductTotals {
  const _ProductTotals({
    required this.name,
    required this.sku,
    required this.unitsSold,
    required this.revenue,
  });

  final String name;
  final String sku;
  final int unitsSold;
  final double revenue;

  _ProductTotals copyWith({int? unitsSold, double? revenue}) {
    return _ProductTotals(
      name: name,
      sku: sku,
      unitsSold: unitsSold ?? this.unitsSold,
      revenue: revenue ?? this.revenue,
    );
  }
}
