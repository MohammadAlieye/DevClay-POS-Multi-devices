import '../entities/report_detail_payload.dart';
import '../entities/report_entities.dart';

abstract class ReportsRepository {
  Future<ReportsData> getReports({required ReportsPeriod period});

  Future<ReportDetailPayload> getReportDetail(
    ReportId reportId,
    ReportFilters filters,
  );

  Future<ReportFilterOptions> getFilterOptions();
}
