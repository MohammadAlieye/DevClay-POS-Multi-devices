import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../database/collections/audit_entry.dart';
import '../../../../database/collections/cash_shift.dart';
import '../../../../database/collections/purchase_return.dart';
import '../../../../database/collections/sale.dart';
import '../../../../database/collections/sale_return.dart';
import '../../../../database/isar_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/section_header.dart';
import '../../../../widgets/trend_line_chart.dart';
import '../../domain/entities/report_catalog.dart';
import '../../domain/entities/report_detail_payload.dart';
import '../../domain/entities/report_filters.dart';
import '../bloc/reports_bloc.dart';
import '../widgets/legacy_report_tabs.dart';
import '../widgets/report_shared_widgets.dart';

class ReportBody extends StatelessWidget {
  const ReportBody({
    super.key,
    required this.definition,
    required this.state,
    required this.periodLabel,
  });

  final ReportDefinition definition;
  final ReportDetailLoaded state;
  final String periodLabel;

  @override
  Widget build(BuildContext context) {
    final payload = state.payload;
    final legacyPeriod = legacyPeriodFromFilters(state.filters.period);
    final data = payload.legacyData;

    return switch (definition.id) {
      ReportId.sales => LegacySalesTab(
        data: data,
        period: legacyPeriod,
        periodLabel: periodLabel,
      ),
      ReportId.profit => LegacyProfitTab(
        summary: payload.summary,
        products: payload.topProducts,
        trend: payload.trend,
        period: legacyPeriod,
        periodLabel: periodLabel,
        usedBatchCost: payload.usedBatchCost,
      ),
      ReportId.expenses => LegacyExpensesTab(
        summary: payload.summary,
        trend: payload.trend,
        expenseCategories: payload.expenseCategories,
        period: legacyPeriod,
        periodLabel: periodLabel,
      ),
      ReportId.stock ||
      ReportId.stockValuation ||
      ReportId.lowStock => LegacyInventoryTab(
        summary: payload.summary,
        lowStock: payload.lowStock,
        categories: payload.categories,
      ),
      ReportId.purchases => LegacyPurchasesTab(
        summary: payload.summary,
        trend: payload.trend,
        period: legacyPeriod,
        periodLabel: periodLabel,
      ),
      ReportId.outOfStock => _outOfStockView(payload),
      ReportId.stockMovement => _stockMovementView(payload),
      ReportId.expiringSoon ||
      ReportId.expiredProducts ||
      ReportId.expiry => _expiryView(payload),
      ReportId.fastMoving ||
      ReportId.slowMoving ||
      ReportId.deadStock => _velocityView(payload, definition.id),
      ReportId.suppliers || ReportId.outstandingSupplierPayments =>
        _supplierView(payload, definition.id),
      ReportId.customerSales ||
      ReportId.topCustomers ||
      ReportId.customerPurchaseHistory => _customerView(payload),
      ReportId.customerOutstandingBalance => _customerBalanceView(payload),
      ReportId.discounts => _discountView(payload, periodLabel),
      ReportId.taxSummary ||
      ReportId.taxCollected ||
      ReportId.taxByProduct ||
      ReportId.taxByPeriod => _taxView(
        payload,
        definition.id,
        periodLabel,
        legacyPeriod,
      ),
      ReportId.stockAdjustments => _adjustmentView(payload),
      ReportId.cashierStaff ||
      ReportId.shifts ||
      ReportId.returnsRefunds ||
      ReportId.voidedSales ||
      ReportId.purchaseReturns ||
      ReportId.auditLog ||
      ReportId.userActivity => _operationalView(definition.id),
    };
  }

