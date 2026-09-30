import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../themes/app_colors.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/trend_line_chart.dart';
import '../../domain/entities/dashboard_data.dart';

class SalesChartCard extends StatefulWidget {
  const SalesChartCard({
    super.key,
    required this.series,
    required this.storeName,
    this.hourlySales = const [],
  });

  final List<SalesSeriesPoint> series;
  final String storeName;
  final List<HourlySalesPoint> hourlySales;

  @override
  State<SalesChartCard> createState() => _SalesChartCardState();
}

class _SalesChartCardState extends State<SalesChartCard> {
  bool _showProfit = false;
  bool _showHourly = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final series = widget.series;
    final values = _showHourly
        ? widget.hourlySales.map((e) => e.amount).toList()
        : series.map((e) => _showProfit ? e.profit : e.amount).toList();
    final dates = _showHourly
        ? widget.hourlySales
            .map((e) => DateTime(2000, 1, 1, e.hour))
            .toList()
        : series.map((e) => e.date).toList();
    final total = values.isEmpty ? 0.0 : values.reduce((a, b) => a + b);

    return TrendLineChart(
      title: _showHourly
          ? 'Today hourly'
          : (_showProfit ? 'Profit trend' : 'Sales trend'),
      subtitle: _showHourly
          ? 'Sales by hour · ${widget.storeName}'
          : 'Last 14 days · ${widget.storeName}',
      values: values,
      dates: dates,
      height: 200,
      color: _showProfit ? AppColors.success : AppColors.accent,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SegmentedButton<String>(
            style: const ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            segments: const [
              ButtonSegment(value: 'sales', label: Text('Sales')),
              ButtonSegment(value: 'profit', label: Text('Profit')),
              ButtonSegment(value: 'hour', label: Text('Hourly')),
            ],
            selected: {
              if (_showHourly) 'hour' else if (_showProfit) 'profit' else 'sales',
            },
            onSelectionChanged: (set) {
              final v = set.first;
              setState(() {
                _showHourly = v == 'hour';
                _showProfit = v == 'profit';
              });
            },
          ),
          const SizedBox(width: 8),
          Text(
            CurrencyFormatter.compact(total),
            style: theme.textTheme.titleMedium?.copyWith(
              color: _showProfit ? AppColors.success : AppColors.accent,
            ),
          ),
        ],
      ),
      dateLabelBuilder: (date, index, total) => _showHourly
          ? DateFormat('H').format(date)
          : DateFormat('E').format(date),
      emptyMessage: 'No sales data',
    );
  }
}
