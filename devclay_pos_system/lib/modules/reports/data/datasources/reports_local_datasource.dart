import '../../domain/entities/report_detail_payload.dart';
import '../../domain/entities/report_entities.dart';
import 'reports_query_engine.dart';

class ReportsLocalDataSource {
  ReportsLocalDataSource(this._engine);

  final ReportsQueryEngine _engine;

  Future<ReportsData> getReports({required ReportsPeriod period}) {
    return _engine.getLegacyReports(period: period);
  }

  Future<ReportDetailPayload> getReportDetail(
    ReportId reportId,
    ReportFilters filters,
  ) {
    return _engine.getReportDetail(reportId, filters);
  }

  Future<ReportFilterOptions> getFilterOptions() {
    return _engine.getFilterOptions();
  }
}
