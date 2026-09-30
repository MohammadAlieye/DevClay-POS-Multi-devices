part of 'reports_bloc.dart';

sealed class ReportsEvent extends Equatable {
  const ReportsEvent();

  @override
  List<Object?> get props => [];
}

class ReportsCenterStarted extends ReportsEvent {
  const ReportsCenterStarted();
}

class ReportDetailStarted extends ReportsEvent {
  const ReportDetailStarted({
    required this.reportId,
    this.filters = const ReportFilters(),
  });

  final ReportId reportId;
  final ReportFilters filters;

  @override
  List<Object?> get props => [reportId, filters];
}

class ReportFiltersChanged extends ReportsEvent {
  const ReportFiltersChanged(this.filters);

  final ReportFilters filters;

  @override
  List<Object?> get props => [filters];
}

class ReportsRefreshRequested extends ReportsEvent {
  const ReportsRefreshRequested();
}

// Legacy events — kept for existing tab widgets during migration.
class ReportsStarted extends ReportsEvent {
  const ReportsStarted();
}

class ReportsPeriodChanged extends ReportsEvent {
  const ReportsPeriodChanged(this.period);

  final ReportsPeriod period;

  @override
  List<Object?> get props => [period];
}

class ReportsViewTabChanged extends ReportsEvent {
  const ReportsViewTabChanged(this.tab);

  final ReportsViewTab tab;

  @override
  List<Object?> get props => [tab];
}
