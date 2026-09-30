import '../domain/entities/report_detail_payload.dart';
import '../domain/entities/report_entities.dart';
import '../domain/repositories/reports_repository.dart';
import 'datasources/reports_local_datasource.dart';

class ReportsRepositoryImpl implements ReportsRepository {
  ReportsRepositoryImpl(this._local);

  final ReportsLocalDataSource _local;

  @override
  Future<ReportsData> getReports({required ReportsPeriod period}) {
    return _local.getReports(period: period);
  }

  @override
  Future<ReportDetailPayload> getReportDetail(
    ReportId reportId,
    ReportFilters filters,
  ) {
    return _local.getReportDetail(reportId, filters);
  }

  @override
  Future<ReportFilterOptions> getFilterOptions() {
    return _local.getFilterOptions();
  }
}
