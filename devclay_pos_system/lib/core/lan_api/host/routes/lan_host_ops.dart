import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../database/collections/account.dart';
import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/customer.dart';
import '../../../../database/collections/customer_ledger_entry.dart';
import '../../../../database/collections/finance_expense.dart';
import '../../../../database/collections/held_sale.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/purchase.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/collections/sale_return.dart';
import '../../../../database/collections/stock_movement.dart';
import '../../../../database/isar_service.dart';
import '../../../../database/product_batch_store.dart';
import '../../../../modules/sales/domain/entities/sale_entities.dart';
import '../../../auth/retail_actor.dart';
import '../../lan_api_errors.dart';

/// Host-side ops used by LAN routes (held bills, khata pay, returns, summary).
class LanHostOps {
  LanHostOps(this._isarService);

  final IsarService _isarService;

  Isar get _isar => _isarService.instance;

  Future<List<Map<String, dynamic>>> listHeldSales() async {
    final held = await _isar.heldSales
        .filter()
        .deletedAtIsNull()
        .sortByHeldAtDesc()
        .findAll();
    return [
      for (final h in held)
        {
          'id': h.id,
          'holdCode': h.holdCode,
          'customerId': h.customerId,
          'customerName': h.customerName,
          'notes': h.notes,
          'itemsJson': h.itemsJson,
          'discountAmount': h.discountAmount,
          'discountIsPercent': h.discountIsPercent,
          'heldAt': h.heldAt.toIso8601String(),
          'itemCount': _heldItemCount(h.itemsJson),
        },
    ];
  }

  Future<Map<String, dynamic>?> getHeldSale(int id) async {
    final h = await _isar.heldSales.get(id);
    if (h == null || h.deletedAt != null) return null;
    return {
      'id': h.id,
      'holdCode': h.holdCode,
      'customerId': h.customerId,
      'customerName': h.customerName,
      'notes': h.notes,
      'itemsJson': h.itemsJson,
      'discountAmount': h.discountAmount,
      'discountIsPercent': h.discountIsPercent,
      'heldAt': h.heldAt.toIso8601String(),
    };
  }

  Future<Map<String, dynamic>> createHeldSale(Map<String, dynamic> body) async {
    final itemsJson = '${body['itemsJson'] ?? ''}';
    if (itemsJson.isEmpty || itemsJson == '[]') {
      throw LanApiException('Held sale lines required', code: 'invalid_lines');
    }
    final code = '${body['holdCode'] ?? ''}'.trim().isNotEmpty
        ? '${body['holdCode']}'.trim()
        : 'H-${DateTime.now().millisecondsSinceEpoch % 100000}';
    late int id;
    final now = DateTime.now();
    await _isar.writeTxn(() async {
      id = await _isar.heldSales.put(
        HeldSale()
          ..holdCode = code
          ..customerId = (body['customerId'] as num?)?.toInt()
          ..customerName = body['customerName'] as String?
          ..notes = body['notes'] as String?
          ..itemsJson = itemsJson
          ..discountAmount =
              (body['discountAmount'] as num?)?.toDouble() ?? 0
          ..discountIsPercent = body['discountIsPercent'] != false
          ..heldAt = now,
      );
    });
    return {
      'id': id,
      'holdCode': code,
      'heldAt': now.toIso8601String(),
      'itemCount': _heldItemCount(itemsJson),
    };
  }

  Future<void> deleteHeldSale(int id) async {
    await _isar.writeTxn(() async {
      final held = await _isar.heldSales.get(id);
      if (held == null) return;
      held.deletedAt = DateTime.now();
      await _isar.heldSales.put(held);
    });
  }

