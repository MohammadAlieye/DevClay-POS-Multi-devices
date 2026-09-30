import '../entities/report_filters.dart';

abstract final class ReportPeriodUtils {
  static ReportDateRange resolve(ReportFilters filters, {DateTime? now}) {
    final anchor = now ?? DateTime.now();
    final todayStart = DateTime(anchor.year, anchor.month, anchor.day);

    return switch (filters.period) {
      ReportPeriodPreset.today => ReportDateRange(
          start: todayStart,
          end: todayStart.add(const Duration(days: 1)),
          label: 'Today',
        ),
      ReportPeriodPreset.yesterday => () {
          final start = todayStart.subtract(const Duration(days: 1));
          return ReportDateRange(
            start: start,
            end: todayStart,
            label: 'Yesterday',
          );
        }(),
      ReportPeriodPreset.week => () {
          final start = todayStart.subtract(Duration(days: anchor.weekday - 1));
          return ReportDateRange(
            start: start,
            end: start.add(const Duration(days: 7)),
            label: 'This week',
          );
        }(),
      ReportPeriodPreset.month => ReportDateRange(
          start: DateTime(anchor.year, anchor.month),
          end: DateTime(anchor.year, anchor.month + 1),
          label: 'This month',
        ),
      ReportPeriodPreset.year => ReportDateRange(
          start: DateTime(anchor.year),
          end: DateTime(anchor.year + 1),
          label: 'This year',
        ),
      ReportPeriodPreset.all => ReportDateRange(
          start: DateTime(1970),
          end: DateTime(2100),
          label: 'All time',
        ),
      ReportPeriodPreset.custom => () {
          final start = filters.customStart ?? todayStart;
          final endRaw = filters.customEnd ?? anchor;
          final endDay = DateTime(endRaw.year, endRaw.month, endRaw.day);
          return ReportDateRange(
            start: DateTime(start.year, start.month, start.day),
            end: endDay.add(const Duration(days: 1)),
            label: 'Custom range',
          );
        }(),
    };
  }

  static bool inRange(DateTime date, ReportDateRange range) =>
      range.contains(date);

  static bool inPeriod(DateTime date, ReportPeriodPreset period, {DateTime? now}) {
    return inRange(date, resolve(ReportFilters(period: period), now: now));
  }

  /// Legacy helper for [ReportsPeriod].
  static bool inLegacyPeriod(DateTime date, ReportsPeriod period, {DateTime? now}) {
    final preset = period.toPreset();
    return inPeriod(date, preset, now: now);
  }

  static DateTime trendBucket(DateTime date, ReportPeriodPreset period) {
    return switch (period) {
      ReportPeriodPreset.today => DateTime(date.year, date.month, date.day, date.hour),
      _ => DateTime(date.year, date.month, date.day),
    };
  }

  static void seedTrendBuckets(
    Map<DateTime, dynamic> buckets,
    ReportPeriodPreset period, {
    DateTime? now,
    required dynamic Function(DateTime date) create,
  }) {
    if (period != ReportPeriodPreset.today) return;
    final anchor = now ?? DateTime.now();
    for (var hour = 0; hour <= anchor.hour; hour++) {
      final bucket = DateTime(anchor.year, anchor.month, anchor.day, hour);
      buckets.putIfAbsent(bucket, () => create(bucket));
    }
  }

  static String presetLabel(ReportPeriodPreset period) => switch (period) {
        ReportPeriodPreset.today => 'Today',
        ReportPeriodPreset.yesterday => 'Yesterday',
        ReportPeriodPreset.week => 'This week',
        ReportPeriodPreset.month => 'This month',
        ReportPeriodPreset.year => 'This year',
        ReportPeriodPreset.all => 'All time',
        ReportPeriodPreset.custom => 'Custom range',
      };
}
