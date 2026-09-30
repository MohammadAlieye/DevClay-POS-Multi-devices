import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/inventory_entities.dart';
import '../../domain/repositories/inventory_repository.dart';

part 'inventory_event.dart';
part 'inventory_state.dart';

class InventoryBloc extends Bloc<InventoryEvent, InventoryState> {
  InventoryBloc(this._repository) : super(const InventoryInitial()) {
    on<InventoryStarted>(_onStarted);
    on<InventorySearchChanged>(_onSearch);
    on<InventoryTabChanged>(_onTab);
    on<InventoryFilterChanged>(_onFilter);
    on<InventorySortChanged>(_onSort);
    on<InventoryAdjustRequested>(_onAdjust);
    on<InventoryRefreshRequested>(_onRefresh);
    on<InventoryMessageDismissed>(_onDismiss);
  }

  final InventoryRepository _repository;

  Future<void> _onStarted(
    InventoryStarted event,
    Emitter<InventoryState> emit,
  ) async {
    emit(const InventoryLoading());
    await _load(emit);
  }

  Future<void> _onSearch(
    InventorySearchChanged event,
    Emitter<InventoryState> emit,
  ) async {
    final current = state;
    if (current is InventoryLoaded) {
      emit(current.copyWith(query: event.query));
    }
  }

  Future<void> _onTab(
    InventoryTabChanged event,
    Emitter<InventoryState> emit,
  ) async {
    final current = state;
    if (current is InventoryLoaded) {
      emit(current.copyWith(tab: event.tab));
    }
  }

  Future<void> _onFilter(
    InventoryFilterChanged event,
    Emitter<InventoryState> emit,
  ) async {
    final current = state;
    if (current is InventoryLoaded) {
      emit(current.copyWith(filter: event.filter, clearMessage: true));
    }
  }

  Future<void> _onSort(
    InventorySortChanged event,
    Emitter<InventoryState> emit,
  ) async {
    final current = state;
    if (current is InventoryLoaded) {
      emit(current.copyWith(sort: event.sort, clearMessage: true));
    }
  }

  Future<void> _onAdjust(
    InventoryAdjustRequested event,
    Emitter<InventoryState> emit,
  ) async {
    try {
      await _repository.adjustStock(event.request);
      await _load(emit, message: 'Stock updated');
    } catch (error) {
      final current = state;
      final message = userFacingError(error);
      if (current is InventoryLoaded) {
        emit(current.copyWith(message: message));
      } else {
        emit(InventoryError(message));
      }
    }
  }

  Future<void> _onRefresh(
    InventoryRefreshRequested event,
    Emitter<InventoryState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onDismiss(
    InventoryMessageDismissed event,
    Emitter<InventoryState> emit,
  ) async {
    final current = state;
    if (current is InventoryLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  Future<void> _load(Emitter<InventoryState> emit, {String? message}) async {
    try {
      final current = state;
      final query = current is InventoryLoaded ? current.query : '';
      final tab = current is InventoryLoaded ? current.tab : InventoryTab.stock;
      final filter = current is InventoryLoaded
          ? current.filter
          : InventoryListFilter.all;
      final sort = current is InventoryLoaded
          ? current.sort
          : InventoryListSort.nameAsc;
      final products = await _repository.getProducts();
      final movements = await _repository.getMovements();
      emit(
        InventoryLoaded(
          products: products,
          movements: movements,
          query: query,
          tab: tab,
          filter: filter,
          sort: sort,
          message: message,
        ),
      );
    } catch (error) {
      emit(InventoryError(userFacingError(error)));
    }
  }
}
