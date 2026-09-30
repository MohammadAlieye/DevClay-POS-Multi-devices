import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';

import '../../domain/entities/dashboard_data.dart';
import '../../domain/usecases/get_dashboard_data.dart';

part 'dashboard_event.dart';
part 'dashboard_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  DashboardBloc(this._getDashboardData) : super(const DashboardInitial()) {
    on<DashboardStarted>(_onStarted);
    on<DashboardRefreshed>(_onRefreshed);
  }

  final GetDashboardData _getDashboardData;

  Future<void> _onStarted(
    DashboardStarted event,
    Emitter<DashboardState> emit,
  ) async {
    emit(const DashboardLoading());
    await _load(emit);
  }

  Future<void> _onRefreshed(
    DashboardRefreshed event,
    Emitter<DashboardState> emit,
  ) async {
    final current = state;
    if (current is DashboardLoaded) {
      emit(DashboardRefreshing(current.data));
    } else {
      emit(const DashboardLoading());
    }
    await _load(emit);
  }

  Future<void> _load(Emitter<DashboardState> emit) async {
    try {
      // Brief delay so skeletons are visible on fast local loads.
      await Future<void>.delayed(const Duration(milliseconds: 350));
      final data = await _getDashboardData().timeout(
        const Duration(seconds: 10),
        onTimeout: () => throw StateError(
          'Dashboard load timed out. Try restarting the app.',
        ),
      );
      emit(DashboardLoaded(data));
    } catch (error) {
      emit(DashboardError(userFacingError(error)));
    }
  }
}
