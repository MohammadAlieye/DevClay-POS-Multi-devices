import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../themes/app_colors.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/trend_line_chart.dart';
import '../../domain/entities/dashboard_data.dart';

class SalesChartCard extends StatelessWidget {
  const SalesChartCard({
    super.key,
    required this.series,
    required this.storeName,
  });

  final List<SalesSeriesPoint> series;
  final String storeName;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = series.isEmpty
        ? 0.0
        : series.map((e) => e.amount).reduce((a, b) => a + b);

    return TrendLineChart(
      title: 'Sales trend',
      subtitle: 'Last 14 days · $storeName',
      values: series.map((point) => point.amount).toList(),
      dates: series.map((point) => point.date).toList(),
      height: 240,
      trailing: Text(
        CurrencyFormatter.compact(total),
        style: theme.textTheme.titleMedium?.copyWith(
          color: AppColors.accent,
        ),
      ),
      dateLabelBuilder: (date, index, total) => DateFormat('E').format(date),
      emptyMessage: 'No sales data',
    );
  }
}
