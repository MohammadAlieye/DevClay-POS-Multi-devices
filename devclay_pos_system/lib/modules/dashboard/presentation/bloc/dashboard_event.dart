part of 'dashboard_bloc.dart';

sealed class DashboardEvent extends Equatable {
  const DashboardEvent();

  @override
  List<Object?> get props => [];
}

final class DashboardStarted extends DashboardEvent {
  const DashboardStarted();
}

final class DashboardRefreshed extends DashboardEvent {
  const DashboardRefreshed();
}
