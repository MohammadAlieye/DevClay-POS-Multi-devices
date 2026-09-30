import 'package:equatable/equatable.dart';

/// Preset date ranges for report queries.
enum ReportPeriodPreset {
  today,
  yesterday,
  week,
  month,
  year,
  all,
  custom,
}

/// Legacy alias — maps to [ReportPeriodPreset] for backward compatibility.
enum ReportsPeriod { today, week, month, all }

extension ReportsPeriodCompat on ReportsPeriod {
  ReportPeriodPreset toPreset() => switch (this) {
        ReportsPeriod.today => ReportPeriodPreset.today,
        ReportsPeriod.week => ReportPeriodPreset.week,
        ReportsPeriod.month => ReportPeriodPreset.month,
        ReportsPeriod.all => ReportPeriodPreset.all,
      };
}

extension ReportPeriodPresetCompat on ReportPeriodPreset {
  ReportsPeriod? toLegacy() => switch (this) {
        ReportPeriodPreset.today => ReportsPeriod.today,
        ReportPeriodPreset.week => ReportsPeriod.week,
        ReportPeriodPreset.month => ReportsPeriod.month,
        ReportPeriodPreset.all => ReportsPeriod.all,
        _ => null,
      };
}

/// Global filters applied across report queries.
class ReportFilters extends Equatable {
  const ReportFilters({
    this.period = ReportPeriodPreset.month,
    this.customStart,
    this.customEnd,
    this.userId,
    this.category,
    this.productId,
    this.supplierId,
    this.customerId,
    this.paymentMethod,
    this.branchId,
    this.expiryWithinDays,
  });

  final ReportPeriodPreset period;
  final DateTime? customStart;
  final DateTime? customEnd;
  final int? userId;
  final String? category;
  final int? productId;
  final int? supplierId;
  final int? customerId;
  final String? paymentMethod;
  final int? branchId;
  /// For expiry reports — days until expiry (negative = already expired).
  final int? expiryWithinDays;

  ReportFilters copyWith({
    ReportPeriodPreset? period,
    DateTime? customStart,
    DateTime? customEnd,
    int? userId,
    String? category,
    int? productId,
    int? supplierId,
    int? customerId,
    String? paymentMethod,
    int? branchId,
    int? expiryWithinDays,
    bool clearCustomRange = false,
    bool clearUserId = false,
    bool clearCategory = false,
    bool clearProductId = false,
    bool clearSupplierId = false,
    bool clearCustomerId = false,
    bool clearPaymentMethod = false,
    bool clearBranchId = false,
    bool clearExpiryWithinDays = false,
  }) {
    return ReportFilters(
      period: period ?? this.period,
      customStart: clearCustomRange ? null : (customStart ?? this.customStart),
      customEnd: clearCustomRange ? null : (customEnd ?? this.customEnd),
      userId: clearUserId ? null : (userId ?? this.userId),
      category: clearCategory ? null : (category ?? this.category),
      productId: clearProductId ? null : (productId ?? this.productId),
      supplierId: clearSupplierId ? null : (supplierId ?? this.supplierId),
      customerId: clearCustomerId ? null : (customerId ?? this.customerId),
      paymentMethod:
          clearPaymentMethod ? null : (paymentMethod ?? this.paymentMethod),
      branchId: clearBranchId ? null : (branchId ?? this.branchId),
      expiryWithinDays: clearExpiryWithinDays
          ? null
          : (expiryWithinDays ?? this.expiryWithinDays),
    );
  }

  bool get hasExtraFilters =>
      userId != null ||
      category != null ||
      productId != null ||
      supplierId != null ||
      customerId != null ||
      paymentMethod != null ||
      branchId != null;

  @override
  List<Object?> get props => [
        period,
        customStart,
        customEnd,
        userId,
        category,
        productId,
        supplierId,
        customerId,
        paymentMethod,
        branchId,
        expiryWithinDays,
      ];
}

/// Resolved inclusive date range for a filter set.
class ReportDateRange extends Equatable {
  const ReportDateRange({
    required this.start,
    required this.end,
    required this.label,
  });

  final DateTime start;
  final DateTime end;
  final String label;

  bool contains(DateTime date) {
    return !date.isBefore(start) && date.isBefore(end);
  }

  @override
  List<Object?> get props => [start, end, label];
}
