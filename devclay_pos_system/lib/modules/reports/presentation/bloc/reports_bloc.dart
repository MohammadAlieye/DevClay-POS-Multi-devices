import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/report_detail_payload.dart';
import '../../domain/entities/report_entities.dart';
import '../../domain/repositories/reports_repository.dart';
import '../../domain/services/report_period_utils.dart';

part 'reports_event.dart';
part 'reports_state.dart';

class ReportsBloc extends Bloc<ReportsEvent, ReportsState> {
  ReportsBloc(this._repository) : super(const ReportsInitial()) {
    on<ReportsCenterStarted>(_onCenterStarted);
    on<ReportDetailStarted>(_onDetailStarted);
    on<ReportFiltersChanged>(_onFiltersChanged);
    on<ReportsPeriodChanged>(_onLegacyPeriod);
    on<ReportsViewTabChanged>(_onTab);
    on<ReportsRefreshRequested>(_onRefresh);
    // Legacy
    on<ReportsStarted>(_onLegacyStarted);
  }

  final ReportsRepository _repository;

  Future<void> _onCenterStarted(
    ReportsCenterStarted event,
    Emitter<ReportsState> emit,
  ) async {
    try {
      final options = await _repository.getFilterOptions();
      emit(ReportsCenterReady(filterOptions: options));
    } catch (error) {
      emit(ReportsError(userFacingError(error)));
    }
  }

  Future<void> _onDetailStarted(
    ReportDetailStarted event,
    Emitter<ReportsState> emit,
  ) async {
    emit(ReportDetailLoading(reportId: event.reportId, filters: event.filters));
    await _loadDetail(emit, event.reportId, event.filters);
  }

  Future<void> _onFiltersChanged(
    ReportFiltersChanged event,
    Emitter<ReportsState> emit,
  ) async {
    final current = state;
    if (current is! ReportDetailLoaded && current is! ReportDetailLoading) {
      return;
    }
    final reportId = current is ReportDetailLoaded
        ? current.reportId
        : (current as ReportDetailLoading).reportId;
    emit(ReportDetailLoading(reportId: reportId, filters: event.filters));
    await _loadDetail(emit, reportId, event.filters);
  }

  Future<void> _onRefresh(
    ReportsRefreshRequested event,
    Emitter<ReportsState> emit,
  ) async {
    final current = state;
    if (current is ReportDetailLoaded) {
      emit(
        ReportDetailLoading(
          reportId: current.reportId,
          filters: current.filters,
        ),
      );
      await _loadDetail(emit, current.reportId, current.filters);
    } else if (current is ReportsLoaded) {
      emit(const ReportsLoading());
      await _loadLegacy(emit, period: current.period, tab: current.viewTab);
    }
  }

  Future<void> _loadDetail(
    Emitter<ReportsState> emit,
    ReportId reportId,
    ReportFilters filters,
  ) async {
    try {
      final options = await _repository.getFilterOptions();
      final payload = await _repository.getReportDetail(reportId, filters);
      final range = ReportPeriodUtils.resolve(filters);
      emit(
        ReportDetailLoaded(
          reportId: reportId,
          filters: filters,
          dateRange: range,
          payload: payload,
          filterOptions: options,
        ),
      );
    } catch (error) {
      emit(ReportsError(userFacingError(error)));
    }
  }

  // --- Legacy tab support (mapped to report detail internally) ---

  Future<void> _onLegacyStarted(
    ReportsStarted event,
    Emitter<ReportsState> emit,
  ) async {
    emit(const ReportsLoading());
    await _loadLegacy(emit);
  }

  Future<void> _onLegacyPeriod(
    ReportsPeriodChanged event,
    Emitter<ReportsState> emit,
  ) async {
    emit(const ReportsLoading());
    await _loadLegacy(emit, period: event.period);
  }

  void _onTab(ReportsViewTabChanged event, Emitter<ReportsState> emit) {
    final current = state;
    if (current is ReportsLoaded) {
      emit(current.copyWith(viewTab: event.tab));
    }
  }

  Future<void> _loadLegacy(
    Emitter<ReportsState> emit, {
    ReportsPeriod period = ReportsPeriod.month,
    ReportsViewTab tab = ReportsViewTab.sales,
  }) async {
    try {
      final current = state;
      final activeTab = current is ReportsLoaded ? current.viewTab : tab;
      final data = await _repository.getReports(period: period);
      emit(ReportsLoaded(data: data, period: period, viewTab: activeTab));
    } catch (error) {
      emit(ReportsError(userFacingError(error)));
    }
  }
}
