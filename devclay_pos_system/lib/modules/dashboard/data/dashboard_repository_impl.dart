import '../domain/entities/dashboard_data.dart';
import '../domain/repositories/dashboard_repository.dart';
import 'datasources/dashboard_local_datasource.dart';

class DashboardRepositoryImpl implements DashboardRepository {
  DashboardRepositoryImpl(this._local);

  final DashboardLocalDataSource _local;

  @override
  Future<DashboardData> getDashboardData() => _local.fetch();
}