  Widget _outOfStockView(ReportDetailPayload payload) {
    final metrics = payload.inventoryMetrics;
    return ListView(
      children: [
        if (metrics != null)
          ReportSummaryCards(
            cards: [
              ReportSummaryCardData(
                label: 'Out of stock',
                value: '${metrics.outOfStockCount}',
                color: AppColors.warning,
                icon: Symbols.remove_shopping_cart,
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: ReportDataTable(
            emptyMessage: 'No out-of-stock products.',
            columns: const [
              DataColumn(label: Text('Product')),
              DataColumn(label: Text('SKU')),
              DataColumn(label: Text('Stock')),
            ],
            rows: payload.outOfStock
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(row.name)),
                      DataCell(Text(row.sku)),
                      DataCell(Text('${row.stock}')),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _stockMovementView(ReportDetailPayload payload) {
    return ListView(
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SectionHeader(
                title: 'Stock movement',
                subtitle: 'All movement types',
              ),
              ReportDataTable(
                emptyMessage: 'No stock movements found for this period.',
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Type')),
                  DataColumn(label: Text('Change')),
                  DataColumn(label: Text('After')),
                ],
                rows: payload.stockMovementRows
                    .map(
                      (row) => DataRow(
                        cells: [
                          DataCell(
                            Text(
                              DateFormat('dd MMM yyyy HH:mm').format(row.date),
                            ),
                          ),
                          DataCell(Text(row.productName)),
                          DataCell(Text(row.type)),
                          DataCell(Text('${row.quantityChange}')),
                          DataCell(Text('${row.quantityAfter}')),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _expiryView(ReportDetailPayload payload) {
    return ListView(
      children: [
        if (payload.inventoryMetrics != null)
          ReportSummaryCards(
            cards: [
              ReportSummaryCardData(
                label: 'Expiring soon (30d)',
                value: '${payload.inventoryMetrics!.expiringSoonCount}',
                icon: Symbols.schedule,
              ),
              ReportSummaryCardData(
                label: 'Expired',
                value: '${payload.inventoryMetrics!.expiredCount}',
                color: AppColors.warning,
                icon: Symbols.event_busy,
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: ReportDataTable(
            emptyMessage: 'No expiry records match the selected filters.',
            columns: const [
              DataColumn(label: Text('Product')),
              DataColumn(label: Text('SKU')),
              DataColumn(label: Text('Batch')),
              DataColumn(label: Text('Qty')),
              DataColumn(label: Text('Unit')),
              DataColumn(label: Text('Expiry')),
              DataColumn(label: Text('Days left')),
              DataColumn(label: Text('Value')),
              DataColumn(label: Text('Supplier')),
            ],
            rows: payload.expiryRows
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(row.productName)),
                      DataCell(Text(row.sku)),
                      DataCell(Text(row.batchCode)),
                      DataCell(Text('${row.quantity}')),
                      DataCell(Text(row.unit)),
                      DataCell(
                        Text(
                          row.expiryDate == null
                              ? '—'
                              : DateFormat(
                                  'dd MMM yyyy',
                                ).format(row.expiryDate!),
                        ),
                      ),
                      DataCell(Text('${row.daysRemaining}')),
                      DataCell(Text(CurrencyFormatter.format(row.stockValue))),
                      DataCell(Text(row.supplierName)),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _velocityView(ReportDetailPayload payload, ReportId id) {
    final empty = switch (id) {
      ReportId.deadStock => 'No dead stock found for this period.',
      ReportId.slowMoving => 'No slow-moving products found.',
      _ => 'No fast-moving products found.',
    };
    final title = switch (id) {
      ReportId.deadStock => 'Dead stock',
      ReportId.slowMoving => 'Slow moving products',
      _ => 'Fast moving products',
    };

    return ListView(
      children: [
        AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SectionHeader(title: title),
              ReportDataTable(
                emptyMessage: empty,
                columns: const [
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('SKU')),
                  DataColumn(label: Text('Units sold')),
                  DataColumn(label: Text('Revenue')),
                  DataColumn(label: Text('Stock')),
                  DataColumn(label: Text('Days since sale')),
                ],
                rows: payload.velocityRows
                    .map(
                      (row) => DataRow(
                        cells: [
                          DataCell(Text(row.name)),
                          DataCell(Text(row.sku)),
                          DataCell(Text('${row.unitsSold}')),
                          DataCell(Text(CurrencyFormatter.format(row.revenue))),
                          DataCell(Text('${row.stock}')),
                          DataCell(
                            Text(row.daysSinceLastSale?.toString() ?? '—'),
                          ),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _supplierView(ReportDetailPayload payload, ReportId id) {
    final rows = id == ReportId.outstandingSupplierPayments
        ? payload.supplierRows.where((r) => r.outstanding > 0).toList()
        : payload.supplierRows;

    return ListView(
      children: [
        if (payload.purchaseMetrics != null)
          ReportSummaryCards(
            cards: [
              ReportSummaryCardData(
                label: 'Outstanding',
                value: CurrencyFormatter.format(
                  payload.purchaseMetrics!.outstandingAmount,
                ),
                color: AppColors.warning,
              ),
            ],
          ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: ReportDataTable(
            emptyMessage: 'No supplier purchase data found.',
            columns: const [
              DataColumn(label: Text('Supplier')),
              DataColumn(label: Text('Purchases')),
              DataColumn(label: Text('Total')),
              DataColumn(label: Text('Outstanding')),
            ],
            rows: rows
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(row.supplierName)),
                      DataCell(Text('${row.purchaseCount}')),
                      DataCell(
                        Text(CurrencyFormatter.format(row.purchaseTotal)),
                      ),
                      DataCell(Text(CurrencyFormatter.format(row.outstanding))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _customerView(ReportDetailPayload payload) {
    return ListView(
      children: [
        AppCard(
          child: ReportDataTable(
            emptyMessage: 'No customer sales found for this period.',
            columns: const [
              DataColumn(label: Text('Customer')),
              DataColumn(label: Text('Receipts')),
              DataColumn(label: Text('Units')),
              DataColumn(label: Text('Total')),
            ],
            rows: payload.customerRows
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(row.customerName)),
                      DataCell(Text('${row.receiptCount}')),
                      DataCell(Text('${row.units}')),
                      DataCell(Text(CurrencyFormatter.format(row.total))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _customerBalanceView(ReportDetailPayload payload) {
    return ListView(
      children: [
        AppCard(
          child: ReportDataTable(
            emptyMessage: 'No outstanding customer balances.',
            columns: const [
              DataColumn(label: Text('Customer')),
              DataColumn(label: Text('Phone')),
              DataColumn(label: Text('Balance')),
              DataColumn(label: Text('Credit limit')),
            ],
            rows: payload.customerLedgerRows
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(row.customerName)),
                      DataCell(Text(row.phone)),
                      DataCell(Text(CurrencyFormatter.format(row.balance))),
                      DataCell(Text(CurrencyFormatter.format(row.creditLimit))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _discountView(ReportDetailPayload payload, String periodLabel) {
    final total = payload.discountRows.fold(
      0.0,
      (s, r) => s + r.discountAmount,
    );
    return ListView(
      children: [
        ReportSummaryCards(
          cards: [
            ReportSummaryCardData(
              label: 'Total discounts · $periodLabel',
              value: CurrencyFormatter.format(total),
              icon: Symbols.sell,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: ReportDataTable(
            emptyMessage: 'No discounts recorded for this period.',
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Reference')),
              DataColumn(label: Text('Discount')),
              DataColumn(label: Text('Sale total')),
            ],
            rows: payload.discountRows
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(
                        Text(DateFormat('dd MMM yyyy').format(row.date)),
                      ),
                      DataCell(Text(row.label)),
                      DataCell(
                        Text(CurrencyFormatter.format(row.discountAmount)),
                      ),
                      DataCell(Text(CurrencyFormatter.format(row.saleTotal))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _taxView(
    ReportDetailPayload payload,
    ReportId id,
    String periodLabel,
    ReportsPeriod legacyPeriod,
  ) {
    if (id == ReportId.taxByPeriod) {
      return ListView(
        children: [
          TrendLineChart(
            title: 'Tax by period',
            subtitle: periodLabel,
            values: payload.taxTrend.map((p) => p.sales).toList(),
            dates: payload.taxTrend.map((p) => p.date).toList(),
            dateLabelBuilder: legacyTrendDateLabel(legacyPeriod),
            emptyMessage: 'No tax collected in this period.',
          ),
        ],
      );
    }

    final totalTax = payload.salesMetrics?.taxCollected ?? 0;
    return ListView(
      children: [
        ReportSummaryCards(
          cards: [
            ReportSummaryCardData(
              label: 'Tax collected · $periodLabel',
              value: CurrencyFormatter.format(totalTax),
              icon: Symbols.receipt,
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        AppCard(
          child: ReportDataTable(
            emptyMessage: 'No tax data for this period.',
            columns: const [
              DataColumn(label: Text('Product')),
              DataColumn(label: Text('Tax')),
              DataColumn(label: Text('Sales')),
            ],
            rows: payload.taxRows
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(Text(row.label)),
                      DataCell(Text(CurrencyFormatter.format(row.taxAmount))),
                      DataCell(Text(CurrencyFormatter.format(row.salesTotal))),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _adjustmentView(ReportDetailPayload payload) {
    return ListView(
      children: [
        AppCard(
          child: ReportDataTable(
            emptyMessage: 'No stock adjustments found for this period.',
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Product')),
              DataColumn(label: Text('Change')),
              DataColumn(label: Text('After')),
              DataColumn(label: Text('Note')),
            ],
            rows: payload.adjustmentRows
                .map(
                  (row) => DataRow(
                    cells: [
                      DataCell(
                        Text(DateFormat('dd MMM yyyy HH:mm').format(row.date)),
                      ),
                      DataCell(Text(row.productName)),
                      DataCell(Text('${row.quantityChange}')),
                      DataCell(Text('${row.quantityAfter}')),
                      DataCell(Text(row.note ?? '')),
                    ],
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _operationalView(ReportId id) {
    return FutureBuilder<_OperationalReportData>(
      future: _loadOperationalData(id),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return EmptyState(
            title: 'Could not load report',
            message: '${snapshot.error}',
            icon: Symbols.error,
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView(
          children: [
            ReportSummaryCards(
              cards: [
                ReportSummaryCardData(
                  label: data.summaryLabel,
                  value: data.summaryValue,
                  icon: definition.icon,
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: ReportDataTable(
                emptyMessage: 'No records found for this period.',
                columns: data.headers
                    .map((label) => DataColumn(label: Text(label)))
                    .toList(),
                rows: data.rows
                    .map(
                      (row) => DataRow(
                        cells: row
                            .map((value) => DataCell(Text(value)))
                            .toList(),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<_OperationalReportData> _loadOperationalData(ReportId id) async {
    final isar = sl<IsarService>().instance;
    final range = state.dateRange;
    final date = DateFormat('dd MMM yyyy HH:mm');
    bool included(DateTime value) => range.contains(value);

    if (id == ReportId.shifts) {
      final records =
          (await isar.cashShifts.where().findAll())
              .where((item) => included(item.openedAt))
              .toList()
            ..sort((a, b) => b.openedAt.compareTo(a.openedAt));
      return _OperationalReportData(
        summaryLabel: 'Shifts',
        summaryValue: '${records.length}',
        headers: const [
          'Opened',
          'Cashier',
          'Drawer',
          'Opening',
          'Expected',
          'Counted',
          'Variance',
          'Status',
        ],
        rows: records
            .map(
              (item) => [
                date.format(item.openedAt),
                item.userName,
                item.cashAccountName ?? 'Cash drawer',
                CurrencyFormatter.format(item.openingCash),
                CurrencyFormatter.format(item.expectedCash),
                item.closingCash == null
                    ? '—'
                    : CurrencyFormatter.format(item.closingCash!),
                item.variance == null
                    ? '—'
                    : CurrencyFormatter.format(item.variance!),
                item.status.toUpperCase(),
              ],
            )
            .toList(),
      );
    }

    if (id == ReportId.returnsRefunds || id == ReportId.voidedSales) {
      final voids = id == ReportId.voidedSales;
      final records =
          (await isar.saleReturns.where().findAll())
              .where(
                (item) => included(item.returnedAt) && item.isVoid == voids,
              )
              .toList()
            ..sort((a, b) => b.returnedAt.compareTo(a.returnedAt));
      final total = records.fold<double>(
        0,
        (sum, item) => sum + item.refundAmount,
      );
      return _OperationalReportData(
        summaryLabel: voids ? 'Voided value' : 'Refunded value',
        summaryValue: CurrencyFormatter.format(total),
        headers: const [
          'Date',
          'Reference',
          'Invoice',
          'Customer',
          'Amount',
          'Reason',
          'Approved by',
        ],
        rows: records
            .map(
              (item) => [
                date.format(item.returnedAt),
                item.returnNo,
                item.invoiceNo,
                item.customerName ?? 'Walk-in',
                CurrencyFormatter.format(item.refundAmount),
                item.reason,
                item.approvedByName ?? '—',
              ],
            )
            .toList(),
      );
    }

    if (id == ReportId.purchaseReturns) {
      final records =
          (await isar.purchaseReturns.where().findAll())
              .where((item) => included(item.returnedAt))
              .toList()
            ..sort((a, b) => b.returnedAt.compareTo(a.returnedAt));
      final total = records.fold<double>(0, (sum, item) => sum + item.total);
      return _OperationalReportData(
        summaryLabel: 'Returned to suppliers',
        summaryValue: CurrencyFormatter.format(total),
        headers: const [
          'Date',
          'Reference',
          'Purchase',
          'Supplier',
          'Amount',
          'Reason',
          'User',
        ],
        rows: records
            .map(
              (item) => [
                date.format(item.returnedAt),
                item.returnNo,
                item.invoiceNo,
                item.supplierName,
                CurrencyFormatter.format(item.total),
                item.reason,
                item.userName ?? '—',
              ],
            )
            .toList(),
      );
    }

    if (id == ReportId.cashierStaff) {
      final records = (await isar.sales.where().findAll())
          .where((item) => included(item.soldAt))
          .toList();
      final grouped = <String, ({int receipts, double sales})>{};
      for (final sale in records) {
        final name = sale.cashierName ?? 'Unassigned';
        final old = grouped[name] ?? (receipts: 0, sales: 0.0);
        grouped[name] = (
          receipts: old.receipts + 1,
          sales: old.sales + (sale.total - sale.returnedAmount),
        );
      }
      final rows = grouped.entries.toList()
        ..sort((a, b) => b.value.sales.compareTo(a.value.sales));
      return _OperationalReportData(
        summaryLabel: 'Staff with sales',
        summaryValue: '${rows.length}',
        headers: const ['Cashier', 'Receipts', 'Net sales'],
        rows: rows
            .map(
              (item) => [
                item.key,
                '${item.value.receipts}',
                CurrencyFormatter.format(item.value.sales),
              ],
            )
            .toList(),
      );
    }

    final records =
        (await isar.auditEntrys.where().findAll())
            .where(
              (item) =>
                  included(item.occurredAt) &&
                  (id != ReportId.userActivity || item.userId != null),
            )
            .toList()
          ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
    return _OperationalReportData(
      summaryLabel: id == ReportId.userActivity
          ? 'Staff actions'
          : 'Audit events',
      summaryValue: '${records.length}',
      headers: const ['Date', 'User', 'Action', 'Type', 'Details'],
      rows: records
          .map(
            (item) => [
              date.format(item.occurredAt),
              item.userName ?? 'System',
              item.action.replaceAll('.', ' › '),
              item.entityType,
              item.details,
            ],
          )
          .toList(),
    );
  }
}

class _OperationalReportData {
  const _OperationalReportData({
    required this.summaryLabel,
    required this.summaryValue,
    required this.headers,
    required this.rows,
  });

  final String summaryLabel;
  final String summaryValue;
  final List<String> headers;
  final List<List<String>> rows;
}
