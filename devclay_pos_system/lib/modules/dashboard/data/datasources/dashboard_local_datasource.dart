import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/lan_api/client/lan_api_client.dart';
import '../../../../core/lan_api/client/lan_connection_monitor.dart';
import '../../../../core/lan_api/lan_mode_service.dart';
import '../../../../database/collections/account.dart';
import '../../../../database/collections/app_notification.dart';
import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/customer.dart';
import '../../../../database/collections/finance_expense.dart';
import '../../../../database/collections/held_sale.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/purchase.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/collections/sale_return.dart';
import '../../../../database/isar_service.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';
import '../../../restaurant/data/datasources/restaurant_local_datasource.dart';
import '../../../sales/domain/entities/sale_entities.dart';
import '../../domain/entities/dashboard_data.dart';

class DashboardLocalDataSource {
  DashboardLocalDataSource(this._isarService);

  final IsarService _isarService;

  static const int _expirySoonDays = 30;

  Future<DashboardData> fetch() async {
    if (sl.isRegistered<LanModeService>() &&
          sl<LanModeService>().isClient) {
      return _fetchFromHost();
    }
    return _fetchLocal();
  }

  Future<DashboardData> _fetchLocal() async {
    final isar = _isarService.instance;
    final now = DateTime.now();
    final todayStart = _dayStart(now);
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    final monthStart = DateTime(now.year, now.month, 1);
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);
    final expirySoonEnd =
        todayStart.add(const Duration(days: _expirySoonDays));

    final sales = await isar.sales.where().findAll();
    final returns = await isar.saleReturns.where().findAll();
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
    var todayReceiptCount = 0;
    var voidedToday = 0.0;
    var cashMix = 0.0;
    var cardMix = 0.0;
    var walletMix = 0.0;
    var khataMix = 0.0;
    var splitMix = 0.0;
    var otherMix = 0.0;

    final hourlyBuckets = List<double>.filled(24, 0);
    final staffTotals = <String, _StaffAgg>{};
    final dailyTotals = <DateTime, _DailyTotals>{};
    final productTotalsToday = <String, _ProductTotals>{};

