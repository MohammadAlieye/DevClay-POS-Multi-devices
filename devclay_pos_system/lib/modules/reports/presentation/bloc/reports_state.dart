part of 'reports_bloc.dart';

sealed class ReportsState extends Equatable {
  const ReportsState();

  @override
  List<Object?> get props => [];
}

class ReportsInitial extends ReportsState {
  const ReportsInitial();
}

class ReportsLoading extends ReportsState {
  const ReportsLoading();
}

class ReportsError extends ReportsState {
  const ReportsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class ReportsCenterReady extends ReportsState {
  const ReportsCenterReady({required this.filterOptions});

  final ReportFilterOptions filterOptions;

  @override
  List<Object?> get props => [filterOptions];
}

class ReportDetailLoading extends ReportsState {
  const ReportDetailLoading({
    required this.reportId,
    required this.filters,
  });

  final ReportId reportId;
  final ReportFilters filters;

  @override
  List<Object?> get props => [reportId, filters];
}

class ReportDetailLoaded extends ReportsState {
  const ReportDetailLoaded({
    required this.reportId,
    required this.filters,
    required this.dateRange,
    required this.payload,
    required this.filterOptions,
  });

  final ReportId reportId;
  final ReportFilters filters;
  final ReportDateRange dateRange;
  final ReportDetailPayload payload;
  final ReportFilterOptions filterOptions;

  @override
  List<Object?> get props =>
      [reportId, filters, dateRange, payload, filterOptions];
}

/// Legacy combined-tab state — preserved for existing chart widgets.
class ReportsLoaded extends ReportsState {
  const ReportsLoaded({
    required this.data,
    required this.period,
    required this.viewTab,
  });

  final ReportsData data;
  final ReportsPeriod period;
  final ReportsViewTab viewTab;

  ReportsLoaded copyWith({
    ReportsData? data,
    ReportsPeriod? period,
    ReportsViewTab? viewTab,
  }) {
    return ReportsLoaded(
      data: data ?? this.data,
      period: period ?? this.period,
      viewTab: viewTab ?? this.viewTab,
    );
  }

  @override
  List<Object?> get props => [data, period, viewTab];
}
