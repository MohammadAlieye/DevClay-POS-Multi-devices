import '../../data/services/report_export_service.dart';
import '../../domain/entities/report_catalog.dart';
import '../bloc/reports_bloc.dart';
import 'report_filter_toolbar.dart';

Future<ReportExportPayload> buildReportExportPayload({
  required ReportDefinition definition,
  required ReportDetailLoaded state,
  required String businessName,
}) async {
  final payload = state.payload;
  final rangeLabel = reportDateRangeDetail(state.dateRange, state.filters);
  final filterLabels = <String>[];

  if (state.filters.category != null) {
    filterLabels.add('Category: ${state.filters.category}');
  }
  if (state.filters.paymentMethod != null) {
    filterLabels.add('Payment: ${state.filters.paymentMethod}');
  }
  if (state.filters.customerId != null) {
    final match = state.filterOptions.customers
        .where((c) => c.$1 == state.filters.customerId)
        .firstOrNull;
    if (match != null) filterLabels.add('Customer: ${match.$2}');
  }
  if (state.filters.supplierId != null) {
    final match = state.filterOptions.suppliers
        .where((s) => s.$1 == state.filters.supplierId)
        .firstOrNull;
    if (match != null) filterLabels.add('Supplier: ${match.$2}');
  }
  if (state.filters.productId != null) {
    final match = state.filterOptions.products
        .where((p) => p.$1 == state.filters.productId)
        .firstOrNull;
    if (match != null) filterLabels.add('Product: ${match.$2}');
  }

  final summaryRows = <(String, String)>[];
  final columns = <ReportExportColumn>[];
  final rows = <Map<String, dynamic>>[];

  switch (definition.id) {
    case ReportId.sales:
      final m = payload.salesMetrics;
      if (m != null) {
        summaryRows.addAll([
          ('Net sales', ReportExportService.formatCurrency(m.netSales)),
          ('Receipts', '${m.receiptCount}'),
          ('Discounts', ReportExportService.formatCurrency(m.discounts)),
          ('Tax collected', ReportExportService.formatCurrency(m.taxCollected)),
        ]);
      }
      columns.addAll([
        ReportExportColumn('Product', (r) => r['name'] as String),
        ReportExportColumn('SKU', (r) => r['sku'] as String),
        ReportExportColumn('Units', (r) => '${r['units']}'),
        ReportExportColumn(
          'Revenue',
          (r) => ReportExportService.formatCurrency(r['revenue'] as num),
        ),
      ]);
      for (final p in payload.topProducts) {
        rows.add({
          'name': p.name,
          'sku': p.sku,
          'units': p.unitsSold,
          'revenue': p.revenue,
        });
      }

    case ReportId.profit:
      final m = payload.profitMetrics;
      if (m != null) {
        summaryRows.addAll([
          ('Gross profit', ReportExportService.formatCurrency(m.grossProfit)),
          ('COGS', ReportExportService.formatCurrency(m.cogs)),
          ('Net profit', ReportExportService.formatCurrency(m.netProfit)),
          ('Gross margin', '${m.grossMarginPct.toStringAsFixed(1)}%'),
        ]);
      }
      columns.addAll([
        ReportExportColumn('Product', (r) => r['name'] as String),
        ReportExportColumn(
          'Revenue',
          (r) => ReportExportService.formatCurrency(r['revenue'] as num),
        ),
        ReportExportColumn(
          'Profit',
          (r) => ReportExportService.formatCurrency(r['profit'] as num),
        ),
      ]);
      for (final p in payload.topProducts) {
        rows.add({
          'name': p.name,
          'revenue': p.revenue,
          'profit': p.estimatedProfit,
        });
      }

    case ReportId.expenses:
      summaryRows.add((
        'Total expenses',
        ReportExportService.formatCurrency(payload.summary.totalExpenses),
      ));
      columns.addAll([
        ReportExportColumn('Category', (r) => r['category'] as String),
        ReportExportColumn(
          'Amount',
          (r) => ReportExportService.formatCurrency(r['amount'] as num),
        ),
        ReportExportColumn('Entries', (r) => '${r['count']}'),
      ]);
      for (final c in payload.expenseCategories) {
        rows.add({'category': c.category, 'amount': c.total, 'count': c.count});
      }

    case ReportId.expiry:
    case ReportId.expiringSoon:
    case ReportId.expiredProducts:
      columns.addAll([
        ReportExportColumn('Product', (r) => r['product'] as String),
        ReportExportColumn('SKU', (r) => r['sku'] as String),
        ReportExportColumn('Batch', (r) => r['batch'] as String),
        ReportExportColumn('Qty', (r) => '${r['qty']}'),
        ReportExportColumn('Unit', (r) => r['unit'] as String),
        ReportExportColumn('Days left', (r) => '${r['days']}'),
        ReportExportColumn(
          'Value',
          (r) => ReportExportService.formatCurrency(r['value'] as num),
        ),
      ]);
      for (final e in payload.expiryRows) {
        rows.add({
          'product': e.productName,
          'sku': e.sku,
          'batch': e.batchCode,
          'qty': e.quantity,
          'unit': e.unit,
          'days': e.daysRemaining,
          'value': e.stockValue,
        });
      }

    default:
      summaryRows.add(('Records', '${rows.length}'));
      columns.add(
        ReportExportColumn('Item', (r) => r['label'] as String? ?? ''),
      );
      columns.add(
        ReportExportColumn('Value', (r) => r['value'] as String? ?? ''),
      );
  }

  return ReportExportPayload(
    businessName: businessName,
    reportTitle: definition.title,
    dateRangeLabel: rangeLabel,
    filterLabels: filterLabels,
    summaryRows: summaryRows,
    columns: columns,
    rows: rows,
  );
}

extension _FirstOrNull<E> on Iterable<E> {
  E? get firstOrNull {
    final it = iterator;
    if (it.moveNext()) return it.current;
    return null;
  }
}