    for (final sale in sales) {
      final soldAt = sale.soldAt;
      final isVoided = sale.status.toLowerCase() == 'voided';
      final isToday =
          !_isBefore(soldAt, todayStart) && soldAt.isBefore(tomorrowStart);

      if (isVoided) {
        if (isToday) voidedToday += sale.total;
        continue;
      }

      final lines = _decodeLines(sale.linesJson);
      var saleProfit = 0.0;

      for (final line in lines) {
        final qty = line.quantity.round();
        final cost = (productCost[line.productId] ?? 0) * qty;
        saleProfit += line.lineTotal - cost;
      }

      if (isToday) {
        todaySales += sale.total;
        todayProfit += saleProfit;
        todayReceiptCount += 1;
        hourlyBuckets[soldAt.hour.clamp(0, 23)] += sale.total;
        if (_isKhataPayment(sale.paymentMethod)) {
          todayKhataSales += sale.total;
        }
        _accumulatePaymentMix(
          sale.paymentMethod,
          sale.total,
          onCash: (v) => cashMix += v,
          onCard: (v) => cardMix += v,
          onWallet: (v) => walletMix += v,
          onKhata: (v) => khataMix += v,
          onSplit: (v) => splitMix += v,
          onOther: (v) => otherMix += v,
        );
        final cashier = (sale.cashierName ?? '').trim().isEmpty
            ? 'Unknown'
            : sale.cashierName!.trim();
        final staff = staffTotals[cashier] ?? _StaffAgg(name: cashier);
        staffTotals[cashier] = staff.copyWith(
          amount: staff.amount + sale.total,
          receipts: staff.receipts + 1,
        );
        for (final line in lines) {
          final qty = line.quantity.round();
          productTotalsToday.update(
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

    var returnsToday = 0.0;
    for (final ret in returns) {
      if (ret.isVoid) continue;
      if (!_isBefore(ret.returnedAt, todayStart) &&
          ret.returnedAt.isBefore(tomorrowStart)) {
        returnsToday += ret.refundAmount;
      }
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
      if (expired) {
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

    final topProducts = productTotalsToday.values.toList()
      ..sort((a, b) => b.revenue.compareTo(a.revenue));

    final recentSales = sales
        .where((s) => s.status.toLowerCase() != 'voided')
        .toList()
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

    final staffSalesToday = staffTotals.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final isRestaurant =
        (settings?.storeProfile ?? '').toLowerCase() == 'restaurant';

    var openTables = 0;
    var seatedGuests = 0;
    var avgTableTurnMinutes = 0.0;
    var webOrdersPending = 0;
    var kitchenOpenTickets = 0;
    if (isRestaurant && sl.isRegistered<RestaurantLocalDataSource>()) {
      final metrics =
          await sl<RestaurantLocalDataSource>().dashboardRestaurantMetrics();
      openTables = (metrics['openTables'] as num?)?.toInt() ?? 0;
      seatedGuests = (metrics['seatedGuests'] as num?)?.toInt() ?? 0;
      avgTableTurnMinutes =
          (metrics['avgTableTurnMinutes'] as num?)?.toDouble() ?? 0;
      webOrdersPending = (metrics['webOrdersPending'] as num?)?.toInt() ?? 0;
      kitchenOpenTickets =
          (metrics['kitchenOpenTickets'] as num?)?.toInt() ?? 0;
    }

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
      todayReceiptCount: todayReceiptCount,
      avgTicket: todayReceiptCount == 0 ? 0 : todaySales / todayReceiptCount,
      voidedToday: voidedToday,
      returnsToday: returnsToday,
      paymentMix: PaymentMix(
        cash: cashMix,
        card: cardMix,
        wallet: walletMix,
        khata: khataMix,
        split: splitMix,
        other: otherMix,
      ),
      hourlySalesToday: List.generate(
        24,
        (h) => HourlySalesPoint(hour: h, amount: hourlyBuckets[h]),
      ),
      staffSalesToday: staffSalesToday
          .take(8)
          .map(
            (s) => StaffSalesItem(
              name: s.name,
              amount: s.amount,
              receipts: s.receipts,
            ),
          )
          .toList(),
      openTables: openTables,
      seatedGuests: seatedGuests,
      avgTableTurnMinutes: avgTableTurnMinutes,
      webOrdersPending: webOrdersPending,
      kitchenOpenTickets: kitchenOpenTickets,
      isRestaurant: isRestaurant,
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
          .take(8)
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

  void _accumulatePaymentMix(
    String method,
    double amount, {
    required void Function(double) onCash,
    required void Function(double) onCard,
    required void Function(double) onWallet,
    required void Function(double) onKhata,
    required void Function(double) onSplit,
    required void Function(double) onOther,
  }) {
    final lower = method.toLowerCase();
    if (lower.contains('split')) {
      onSplit(amount);
    } else if (lower.contains('khata') || lower.contains('udhar')) {
      onKhata(amount);
    } else if (lower.contains('card') ||
        lower.contains('visa') ||
        lower.contains('master')) {
      onCard(amount);
    } else if (lower.contains('wallet') ||
        lower.contains('jazz') ||
        lower.contains('easy') ||
        lower.contains('raast')) {
      onWallet(amount);
    } else if (lower.contains('cash')) {
      onCash(amount);
    } else {
      onOther(amount);
    }
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

  Future<DashboardData> _fetchFromHost() async {
    final online = await sl<LanConnectionMonitor>().refresh();
    if (!online) {
      throw StateError('Shop host offline — dashboard unavailable.');
    }
    final summary = await sl<LanApiClient>().fetchDashboardSummary();
    return mapHostDashboardSummary(summary);
  }

  /// Shared parser for host dashboard payloads (also used by tests).
  static DashboardData mapHostDashboardSummary(Map<String, dynamic> summary) {
    final seriesRaw = summary['salesSeries'];
    final salesSeries = <SalesSeriesPoint>[];
    if (seriesRaw is List) {
      for (final item in seriesRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        final dateStr = map['date'] as String?;
        if (dateStr == null) continue;
        salesSeries.add(
          SalesSeriesPoint(
            date: DateTime.tryParse(dateStr) ?? DateTime.now(),
            amount: (map['amount'] as num?)?.toDouble() ?? 0,
            profit: (map['profit'] as num?)?.toDouble() ?? 0,
          ),
        );
      }
    }

    final topRaw = summary['topProducts'];
    final topProducts = <TopProductItem>[];
    if (topRaw is List) {
      var rank = 1;
      for (final item in topRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        topProducts.add(
          TopProductItem(
            name: map['name'] as String? ?? '',
            sku: map['sku'] as String? ?? '',
            unitsSold: (map['unitsSold'] as num?)?.toInt() ?? 0,
            revenue: (map['revenue'] as num?)?.toDouble() ?? 0,
            rank: rank++,
          ),
        );
      }
    }

    final recentRaw = summary['recentSales'];
    final recentSales = <RecentSaleItem>[];
    if (recentRaw is List) {
      for (final item in recentRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        recentSales.add(
          RecentSaleItem(
            invoiceNo: map['invoiceNo'] as String? ?? '',
            customerName: map['customerName'] as String? ?? 'Walk-in',
            amount: (map['amount'] as num?)?.toDouble() ?? 0,
            paymentMethod: map['paymentMethod'] as String? ?? '',
            soldAt: DateTime.tryParse(map['soldAt'] as String? ?? '') ??
                DateTime.now(),
          ),
        );
      }
    }

    final lowRaw = summary['lowStockItems'];
    final lowStockItems = <LowStockAlert>[];
    if (lowRaw is List) {
      for (final item in lowRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        lowStockItems.add(
          LowStockAlert(
            name: map['name'] as String? ?? '',
            sku: map['sku'] as String? ?? '',
            quantity: (map['quantity'] as num?)?.toInt() ?? 0,
            reorderLevel: (map['reorderLevel'] as num?)?.toInt() ?? 0,
          ),
        );
      }
    }

    final hourlyRaw = summary['hourlySalesToday'];
    final hourly = <HourlySalesPoint>[];
    if (hourlyRaw is List) {
      for (final item in hourlyRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        hourly.add(
          HourlySalesPoint(
            hour: (map['hour'] as num?)?.toInt() ?? 0,
            amount: (map['amount'] as num?)?.toDouble() ?? 0,
          ),
        );
      }
    }

    final staffRaw = summary['staffSalesToday'];
    final staff = <StaffSalesItem>[];
    if (staffRaw is List) {
      for (final item in staffRaw) {
        if (item is! Map) continue;
        final map = Map<String, dynamic>.from(item);
        staff.add(
          StaffSalesItem(
            name: map['name'] as String? ?? '',
            amount: (map['amount'] as num?)?.toDouble() ?? 0,
            receipts: (map['receipts'] as num?)?.toInt() ?? 0,
          ),
        );
      }
    }

    final lastBackupRaw = summary['lastBackupAt'] as String?;

    return DashboardData(
      todaySales: (summary['todaySales'] as num?)?.toDouble() ?? 0,
      todayProfit: (summary['todayProfit'] as num?)?.toDouble() ?? 0,
      monthlySales: (summary['monthlySales'] as num?)?.toDouble() ?? 0,
      monthlyProfit: (summary['monthlyProfit'] as num?)?.toDouble() ?? 0,
      todaySalesChange: (summary['todaySalesChange'] as num?)?.toDouble() ?? 0,
      todayProfitChange:
          (summary['todayProfitChange'] as num?)?.toDouble() ?? 0,
      monthlySalesChange:
          (summary['monthlySalesChange'] as num?)?.toDouble() ?? 0,
      monthlyProfitChange:
          (summary['monthlyProfitChange'] as num?)?.toDouble() ?? 0,
      todayKhataSales: (summary['todayKhataSales'] as num?)?.toDouble() ?? 0,
      todayExpenses: (summary['todayExpenses'] as num?)?.toDouble() ?? 0,
      monthlyExpenses: (summary['monthlyExpenses'] as num?)?.toDouble() ?? 0,
      receivablesDue: (summary['receivables'] as num?)?.toDouble() ??
          (summary['receivablesDue'] as num?)?.toDouble() ??
          0,
      payablesDue: (summary['payablesDue'] as num?)?.toDouble() ?? 0,
      cashOnHand: (summary['cashOnHand'] as num?)?.toDouble() ?? 0,
      heldSalesCount: (summary['heldSalesCount'] as num?)?.toInt() ?? 0,
      expiredProductCount:
          (summary['expiredProductCount'] as num?)?.toInt() ?? 0,
      expiringSoonCount: (summary['expiringSoonCount'] as num?)?.toInt() ?? 0,
      lastBackupAt:
          lastBackupRaw == null ? null : DateTime.tryParse(lastBackupRaw),
      todayReceiptCount: (summary['todayReceiptCount'] as num?)?.toInt() ?? 0,
      avgTicket: (summary['avgTicket'] as num?)?.toDouble() ?? 0,
      voidedToday: (summary['voidedToday'] as num?)?.toDouble() ?? 0,
      returnsToday: (summary['returnsToday'] as num?)?.toDouble() ?? 0,
      paymentMix: PaymentMix.fromJson(
        summary['paymentMix'] is Map
            ? Map<String, dynamic>.from(summary['paymentMix'] as Map)
            : null,
      ),
      hourlySalesToday: hourly,
      staffSalesToday: staff,
      openTables: (summary['openTables'] as num?)?.toInt() ?? 0,
      seatedGuests: (summary['seatedGuests'] as num?)?.toInt() ?? 0,
      avgTableTurnMinutes:
          (summary['avgTableTurnMinutes'] as num?)?.toDouble() ?? 0,
      webOrdersPending: (summary['webOrdersPending'] as num?)?.toInt() ?? 0,
      kitchenOpenTickets: (summary['kitchenOpenTickets'] as num?)?.toInt() ?? 0,
      isRestaurant: summary['isRestaurant'] == true,
      salesSeries: salesSeries,
      topProducts: topProducts,
      recentSales: recentSales,
      lowStockItems: lowStockItems,
      expiryWatchItems: const [],
      topDebtors: const [],
      notifications: const [],
    );
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

class _StaffAgg {
  const _StaffAgg({
    required this.name,
    this.amount = 0,
    this.receipts = 0,
  });

  final String name;
  final double amount;
  final int receipts;

  _StaffAgg copyWith({double? amount, int? receipts}) {
    return _StaffAgg(
      name: name,
      amount: amount ?? this.amount,
      receipts: receipts ?? this.receipts,
    );
  }
}