  Future<Map<String, dynamic>> recordCustomerPayment({
    required int customerId,
    required double amount,
    String? note,
  }) async {
    if (amount <= 0) {
      throw LanApiException(
        'Payment amount must be greater than zero',
        code: 'invalid_amount',
      );
    }
    final customer = await _isar.customers.get(customerId);
    if (customer == null || !customer.isActive) {
      throw LanApiException('Customer not found', code: 'customer_missing');
    }
    final now = DateTime.now();
    late double nextBalance;
    await _isar.writeTxn(() async {
      nextBalance = customer.balance - amount;
      customer.balance = nextBalance;
      await _isar.customers.put(customer);
      await _isar.customerLedgerEntrys.put(
        CustomerLedgerEntry()
          ..customerId = customer.id
          ..customerName = customer.name
          ..type = 'credit'
          ..amount = amount
          ..balanceAfter = nextBalance
          ..note = (note?.trim().isNotEmpty == true)
              ? note!.trim()
              : 'Payment received (LAN)'
          ..entryDate = now
          ..createdAt = now,
      );
    });
    return {
      'id': customer.id,
      'name': customer.name,
      'balance': nextBalance,
    };
  }

  Future<Map<String, dynamic>> processReturn({
    required int saleId,
    required Map<String, dynamic> body,
  }) async {
    final reason = '${body['reason'] ?? ''}'.trim();
    if (reason.isEmpty) {
      throw LanApiException('Return reason is required', code: 'invalid_reason');
    }
    final linesRaw = body['lines'];
    if (linesRaw is! List || linesRaw.isEmpty) {
      throw LanApiException('Select items to return', code: 'invalid_lines');
    }
    final isVoid = body['isVoid'] == true;
    final approvedById = (body['approvedById'] as num?)?.toInt() ?? 0;
    final approvedByName = '${body['approvedByName'] ?? 'Manager'}';

    final sale = await _isar.sales.get(saleId);
    if (sale == null) {
      throw LanApiException('Original sale not found', code: 'sale_missing');
    }
    if (sale.status == 'voided') {
      throw LanApiException('Sale is already voided', code: 'sale_voided');
    }

    final originalLines = _decodeSaleLines(sale.linesJson);
    final requested = <({SaleLineItem line, int quantity})>[];
    for (final raw in linesRaw) {
      if (raw is! Map) continue;
      final map = Map<String, dynamic>.from(raw);
      final productId = (map['productId'] as num?)?.toInt();
      final qty = (map['quantity'] as num?)?.toInt() ?? 0;
      if (productId == null || qty <= 0) {
        throw LanApiException('Invalid return quantity', code: 'invalid_line');
      }
      final line = originalLines
          .where((item) => item.productId == productId)
          .firstOrNull;
      if (line == null) {
        throw LanApiException('Line not on sale', code: 'invalid_line');
      }
      if (qty > line.quantity) {
        throw LanApiException(
          'Only ${line.quantity} ${line.productName} can be returned',
          code: 'invalid_qty',
        );
      }
      requested.add((line: line, quantity: qty));
    }

    final originalWeight = originalLines.fold<double>(
      0,
      (sum, line) => sum + line.lineTotal,
    );
    final selectedWeight = requested.fold<double>(
      0,
      (sum, item) =>
          sum + (item.line.lineTotal * item.quantity / item.line.quantity),
    );
    final refund = originalWeight <= 0
        ? 0.0
        : (sale.total * selectedWeight / originalWeight)
            .clamp(0, sale.total - sale.returnedAmount)
            .toDouble();
    if (refund <= 0) {
      throw LanApiException(
        'Return has no refundable amount',
        code: 'no_refund',
      );
    }

    final now = DateTime.now();
    final returnNo = 'RET-${now.microsecondsSinceEpoch}';
    final returnPayload = <Map<String, dynamic>>[];

    await _isar.writeTxn(() async {
      for (final item in requested) {
        final product = await _isar.products.get(item.line.productId);
        if (product == null) {
          throw LanApiException(
            '${item.line.productName} no longer exists',
            code: 'product_missing',
          );
        }
        await ProductBatchStore.receive(
          isar: _isar,
          product: product,
          quantity: item.quantity,
          note: 'LAN return $returnNo',
        );
        await _isar.stockMovements.put(
          StockMovement()
            ..productId = product.id
            ..productName = product.name
            ..productSku = product.sku
            ..type = 'return'
            ..quantityChange = item.quantity
            ..quantityAfter = product.stock
            ..note = 'LAN return $returnNo'
            ..createdAt = now,
        );
        returnPayload.add({
          'productId': item.line.productId,
          'quantity': item.quantity,
          'productName': item.line.productName,
        });
      }

      sale.returnedAmount = (sale.returnedAmount + refund)
          .clamp(0, sale.total)
          .toDouble();
      if (isVoid || sale.returnedAmount >= sale.total - 0.01) {
        sale.status = 'voided';
      } else {
        sale.status = 'partial_return';
      }
      await _isar.sales.put(sale);

      await _isar.saleReturns.put(
        SaleReturn()
          ..returnNo = returnNo
          ..saleId = sale.id
          ..invoiceNo = sale.invoiceNo
          ..customerId = sale.customerId
          ..customerName = sale.customerName
          ..reason = reason
          ..refundAmount = refund
          ..refundMethod = sale.paymentMethod
          ..linesJson = jsonEncode(returnPayload)
          ..approvedById = approvedById
          ..approvedByName = approvedByName
          ..isVoid = isVoid
          ..returnedAt = now,
      );

      if (sale.paymentMethod.toLowerCase().contains('khata') &&
          sale.customerId != null) {
        final customer = await _isar.customers.get(sale.customerId!);
        if (customer != null) {
          customer.balance -= refund;
          await _isar.customers.put(customer);
          await _isar.customerLedgerEntrys.put(
            CustomerLedgerEntry()
              ..customerId = customer.id
              ..customerName = customer.name
              ..type = 'credit'
              ..amount = refund
              ..balanceAfter = customer.balance
              ..reference = returnNo
              ..note = 'Sale return (LAN)'
              ..entryDate = now
              ..createdAt = now,
          );
        }
      }

      await RetailActorStore.audit(
        isar: _isar,
        action: isVoid ? 'sale.voided' : 'sale.returned',
        entityType: 'sale',
        entityId: sale.id,
        actor: RetailActor(
          id: approvedById,
          name: approvedByName,
          role: 'manager',
        ),
        details: '$returnNo · Rs ${refund.toStringAsFixed(2)} · $reason',
        occurredAt: now,
      );
    });

    return {
      'returnNo': returnNo,
      'refundAmount': refund,
      'status': sale.status,
    };
  }

