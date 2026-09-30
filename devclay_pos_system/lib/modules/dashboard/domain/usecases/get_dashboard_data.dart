import '../entities/dashboard_data.dart';
import '../repositories/dashboard_repository.dart';

class GetDashboardData {
  const GetDashboardData(this._repository);

  final DashboardRepository _repository;

  Future<DashboardData> call() => _repository.getDashboardData();
}
