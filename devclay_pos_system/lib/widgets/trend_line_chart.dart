import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../themes/app_colors.dart';
import '../themes/app_spacing.dart';
import '../utils/currency_formatter.dart';
import 'app_card.dart';
import 'section_header.dart';

typedef TrendDateLabelBuilder = String Function(
  DateTime date,
  int index,
  int total,
);

/// Shared line chart with readable Y-axis labels (no overlap).
class TrendLineChart extends StatelessWidget {
  const TrendLineChart({
    super.key,
    required this.title,
    required this.subtitle,
    required this.values,
    required this.dates,
    this.color,
    this.trailing,
    this.height = 220,
    this.dateLabelBuilder,
    this.emptyMessage = 'No data for this period.',
  });

  final String title;
  final String subtitle;
  final List<double> values;
  final List<DateTime> dates;
  final Color? color;
  final Widget? trailing;
  final double height;
  final TrendDateLabelBuilder? dateLabelBuilder;
  final String emptyMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lineColor = color ?? AppColors.accent;
    final spots = <FlSpot>[];
    for (var i = 0; i < values.length; i++) {
      spots.add(FlSpot(i.toDouble(), values[i]));
    }

    final dataMax =
        values.isEmpty ? 0.0 : values.reduce((a, b) => a > b ? a : b);
    final maxY = ChartAxisHelper.niceMaxY(dataMax);
    final interval = ChartAxisHelper.intervalFor(maxY);
    final singlePoint = spots.length == 1;

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(
            title: title,
            subtitle: subtitle,
            trailing: trailing,
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            height: height,
            child: spots.isEmpty
                ? Center(
                    child: Text(
                      emptyMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall,
                    ),
                  )
                : LineChart(
                    LineChartData(
                      minX: singlePoint ? -0.5 : 0,
                      maxX: singlePoint
                          ? 0.5
                          : (spots.length - 1).toDouble(),
                      minY: 0,
                      maxY: maxY,
                      gridData: ChartAxisHelper.horizontalGrid(theme, interval),
                      borderData: FlBorderData(show: false),
                      titlesData: FlTitlesData(
                        topTitles: const AxisTitles(),
                        rightTitles: const AxisTitles(),
                        leftTitles: ChartAxisHelper.leftAxisTitles(
                          maxY: maxY,
                          style: theme.textTheme.labelSmall,
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: values.length > 12
                                ? (values.length / 6).ceilToDouble()
                                : values.length > 7
                                    ? 2
                                    : 1,
                            getTitlesWidget: (value, meta) {
                              final index = value.round();
                              if (index < 0 || index >= dates.length) {
                                return const SizedBox.shrink();
                              }
                              final label = dateLabelBuilder?.call(
                                    dates[index],
                                    index,
                                    dates.length,
                                  ) ??
                                  DateFormat('d MMM').format(dates[index]);
                              return Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  label,
                                  style: theme.textTheme.labelSmall,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          getTooltipItems: (touchedSpots) => touchedSpots
                              .map(
                                (spot) => LineTooltipItem(
                                  CurrencyFormatter.format(spot.y),
                                  theme.textTheme.labelMedium!.copyWith(
                                    color: Colors.white,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          spots: spots,
                          isCurved: spots.length > 2,
                          barWidth: 3,
                          color: lineColor,
                          dotData: FlDotData(
                            show: singlePoint || spots.length <= 2,
                            getDotPainter: (spot, percent, bar, index) =>
                                FlDotCirclePainter(
                              radius: singlePoint ? 6 : 4,
                              color: lineColor,
                              strokeWidth: 2,
                              strokeColor: theme.colorScheme.surface,
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            color: lineColor.withValues(alpha: 0.12),
                          ),
                        ),
                      ],
                    ),
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeOutCubic,
                  ),
          ),
        ],
      ),
    );
  }
}

abstract final class ChartAxisHelper {
  static const int _targetTicks = 5;

  /// Picks a human-readable step size targeting ~5 Y-axis ticks at any scale.
  static double intervalFor(double maxY) {
    if (maxY <= 0) return 1;
    final rough = maxY / _targetTicks;
    final exponent = (math.log(rough) / math.ln10).floor();
    final magnitude = math.pow(10, exponent).toDouble();
    final normalized = rough / magnitude;
    final nice = normalized <= 1
        ? 1.0
        : normalized <= 2
            ? 2.0
            : normalized <= 5
                ? 5.0
                : 10.0;
    return nice * magnitude;
  }

  /// Rounds max up to a clean interval so axis ticks land on round numbers.
  static double niceMaxY(double dataMax) {
    if (dataMax <= 0) return 1;
    final padded = dataMax * 1.08;
    final interval = intervalFor(padded);
    final steps = (padded / interval).ceil();
    return steps * interval;
  }

  static double reservedLeftSize(double maxY) {
    final label = CurrencyFormatter.axisCompact(maxY);
    return (label.length * 7.5 + 14).clamp(44, 72);
  }

  static FlGridData horizontalGrid(ThemeData theme, double interval) {
    return FlGridData(
      show: true,
      drawVerticalLine: false,
      horizontalInterval: interval,
      getDrawingHorizontalLine: (value) => FlLine(
        color: theme.colorScheme.outline.withValues(alpha: 0.35),
        strokeWidth: 1,
      ),
    );
  }

  static AxisTitles leftAxisTitles({
    required double maxY,
    TextStyle? style,
  }) {
    final interval = intervalFor(maxY);
    return AxisTitles(
      sideTitles: SideTitles(
        showTitles: true,
        reservedSize: reservedLeftSize(maxY),
        interval: interval,
        getTitlesWidget: (value, meta) => leftTitle(
          value: value,
          meta: meta,
          style: style,
        ),
      ),
    );
  }

  static bool _isOnInterval(double value, double interval) {
    if (interval <= 0) return true;
    if (value.abs() < interval * 0.001) return true;
    final step = (value / interval).round();
    return (value - step * interval).abs() < interval * 0.05;
  }

  static Widget leftTitle({
    required double value,
    required TitleMeta meta,
    TextStyle? style,
  }) {
    if (value < -0.01 || value > meta.max + 0.01) {
      return const SizedBox.shrink();
    }

    final interval = intervalFor(meta.max);
    final onStep = _isOnInterval(value, interval);
    final isAxisMax = (value - meta.max).abs() < interval * 0.05;

    // fl_chart always paints a label at maxY — drop it when it's not a step.
    if (isAxisMax && !onStep) {
      return const SizedBox.shrink();
    }
    if (!onStep) {
      return const SizedBox.shrink();
    }

    final label = CurrencyFormatter.axisCompact(value);
    return SideTitleWidget(
      meta: meta,
      space: 8,
      child: SizedBox(
        width: reservedLeftSize(meta.max) - 10,
        child: Text(
          label,
          style: style?.copyWith(fontSize: 10),
          textAlign: TextAlign.right,
          maxLines: 1,
          overflow: TextOverflow.clip,
        ),
      ),
    );
  }
}