  Future<Map<String, dynamic>> dashboardSummary() async {
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final tomorrowStart = todayStart.add(const Duration(days: 1));
    final yesterdayStart = todayStart.subtract(const Duration(days: 1));
    final monthStart = DateTime(now.year, now.month, 1);
    final nextMonthStart = DateTime(now.year, now.month + 1, 1);
    final lastMonthStart = DateTime(now.year, now.month - 1, 1);

    final sales = await _isar.sales.where().findAll();
    final products =
        await _isar.products.filter().deletedAtIsNull().findAll();
    final held = await _isar.heldSales.filter().deletedAtIsNull().findAll();
    final customers =
        await _isar.customers.filter().isActiveEqualTo(true).findAll();
    final purchases = await _isar.purchases.where().findAll();
    final accounts =
        await _isar.accounts.filter().isActiveEqualTo(true).findAll();
    final expenses = await _isar.financeExpenses.where().findAll();
    final returns = await _isar.saleReturns.where().findAll();
    final settings = await _isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();

    final productCost = {
      for (final p in products) p.id: p.purchasePrice,
    };

    var todaySales = 0.0;
    var todayProfit = 0.0;
    var yesterdaySales = 0.0;
    var yesterdayProfit = 0.0;
    var monthlySales = 0.0;
    var monthlyProfit = 0.0;
    var lastMonthSales = 0.0;
    var lastMonthProfit = 0.0;
    var todayKhata = 0.0;
    var todayReceiptCount = 0;
    var voidedToday = 0.0;
    var cashMix = 0.0;
    var cardMix = 0.0;
    var walletMix = 0.0;
    var khataMix = 0.0;
    var splitMix = 0.0;
    var otherMix = 0.0;
    final hourlyBuckets = List<double>.filled(24, 0);
    final staffTotals = <String, ({double amount, int receipts})>{};
    final dailyTotals = <DateTime, ({double amount, double profit})>{};
    final productTotalsToday = <String, ({String name, int units, double rev})>{};

    for (final s in sales) {
      final soldAt = s.soldAt;
      final day = DateTime(soldAt.year, soldAt.month, soldAt.day);
      final isToday =
          !soldAt.isBefore(todayStart) && soldAt.isBefore(tomorrowStart);
      if (s.status.toLowerCase() == 'voided') {
        if (isToday) voidedToday += s.total;
        continue;
      }
      final lines = _decodeSaleLines(s.linesJson);
      var saleProfit = 0.0;
      for (final line in lines) {
        final qty = line.quantity.round();
        saleProfit += line.lineTotal - (productCost[line.productId] ?? 0) * qty;
      }

      if (isToday) {
        todaySales += s.total;
        todayProfit += saleProfit;
        todayReceiptCount += 1;
        hourlyBuckets[soldAt.hour.clamp(0, 23)] += s.total;
        final method = s.paymentMethod.toLowerCase();
        if (method.contains('khata') || method.contains('udhar')) {
          todayKhata += s.total;
          khataMix += s.total;
        } else if (method.contains('split')) {
          splitMix += s.total;
        } else if (method.contains('card') ||
            method.contains('visa') ||
            method.contains('master')) {
          cardMix += s.total;
        } else if (method.contains('wallet') ||
            method.contains('jazz') ||
            method.contains('easy')) {
          walletMix += s.total;
        } else if (method.contains('cash')) {
          cashMix += s.total;
        } else {
          otherMix += s.total;
        }
        final cashier = (s.cashierName ?? '').trim().isEmpty
            ? 'Unknown'
            : s.cashierName!.trim();
        final prev = staffTotals[cashier] ?? (amount: 0.0, receipts: 0);
        staffTotals[cashier] = (
          amount: prev.amount + s.total,
          receipts: prev.receipts + 1,
        );
        for (final line in lines) {
          final key = line.productSku;
          final prevP = productTotalsToday[key] ??
              (name: line.productName, units: 0, rev: 0.0);
          productTotalsToday[key] = (
            name: prevP.name,
            units: prevP.units + line.quantity.round(),
            rev: prevP.rev + line.lineTotal,
          );
        }
      } else if (!soldAt.isBefore(yesterdayStart) &&
          soldAt.isBefore(todayStart)) {
        yesterdaySales += s.total;
        yesterdayProfit += saleProfit;
      }
      if (!soldAt.isBefore(monthStart) && soldAt.isBefore(nextMonthStart)) {
        monthlySales += s.total;
        monthlyProfit += saleProfit;
      } else if (!soldAt.isBefore(lastMonthStart) &&
          soldAt.isBefore(monthStart)) {
        lastMonthSales += s.total;
        lastMonthProfit += saleProfit;
      }
      final prevDay = dailyTotals[day] ?? (amount: 0.0, profit: 0.0);
      dailyTotals[day] = (
        amount: prevDay.amount + s.total,
        profit: prevDay.profit + saleProfit,
      );
    }

    var returnsToday = 0.0;
    for (final r in returns) {
      if (r.isVoid) continue;
      if (!r.returnedAt.isBefore(todayStart) &&
          r.returnedAt.isBefore(tomorrowStart)) {
        returnsToday += r.refundAmount;
      }
    }

    var todayExpenses = 0.0;
    var monthlyExpenses = 0.0;
    for (final e in expenses) {
      if (e.deletedAt != null) continue;
      if (!e.entryDate.isBefore(todayStart) &&
          e.entryDate.isBefore(tomorrowStart)) {
        todayExpenses += e.amount;
      }
      if (!e.entryDate.isBefore(monthStart) &&
          e.entryDate.isBefore(nextMonthStart)) {
        monthlyExpenses += e.amount;
      }
    }

    double pct(double cur, double prev) {
      if (prev == 0) return cur > 0 ? 100 : 0;
      return ((cur - prev) / prev) * 100;
    }

    final seriesStart = todayStart.subtract(const Duration(days: 13));
    final salesSeries = List.generate(14, (i) {
      final day = seriesStart.add(Duration(days: i));
      final t = dailyTotals[day];
      return {
        'date': day.toIso8601String(),
        'amount': t?.amount ?? 0,
        'profit': t?.profit ?? 0,
      };
    });

    final topList = productTotalsToday.entries.toList()
      ..sort((a, b) => b.value.rev.compareTo(a.value.rev));
    final topProducts = [
      for (final e in topList.take(5))
        {
          'name': e.value.name,
          'sku': e.key,
          'unitsSold': e.value.units,
          'revenue': e.value.rev,
        },
    ];

    final recent = sales
        .where((s) => s.status.toLowerCase() != 'voided')
        .toList()
      ..sort((a, b) => b.soldAt.compareTo(a.soldAt));
    final recentSales = [
      for (final s in recent.take(8))
        {
          'invoiceNo': s.invoiceNo,
          'customerName': s.customerName,
          'amount': s.total,
          'paymentMethod': s.paymentMethod,
          'soldAt': s.soldAt.toIso8601String(),
        },
    ];

    final lowStockItems = products
        .where((p) {
          if (!p.isActive) return false;
          final threshold = p.lowStockThreshold > 0 ? p.lowStockThreshold : 10;
          return p.stock <= threshold;
        })
        .toList()
      ..sort((a, b) => a.stock.compareTo(b.stock));

    final staffList = staffTotals.entries.toList()
      ..sort((a, b) => b.value.amount.compareTo(a.value.amount));

    final receivables = customers.fold<double>(
      0,
      (sum, c) => sum + (c.balance > 0 ? c.balance : 0),
    );
    final payablesDue = purchases.fold<double>(
      0,
      (sum, p) => sum + (p.dueAmount > 0 ? p.dueAmount : 0),
    );
    final cashOnHand = accounts.fold<double>(0, (sum, a) => sum + a.balance);

    return {
      'todaySales': todaySales,
      'todayProfit': todayProfit,
      'monthlySales': monthlySales,
      'monthlyProfit': monthlyProfit,
      'todaySalesChange': pct(todaySales, yesterdaySales),
      'todayProfitChange': pct(todayProfit, yesterdayProfit),
      'monthlySalesChange': pct(monthlySales, lastMonthSales),
      'monthlyProfitChange': pct(monthlyProfit, lastMonthProfit),
      'todayKhataSales': todayKhata,
      'todayExpenses': todayExpenses,
      'monthlyExpenses': monthlyExpenses,
      'receivables': receivables,
      'payablesDue': payablesDue,
      'cashOnHand': cashOnHand,
      'heldSalesCount': held.length,
      'lowStockCount': lowStockItems.length,
      'todayReceiptCount': todayReceiptCount,
      'avgTicket':
          todayReceiptCount == 0 ? 0 : todaySales / todayReceiptCount,
      'voidedToday': voidedToday,
      'returnsToday': returnsToday,
      'paymentMix': {
        'cash': cashMix,
        'card': cardMix,
        'wallet': walletMix,
        'khata': khataMix,
        'split': splitMix,
        'other': otherMix,
      },
      'hourlySalesToday': [
        for (var h = 0; h < 24; h++)
          {'hour': h, 'amount': hourlyBuckets[h]},
      ],
      'staffSalesToday': [
        for (final e in staffList.take(8))
          {
            'name': e.key,
            'amount': e.value.amount,
            'receipts': e.value.receipts,
          },
      ],
      'salesSeries': salesSeries,
      'topProducts': topProducts,
      'recentSales': recentSales,
      'lowStockItems': [
        for (final p in lowStockItems.take(8))
          {
            'name': p.name,
            'sku': p.sku,
            'quantity': p.stock,
            'reorderLevel':
                p.lowStockThreshold > 0 ? p.lowStockThreshold : 10,
          },
      ],
      'lastBackupAt': settings?.lastBackupAt?.toIso8601String(),
      'isRestaurant':
          (settings?.storeProfile ?? '').toLowerCase() == 'restaurant',
      'serverTime': now.toIso8601String(),
    };
  }

  int _heldItemCount(String itemsJson) {
    try {
      final decoded = jsonDecode(itemsJson);
      if (decoded is List) return decoded.length;
    } catch (_) {}
    return 0;
  }

  List<SaleLineItem> _decodeSaleLines(String linesJson) {
    try {
      final decoded = jsonDecode(linesJson);
      if (decoded is! List) return const [];
      return [
        for (final raw in decoded)
          if (raw is Map)
            SaleLineItem.fromJson(Map<String, dynamic>.from(raw)),
      ];
    } catch (_) {
      return const [];
    }
  }
}
