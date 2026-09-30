import 'dart:convert';

import 'package:isar_community/isar.dart';

import '../../../../database/collections/customer.dart';
import '../../../../database/collections/ledger_entry.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/product_batch.dart';
import '../../../../database/collections/purchase.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/collections/stock_movement.dart';
import '../../../../database/isar_service.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';
import '../../domain/entities/report_detail_payload.dart';
import '../../domain/entities/report_entities.dart';
import '../../domain/services/report_cogs_calculator.dart';
import '../../domain/services/report_period_utils.dart';

class ReportsQueryEngine {
  ReportsQueryEngine(this._isarService);

  final IsarService _isarService;

  Future<ReportsData> getLegacyReports({required ReportsPeriod period}) async {
    final payload = await getReportDetail(
      ReportId.sales,
      ReportFilters(period: period.toPreset()),
    );
    return payload.legacyData;
  }

  Future<ReportFilterOptions> getFilterOptions() async {
    final isar = _isarService.instance;
    final products = await isar.products.where().findAll();
    final sales = await isar.sales.where().findAll();
    final purchases = await isar.purchases.where().findAll();
    final customers = await isar.customers.where().findAll();

    final categories =
        products
            .where((p) => p.deletedAt == null)
            .map((p) => p.category)
            .toSet()
            .toList()
          ..sort();

    final paymentMethods = sales.map((s) => s.paymentMethod).toSet().toList()
      ..sort();

    final supplierMap = <int, String>{};
    for (final p in purchases) {
      supplierMap[p.supplierId] = p.supplierName;
    }

    return ReportFilterOptions(
      categories: categories,
      paymentMethods: paymentMethods,
      suppliers: supplierMap.entries.map((e) => (e.key, e.value)).toList(),
      customers: customers.map((c) => (c.id, c.name)).toList(),
      products: products
          .where((p) => p.deletedAt == null)
          .map((p) => (p.id, p.name))
          .toList(),
    );
  }

