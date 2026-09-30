import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/sale_entities.dart';
import '../../domain/repositories/sales_repository.dart';

part 'sales_event.dart';
part 'sales_state.dart';

class SalesBloc extends Bloc<SalesEvent, SalesState> {
  SalesBloc(this._repository) : super(const SalesInitial()) {
    on<SalesStarted>(_onStarted);
    on<SalesSearchChanged>(_onSearch);
    on<SalesPeriodChanged>(_onPeriod);
    on<SalesViewTabChanged>(_onViewTab);
    on<SalesRefreshRequested>(_onRefresh);
  }

  final SalesRepository _repository;

  Future<void> _onStarted(SalesStarted event, Emitter<SalesState> emit) async {
    emit(const SalesLoading());
    await _load(emit);
  }

  Future<void> _onSearch(
    SalesSearchChanged event,
    Emitter<SalesState> emit,
  ) async {
    final current = state;
    if (current is SalesLoaded) {
      emit(current.copyWith(query: event.query));
    }
  }

  Future<void> _onPeriod(
    SalesPeriodChanged event,
    Emitter<SalesState> emit,
  ) async {
    final current = state;
    if (current is SalesLoaded) {
      emit(current.copyWith(period: event.period));
    }
  }

  Future<void> _onViewTab(
    SalesViewTabChanged event,
    Emitter<SalesState> emit,
  ) async {
    final current = state;
    if (current is SalesLoaded) {
      emit(current.copyWith(viewTab: event.viewTab));
    }
  }

  Future<void> _onRefresh(
    SalesRefreshRequested event,
    Emitter<SalesState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _load(Emitter<SalesState> emit) async {
    try {
      final current = state;
      final query = current is SalesLoaded ? current.query : '';
      final period = current is SalesLoaded ? current.period : SalesPeriod.all;
      final viewTab = current is SalesLoaded
          ? current.viewTab
          : SalesViewTab.receipts;
      final sales = await _repository.getSales();
      final returns = await _repository.getReturns();
      emit(
        SalesLoaded(
          sales: sales,
          returns: returns,
          query: query,
          period: period,
          viewTab: viewTab,
        ),
      );
    } catch (error) {
      emit(SalesError(userFacingError(error)));
    }
  }
}