  Future<ReportDetailPayload> getReportDetail(
    ReportId reportId,
    ReportFilters filters,
  ) async {
    final isar = _isarService.instance;
    final range = ReportPeriodUtils.resolve(filters);

    final sales = await isar.sales.where().findAll();
    final purchases = await isar.purchases.where().findAll();
    final products = await isar.products.where().findAll();
    final batches = await isar.productBatchs.where().findAll();
    final expenses = await isar.ledgerEntrys
        .filter()
        .typeEqualTo('expense')
        .findAll();
    final movements = await isar.stockMovements.where().findAll();
    final customers = await isar.customers.where().findAll();

    final activeProducts = products
        .where((p) => p.deletedAt == null && p.isActive)
        .toList();

    final productById = {for (final p in products) p.id: p};
    final productCosts = {for (final p in products) p.id: p.purchasePrice};
    final batchCosts = {for (final b in batches) b.id: b.unitCost};
    var usedBatchCost = false;

    bool matchesSale(Sale sale) {
      if (!ReportPeriodUtils.inRange(sale.soldAt, range)) return false;
      if (filters.paymentMethod != null &&
          sale.paymentMethod != filters.paymentMethod) {
        return false;
      }
      if (filters.customerId != null && sale.customerId != filters.customerId) {
        return false;
      }
      if (filters.productId != null || filters.category != null) {
        final lines = _decodeLines(sale.linesJson);
        final productMatch = lines.any((line) {
          final pid = line['productId'] as int;
          if (filters.productId != null && pid != filters.productId) {
            return false;
          }
          if (filters.category != null) {
            final product = productById[pid];
            if (product == null || product.category != filters.category) {
              return false;
            }
          }
          return true;
        });
        if (!productMatch) return false;
      }
      return true;
    }

    bool matchesPurchase(Purchase purchase) {
      if (!ReportPeriodUtils.inRange(purchase.purchaseDate, range)) {
        return false;
      }
      if (filters.supplierId != null &&
          purchase.supplierId != filters.supplierId) {
        return false;
      }
      return true;
    }

    final filteredSales = sales.where(matchesSale).toList();
    final filteredPurchases = purchases.where(matchesPurchase).toList();
    final filteredExpenses = expenses
        .where((e) => ReportPeriodUtils.inRange(e.entryDate, range))
        .toList();
    final filteredMovements = movements
        .where((m) => ReportPeriodUtils.inRange(m.createdAt, range))
        .toList();

    double lineCost(Map<String, dynamic> line) {
      final raw = line['batchAllocations'];
      if (raw is List && raw.isNotEmpty) usedBatchCost = true;
      return ReportCogsCalculator.lineCost(
        line: line,
        batchCosts: batchCosts,
        productCosts: productCosts,
      );
    }

    // --- Aggregations ---
    var grossSales = 0.0;
    var totalDiscounts = 0.0;
    var totalTax = 0.0;
    var totalCogs = 0.0;
    var estimatedProfit = 0.0;
    final productAgg = <String, _ProductAgg>{};
    final categorySalesAgg = <String, _CategorySalesAgg>{};
    final categoryProfitAgg = <String, _CategoryProfitAgg>{};
    final paymentAgg = <String, _PaymentAgg>{};
    final customerAgg = <String, _CustomerAgg>{};
    final dailyBuckets = <DateTime, _DailyAgg>{};
    final productTaxAgg = <String, _TaxAgg>{};
    final discountRows = <ReportDiscountRow>[];
    final lastSaleByProduct = <int, DateTime>{};

    ReportPeriodUtils.seedTrendBuckets(
      dailyBuckets,
      filters.period,
      create: (d) => _DailyAgg(date: d),
    );

    for (final sale in filteredSales) {
      final saleRatio = sale.total <= 0
          ? 0.0
          : ((sale.total - sale.returnedAmount) / sale.total)
                .clamp(0.0, 1.0)
                .toDouble();
      final netSaleTotal = sale.total * saleRatio;
      grossSales += sale.subtotal * saleRatio;
      totalDiscounts += sale.discount * saleRatio;
      totalTax += sale.tax * saleRatio;

      paymentAgg.update(
        sale.paymentMethod,
        (v) => v.copyWith(total: v.total + netSaleTotal, count: v.count + 1),
        ifAbsent: () => _PaymentAgg(
          method: sale.paymentMethod,
          total: netSaleTotal,
          count: 1,
        ),
      );

      customerAgg.update(
        sale.customerName,
        (v) => v.copyWith(
          total: v.total + netSaleTotal,
          receiptCount: v.receiptCount + 1,
        ),
        ifAbsent: () => _CustomerAgg(
          name: sale.customerName,
          total: netSaleTotal,
          receiptCount: 1,
          units: 0,
        ),
      );

      if (sale.discount > 0) {
        discountRows.add(
          ReportDiscountRow(
            label: sale.invoiceNo,
            discountAmount: sale.discount,
            saleTotal: netSaleTotal,
            date: sale.soldAt,
          ),
        );
      }

      final day = ReportPeriodUtils.trendBucket(sale.soldAt, filters.period);
      dailyBuckets.putIfAbsent(day, () => _DailyAgg(date: day));

      final lines = _decodeLines(sale.linesJson);
      var saleUnits = 0;
      for (final line in lines) {
        final productId = line['productId'] as int;
        final qty = ((line['quantity'] as int) * saleRatio).round();
        final lineTotal = (line['lineTotal'] as num).toDouble() * saleRatio;
        final cost = lineCost(line) * saleRatio;
        final lineProfit = lineTotal - cost;
        totalCogs += cost;
        estimatedProfit += lineProfit;
        saleUnits += qty;

        lastSaleByProduct[productId] =
            sale.soldAt.isAfter(lastSaleByProduct[productId] ?? DateTime(1970))
            ? sale.soldAt
            : lastSaleByProduct[productId]!;

        final sku = line['productSku'] as String;
        final name = line['productName'] as String;
        final product = productById[productId];
        final category = product?.category ?? 'Uncategorized';

        productAgg.update(
          sku,
          (v) => v.copyWith(
            unitsSold: v.unitsSold + qty,
            revenue: v.revenue + lineTotal,
            estimatedProfit: v.estimatedProfit + lineProfit,
            name: name,
          ),
          ifAbsent: () => _ProductAgg(
            name: name,
            sku: sku,
            unitsSold: qty,
            revenue: lineTotal,
            estimatedProfit: lineProfit,
          ),
        );

        categorySalesAgg.update(
          category,
          (v) =>
              v.copyWith(revenue: v.revenue + lineTotal, units: v.units + qty),
          ifAbsent: () => _CategorySalesAgg(
            category: category,
            revenue: lineTotal,
            units: qty,
          ),
        );

        categoryProfitAgg.update(
          category,
          (v) => v.copyWith(
            revenue: v.revenue + lineTotal,
            profit: v.profit + lineProfit,
          ),
          ifAbsent: () => _CategoryProfitAgg(
            category: category,
            revenue: lineTotal,
            profit: lineProfit,
          ),
        );

        final lineDisc =
            ((line['lineDiscount'] as num?)?.toDouble() ?? 0) * saleRatio;
        if (lineDisc > 0) {
          discountRows.add(
            ReportDiscountRow(
              label: name,
              discountAmount: lineDisc,
              saleTotal: lineTotal,
              date: sale.soldAt,
            ),
          );
        }

        if (product != null && product.taxRate > 0) {
          final taxShare = sale.tax > 0 && sale.subtotal > 0
              ? lineTotal / sale.subtotal * sale.tax
              : 0.0;
          productTaxAgg.update(
            name,
            (v) =>
                v.copyWith(tax: v.tax + taxShare, sales: v.sales + lineTotal),
            ifAbsent: () =>
                _TaxAgg(label: name, tax: taxShare, sales: lineTotal),
          );
        }

        final daily = dailyBuckets[day]!;
        dailyBuckets[day] = daily.copyWith(
          sales: daily.sales + lineTotal,
          profit: daily.profit + lineProfit,
        );
      }

      customerAgg.update(
        sale.customerName,
        (v) => v.copyWith(units: v.units + saleUnits),
        ifAbsent: () => _CustomerAgg(
          name: sale.customerName,
          total: netSaleTotal,
          receiptCount: 1,
          units: saleUnits,
        ),
      );
    }

    for (final purchase in filteredPurchases) {
      final day = ReportPeriodUtils.trendBucket(
        purchase.purchaseDate,
        filters.period,
      );
      dailyBuckets.putIfAbsent(day, () => _DailyAgg(date: day));
      final daily = dailyBuckets[day]!;
      dailyBuckets[day] = daily.copyWith(
        purchases: daily.purchases + purchase.total,
      );
    }

    final expenseCategoryAgg = <String, _ExpenseCategoryAgg>{};
    final expenseHistory = <ReportExpenseHistoryRow>[];
    for (final entry in filteredExpenses) {
      final day = ReportPeriodUtils.trendBucket(
        entry.entryDate,
        filters.period,
      );
      dailyBuckets.putIfAbsent(day, () => _DailyAgg(date: day));
      final daily = dailyBuckets[day]!;
      dailyBuckets[day] = daily.copyWith(
        expenses: daily.expenses + entry.amount,
      );

      expenseCategoryAgg.update(
        entry.category,
        (v) => v.copyWith(total: v.total + entry.amount, count: v.count + 1),
        ifAbsent: () => _ExpenseCategoryAgg(
          category: entry.category,
          total: entry.amount,
          count: 1,
        ),
      );

      expenseHistory.add(
        ReportExpenseHistoryRow(
          date: entry.entryDate,
          category: entry.category,
          amount: entry.amount,
          note: entry.note ?? entry.reference ?? '',
        ),
      );
    }
    expenseHistory.sort((a, b) => b.date.compareTo(a.date));

    final totalSales = filteredSales.fold(
      0.0,
      (s, sale) => s + (sale.total - sale.returnedAmount),
    );
    final totalPurchases = filteredPurchases.fold(0.0, (s, p) => s + p.total);
    final totalPurchaseDue = purchases.fold(0.0, (s, p) => s + p.dueAmount);
    final totalExpenses = filteredExpenses.fold(0.0, (s, e) => s + e.amount);
    final paidPurchases = filteredPurchases.fold(
      0.0,
      (s, p) => s + p.paidAmount,
    );

    final stockValue = activeProducts.fold(
      0.0,
      (sum, product) => sum + product.stock * product.purchasePrice,
    );

    final lowStock =
        activeProducts
            .where(
              (product) => isStockAtOrBelowLowThreshold(
                product.stock,
                product.lowStockThreshold,
              ),
            )
            .map(
              (product) => ReportLowStockRow(
                name: product.name,
                sku: product.sku,
                stock: product.stock,
                value: product.stock * product.purchasePrice,
              ),
            )
            .toList()
          ..sort((a, b) => a.stock.compareTo(b.stock));

    final outOfStock = activeProducts
        .where((product) => product.stock <= 0)
        .map(
          (product) => ReportLowStockRow(
            name: product.name,
            sku: product.sku,
            stock: product.stock,
            value: 0,
          ),
        )
        .toList();

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    int countExpiringWithin(int days) {
      var count = 0;
      for (final batch in batches) {
        if (batch.quantity <= 0 || batch.expiryDate == null) continue;
        final product = productById[batch.productId];
        if (product == null || product.deletedAt != null) continue;
        final expiry = DateTime(
          batch.expiryDate!.year,
          batch.expiryDate!.month,
          batch.expiryDate!.day,
        );
        final remaining = expiry.difference(today).inDays;
        if (remaining >= 0 && remaining <= days) count++;
      }
      for (final product in activeProducts) {
        if (product.expiryDate == null || product.stock <= 0) continue;
        final expiry = DateTime(
          product.expiryDate!.year,
          product.expiryDate!.month,
          product.expiryDate!.day,
        );
        final remaining = expiry.difference(today).inDays;
        if (remaining >= 0 && remaining <= days) count++;
      }
      return count;
    }

    int countExpired() {
      var count = 0;
      for (final batch in batches) {
        if (batch.quantity <= 0 || batch.expiryDate == null) continue;
        final product = productById[batch.productId];
        if (product == null || product.deletedAt != null) continue;
        final expiry = DateTime(
          batch.expiryDate!.year,
          batch.expiryDate!.month,
          batch.expiryDate!.day,
        );
        if (expiry.isBefore(today)) count++;
      }
      for (final product in activeProducts) {
        if (product.expiryDate == null || product.stock <= 0) continue;
        final expiry = DateTime(
          product.expiryDate!.year,
          product.expiryDate!.month,
          product.expiryDate!.day,
        );
        if (expiry.isBefore(today)) count++;
      }
      return count;
    }

    final expiryRows = _buildExpiryRows(
      batches: batches,
      products: activeProducts,
      productById: productById,
      purchases: purchases,
      filters: filters,
      today: today,
    );

    final totalUnits = activeProducts.fold(
      0,
      (sum, product) => sum + product.stock,
    );

    final categoryAgg = <String, _CategoryAgg>{};
    for (final product in activeProducts) {
      final value = product.stock * product.purchasePrice;
      categoryAgg.update(
        product.category,
        (current) => current.copyWith(
          stockValue: current.stockValue + value,
          productCount: current.productCount + 1,
        ),
        ifAbsent: () => _CategoryAgg(
          category: product.category,
          stockValue: value,
          productCount: 1,
        ),
      );
    }

    final trend =
        dailyBuckets.values
            .map(
              (item) => ReportTrendPoint(
                date: item.date,
                sales: item.sales,
                profit: item.profit,
                purchases: item.purchases,
                expenses: item.expenses,
              ),
            )
            .toList()
          ..sort((a, b) => a.date.compareTo(b.date));

    final topProducts =
        productAgg.values
            .map(
              (item) => ReportProductRow(
                name: item.name,
                sku: item.sku,
                unitsSold: item.unitsSold,
                revenue: item.revenue,
                estimatedProfit: item.estimatedProfit,
              ),
            )
            .toList()
          ..sort((a, b) => b.revenue.compareTo(a.revenue));

    final payments =
        paymentAgg.values
            .map(
              (item) => ReportPaymentRow(
                method: item.method,
                total: item.total,
                count: item.count,
              ),
            )
            .toList()
          ..sort((a, b) => b.total.compareTo(a.total));

    final categories =
        categoryAgg.values
            .map(
              (item) => ReportCategoryRow(
                category: item.category,
                stockValue: item.stockValue,
                productCount: item.productCount,
              ),
            )
            .toList()
          ..sort((a, b) => b.stockValue.compareTo(a.stockValue));

    final expenseCategories =
        expenseCategoryAgg.values
            .map(
              (item) => ReportExpenseCategoryRow(
                category: item.category,
                total: item.total,
                count: item.count,
              ),
            )
            .toList()
          ..sort((a, b) => b.total.compareTo(a.total));

    final salesByCategory =
        categorySalesAgg.values
            .map(
              (item) => ReportCategorySalesRow(
                category: item.category,
                revenue: item.revenue,
                units: item.units,
              ),
            )
            .toList()
          ..sort((a, b) => b.revenue.compareTo(a.revenue));

    final profitByCategory =
        categoryProfitAgg.values
            .map(
              (item) => ReportCategoryProfitRow(
                category: item.category,
                revenue: item.revenue,
                profit: item.profit,
              ),
            )
            .toList()
          ..sort((a, b) => b.profit.compareTo(a.profit));

    final customerRows =
        customerAgg.values
            .map(
              (item) => ReportCustomerRow(
                customerName: item.name,
                receiptCount: item.receiptCount,
                total: item.total,
                units: item.units,
              ),
            )
            .toList()
          ..sort((a, b) => b.total.compareTo(a.total));

    final supplierAgg = <String, _SupplierAgg>{};
    for (final purchase in purchases) {
      supplierAgg.update(
        purchase.supplierName,
        (v) => v.copyWith(
          purchaseTotal: v.purchaseTotal + purchase.total,
          purchaseCount: v.purchaseCount + 1,
          outstanding: v.outstanding + purchase.dueAmount,
        ),
        ifAbsent: () => _SupplierAgg(
          supplierName: purchase.supplierName,
          purchaseTotal: purchase.total,
          purchaseCount: 1,
          outstanding: purchase.dueAmount,
        ),
      );
    }

    final supplierRows =
        supplierAgg.values
            .map(
              (item) => ReportSupplierRow(
                supplierName: item.supplierName,
                purchaseTotal: item.purchaseTotal,
                purchaseCount: item.purchaseCount,
                outstanding: item.outstanding,
              ),
            )
            .toList()
          ..sort((a, b) => b.purchaseTotal.compareTo(a.purchaseTotal));

    final purchaseHistory =
        filteredPurchases
            .map(
              (p) => ReportPurchaseHistoryRow(
                invoiceNo: p.invoiceNo,
                supplierName: p.supplierName,
                date: p.purchaseDate,
                total: p.total,
                paid: p.paidAmount,
                due: p.dueAmount,
                status: p.status,
              ),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    final stockMovementRows =
        filteredMovements
            .map(
              (m) => ReportStockMovementRow(
                date: m.createdAt,
                productName: m.productName,
                sku: m.productSku,
                type: m.type,
                quantityChange: m.quantityChange,
                quantityAfter: m.quantityAfter,
                note: m.note,
              ),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    final adjustmentRows =
        filteredMovements
            .where((m) => m.type == 'adjustment')
            .map(
              (m) => ReportStockMovementRow(
                date: m.createdAt,
                productName: m.productName,
                sku: m.productSku,
                type: m.type,
                quantityChange: m.quantityChange,
                quantityAfter: m.quantityAfter,
                note: m.note,
              ),
            )
            .toList()
          ..sort((a, b) => b.date.compareTo(a.date));

    final velocityRows = activeProducts.map((product) {
      final agg = productAgg.values
          .where((a) => a.sku == product.sku)
          .cast<_ProductAgg?>()
          .firstOrNull;
      final lastSale = lastSaleByProduct[product.id];
      final daysSince = lastSale == null
          ? null
          : today
                .difference(
                  DateTime(lastSale.year, lastSale.month, lastSale.day),
                )
                .inDays;
      return ReportVelocityRow(
        name: product.name,
        sku: product.sku,
        unitsSold: agg?.unitsSold ?? 0,
        revenue: agg?.revenue ?? 0,
        stock: product.stock,
        daysSinceLastSale: daysSince,
      );
    }).toList();

    final taxRows =
        productTaxAgg.values
            .map(
              (item) => ReportTaxRow(
                label: item.label,
                taxAmount: item.tax,
                salesTotal: item.sales,
              ),
            )
            .toList()
          ..sort((a, b) => b.taxAmount.compareTo(a.taxAmount));

    final taxTrend = trend.map((point) {
      // Approximate tax from sales proportion
      final ratio = grossSales > 0 ? totalTax / grossSales : 0;
      return ReportTrendPoint(
        date: point.date,
        sales: point.sales * ratio,
        profit: 0,
      );
    }).toList();

    final customerBalances =
        customers
            .where((c) => c.isActive && c.balance != 0)
            .map(
              (c) => ReportCustomerBalanceRow(
                customerName: c.name,
                balance: c.balance,
                creditLimit: c.creditLimit,
                phone: c.phone,
              ),
            )
            .toList()
          ..sort((a, b) => b.balance.compareTo(a.balance));

    final netSales = totalSales;
    final avgTxn = filteredSales.isEmpty
        ? 0.0
        : totalSales / filteredSales.length;

    final grossProfit = estimatedProfit;
    final netProfit = grossProfit - totalExpenses;
    final grossMargin = totalSales > 0 ? (grossProfit / totalSales) * 100 : 0.0;
    final netMargin = totalSales > 0 ? (netProfit / totalSales) * 100 : 0.0;

    final summary = ReportSummary(
      totalSales: totalSales,
      totalReceipts: filteredSales.length,
      estimatedProfit: estimatedProfit,
      totalPurchases: totalPurchases,
      totalPurchaseDue: totalPurchaseDue,
      totalExpenses: totalExpenses,
      stockValue: stockValue,
      lowStockCount: lowStock.length,
    );

    final payload = ReportDetailPayload(
      summary: summary,
      trend: trend,
      topProducts: topProducts.take(20).toList(),
      payments: payments,
      lowStock: lowStock,
      categories: categories,
      expenseCategories: expenseCategories,
      salesMetrics: SalesReportMetrics(
        grossSales: grossSales,
        discounts: totalDiscounts,
        returns: 0,
        netSales: netSales,
        receiptCount: filteredSales.length,
        averageTransaction: avgTxn,
        taxCollected: totalTax,
      ),
      profitMetrics: ProfitReportMetrics(
        grossSales: grossSales,
        discounts: totalDiscounts,
        returns: 0,
        cogs: totalCogs,
        grossProfit: grossProfit,
        expenses: totalExpenses,
        netProfit: netProfit,
        grossMarginPct: grossMargin,
        netMarginPct: netMargin,
      ),
      expenseMetrics: ExpenseReportMetrics(
        totalExpenses: totalExpenses,
        expenseCount: filteredExpenses.length,
      ),
      inventoryMetrics: InventoryReportMetrics(
        activeProducts: activeProducts.length,
        totalUnits: totalUnits,
        stockValueAtCost: stockValue,
        lowStockCount: lowStock.length,
        outOfStockCount: outOfStock.length,
        expiringSoonCount: countExpiringWithin(30),
        expiredCount: countExpired(),
      ),
      purchaseMetrics: PurchaseReportMetrics(
        totalPurchases: totalPurchases,
        paidAmount: paidPurchases,
        outstandingAmount: totalPurchaseDue,
        purchaseCount: filteredPurchases.length,
      ),
      salesByCategory: salesByCategory,
      profitByCategory: profitByCategory,
      expenseHistory: expenseHistory,
      stockMovementRows: stockMovementRows,
      outOfStock: outOfStock,
      expiryRows: expiryRows,
      velocityRows: velocityRows,
      supplierRows: supplierRows,
      customerRows: customerRows,
      discountRows: discountRows,
      taxRows: taxRows,
      taxTrend: taxTrend,
      purchaseHistory: purchaseHistory,
      customerLedgerRows: customerBalances,
      adjustmentRows: adjustmentRows,
      usedBatchCost: usedBatchCost,
    );

    return _trimForReport(reportId, payload);
  }

  ReportDetailPayload _trimForReport(
    ReportId reportId,
    ReportDetailPayload full,
  ) {
    // All reports share the same query; trimming limits list sizes per view.
    return switch (reportId) {
      ReportId.fastMoving => full.copyWith(
        velocityRows: [...full.velocityRows]
          ..sort((a, b) => b.unitsSold.compareTo(a.unitsSold)),
      ),
      ReportId.slowMoving => full.copyWith(
        velocityRows: [...full.velocityRows]
          ..sort((a, b) => a.unitsSold.compareTo(b.unitsSold)),
      ),
      ReportId.deadStock => full.copyWith(
        velocityRows: full.velocityRows
            .where((r) => r.stock > 0 && r.unitsSold == 0)
            .toList(),
      ),
      ReportId.topCustomers => full.copyWith(
        customerRows: full.customerRows.take(20).toList(),
      ),
      _ => full,
    };
  }

  List<ReportExpiryRow> _buildExpiryRows({
    required List<ProductBatch> batches,
    required List<Product> products,
    required Map<int, Product> productById,
    required List<Purchase> purchases,
    required ReportFilters filters,
    required DateTime today,
  }) {
    final supplierByProduct = <int, String>{};
    for (final purchase in purchases) {
      try {
        final lines = jsonDecode(purchase.linesJson) as List<dynamic>;
        for (final raw in lines) {
          if (raw is! Map) continue;
          final productId = raw['productId'] as int?;
          if (productId != null) {
            supplierByProduct.putIfAbsent(
              productId,
              () => purchase.supplierName,
            );
          }
        }
      } catch (_) {}
    }

    int? withinDays = filters.expiryWithinDays;
    if (withinDays == null && filters.period == ReportPeriodPreset.custom) {
      withinDays = 90;
    }

    bool includeExpiry(DateTime? expiry) {
      if (expiry == null) return false;
      final day = DateTime(expiry.year, expiry.month, expiry.day);
      final remaining = day.difference(today).inDays;
      if (withinDays == null) return true;
      if (withinDays < 0) return remaining < 0;
      return remaining >= 0 && remaining <= withinDays;
    }

    final rows = <ReportExpiryRow>[];

    for (final batch in batches) {
      if (batch.quantity <= 0) continue;
      if (!includeExpiry(batch.expiryDate)) continue;
      final product = productById[batch.productId];
      if (product == null || product.deletedAt != null) continue;
      if (filters.productId != null && product.id != filters.productId) {
        continue;
      }
      if (filters.category != null && product.category != filters.category) {
        continue;
      }
      final expiry = batch.expiryDate;
      final day = expiry == null
          ? null
          : DateTime(expiry.year, expiry.month, expiry.day);
      final remaining = day?.difference(today).inDays ?? 0;
      rows.add(
        ReportExpiryRow(
          productName: product.name,
          sku: product.sku,
          batchCode: batch.batchCode ?? '—',
          quantity: batch.quantity,
          unit: product.unit ?? 'Unit',
          expiryDate: expiry,
          daysRemaining: remaining,
          unitCost: batch.unitCost > 0 ? batch.unitCost : product.purchasePrice,
          stockValue:
              batch.quantity *
              (batch.unitCost > 0 ? batch.unitCost : product.purchasePrice),
          supplierName: supplierByProduct[product.id] ?? '—',
        ),
      );
    }

    for (final product in products) {
      if (product.stock <= 0 || product.expiryDate == null) continue;
      if (!includeExpiry(product.expiryDate)) continue;
      if (filters.productId != null && product.id != filters.productId) {
        continue;
      }
      if (filters.category != null && product.category != filters.category) {
        continue;
      }
      final expiry = product.expiryDate!;
      final day = DateTime(expiry.year, expiry.month, expiry.day);
      final remaining = day.difference(today).inDays;
      rows.add(
        ReportExpiryRow(
          productName: product.name,
          sku: product.sku,
          batchCode: '—',
          quantity: product.stock,
          unit: product.unit ?? 'Unit',
          expiryDate: expiry,
          daysRemaining: remaining,
          unitCost: product.purchasePrice,
          stockValue: product.stock * product.purchasePrice,
          supplierName: supplierByProduct[product.id] ?? '—',
        ),
      );
    }

    rows.sort((a, b) => a.daysRemaining.compareTo(b.daysRemaining));
    return rows;
  }

  List<Map<String, dynamic>> _decodeLines(String json) {
    final decoded = jsonDecode(json) as List<dynamic>;
    return decoded.cast<Map<String, dynamic>>();
  }
}

extension on ReportDetailPayload {
  ReportDetailPayload copyWith({
    List<ReportVelocityRow>? velocityRows,
    List<ReportCustomerRow>? customerRows,
  }) {
    return ReportDetailPayload(
      summary: summary,
      trend: trend,
      topProducts: topProducts,
      payments: payments,
      lowStock: lowStock,
      categories: categories,
      expenseCategories: expenseCategories,
      salesMetrics: salesMetrics,
      profitMetrics: profitMetrics,
      expenseMetrics: expenseMetrics,
      inventoryMetrics: inventoryMetrics,
      purchaseMetrics: purchaseMetrics,
      salesByCategory: salesByCategory,
      salesByCashier: salesByCashier,
      profitByCategory: profitByCategory,
      expenseHistory: expenseHistory,
      stockMovementRows: stockMovementRows,
      outOfStock: outOfStock,
      expiryRows: expiryRows,
      velocityRows: velocityRows ?? this.velocityRows,
      supplierRows: supplierRows,
      customerRows: customerRows ?? this.customerRows,
      discountRows: discountRows,
      taxRows: taxRows,
      taxTrend: taxTrend,
      purchaseHistory: purchaseHistory,
      customerLedgerRows: customerLedgerRows,
      adjustmentRows: adjustmentRows,
      usedBatchCost: usedBatchCost,
    );
  }
}

class _ProductAgg {
  const _ProductAgg({
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

  _ProductAgg copyWith({
    String? name,
    int? unitsSold,
    double? revenue,
    double? estimatedProfit,
  }) {
    return _ProductAgg(
      name: name ?? this.name,
      sku: sku,
      unitsSold: unitsSold ?? this.unitsSold,
      revenue: revenue ?? this.revenue,
      estimatedProfit: estimatedProfit ?? this.estimatedProfit,
    );
  }
}

class _PaymentAgg {
  const _PaymentAgg({
    required this.method,
    required this.total,
    required this.count,
  });

  final String method;
  final double total;
  final int count;

  _PaymentAgg copyWith({double? total, int? count}) {
    return _PaymentAgg(
      method: method,
      total: total ?? this.total,
      count: count ?? this.count,
    );
  }
}

class _DailyAgg {
  const _DailyAgg({
    required this.date,
    this.sales = 0,
    this.profit = 0,
    this.purchases = 0,
    this.expenses = 0,
  });

  final DateTime date;
  final double sales;
  final double profit;
  final double purchases;
  final double expenses;

  _DailyAgg copyWith({
    double? sales,
    double? profit,
    double? purchases,
    double? expenses,
  }) {
    return _DailyAgg(
      date: date,
      sales: sales ?? this.sales,
      profit: profit ?? this.profit,
      purchases: purchases ?? this.purchases,
      expenses: expenses ?? this.expenses,
    );
  }
}

class _ExpenseCategoryAgg {
  const _ExpenseCategoryAgg({
    required this.category,
    required this.total,
    required this.count,
  });

  final String category;
  final double total;
  final int count;

  _ExpenseCategoryAgg copyWith({double? total, int? count}) {
    return _ExpenseCategoryAgg(
      category: category,
      total: total ?? this.total,
      count: count ?? this.count,
    );
  }
}

class _CategoryAgg {
  const _CategoryAgg({
    required this.category,
    required this.stockValue,
    required this.productCount,
  });

  final String category;
  final double stockValue;
  final int productCount;

  _CategoryAgg copyWith({double? stockValue, int? productCount}) {
    return _CategoryAgg(
      category: category,
      stockValue: stockValue ?? this.stockValue,
      productCount: productCount ?? this.productCount,
    );
  }
}

class _CategorySalesAgg {
  const _CategorySalesAgg({
    required this.category,
    required this.revenue,
    required this.units,
  });

  final String category;
  final double revenue;
  final int units;

  _CategorySalesAgg copyWith({double? revenue, int? units}) {
    return _CategorySalesAgg(
      category: category,
      revenue: revenue ?? this.revenue,
      units: units ?? this.units,
    );
  }
}

class _CategoryProfitAgg {
  const _CategoryProfitAgg({
    required this.category,
    required this.revenue,
    required this.profit,
  });

  final String category;
  final double revenue;
  final double profit;

  _CategoryProfitAgg copyWith({double? revenue, double? profit}) {
    return _CategoryProfitAgg(
      category: category,
      revenue: revenue ?? this.revenue,
      profit: profit ?? this.profit,
    );
  }
}

class _CustomerAgg {
  const _CustomerAgg({
    required this.name,
    required this.total,
    required this.receiptCount,
    required this.units,
  });

  final String name;
  final double total;
  final int receiptCount;
  final int units;

  _CustomerAgg copyWith({double? total, int? receiptCount, int? units}) {
    return _CustomerAgg(
      name: name,
      total: total ?? this.total,
      receiptCount: receiptCount ?? this.receiptCount,
      units: units ?? this.units,
    );
  }
}

class _SupplierAgg {
  const _SupplierAgg({
    required this.supplierName,
    required this.purchaseTotal,
    required this.purchaseCount,
    required this.outstanding,
  });

  final String supplierName;
  final double purchaseTotal;
  final int purchaseCount;
  final double outstanding;

  _SupplierAgg copyWith({
    double? purchaseTotal,
    int? purchaseCount,
    double? outstanding,
  }) {
    return _SupplierAgg(
      supplierName: supplierName,
      purchaseTotal: purchaseTotal ?? this.purchaseTotal,
      purchaseCount: purchaseCount ?? this.purchaseCount,
      outstanding: outstanding ?? this.outstanding,
    );
  }
}

class _TaxAgg {
  const _TaxAgg({required this.label, required this.tax, required this.sales});

  final String label;
  final double tax;
  final double sales;

  _TaxAgg copyWith({double? tax, double? sales}) {
    return _TaxAgg(
      label: label,
      tax: tax ?? this.tax,
      sales: sales ?? this.sales,
    );
  }
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final iterator = this.iterator;
    if (iterator.moveNext()) return iterator.current;
    return null;
  }
}
