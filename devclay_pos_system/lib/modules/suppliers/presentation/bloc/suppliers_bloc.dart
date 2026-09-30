import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/khata_balance.dart';
import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/supplier_entities.dart';
import '../../domain/repositories/suppliers_repository.dart';

part 'suppliers_event.dart';
part 'suppliers_state.dart';

class SuppliersBloc extends Bloc<SuppliersEvent, SuppliersState> {
  SuppliersBloc(this._repository) : super(const SuppliersInitial()) {
    on<SuppliersStarted>(_onStarted);
    on<SuppliersSearchChanged>(_onSearch);
    on<SuppliersTabChanged>(_onTab);
    on<SuppliersSortChanged>(_onSort);
    on<SupplierSaved>(_onSaved);
    on<SupplierDeleted>(_onDeleted);
    on<SupplierPurchasesRequested>(_onPurchasesRequested);
    on<SupplierPurchasePaymentRecorded>(_onPayment);
    on<SuppliersRefreshRequested>(_onRefresh);
    on<SuppliersMessageDismissed>(_onDismiss);
  }

  final SuppliersRepository _repository;

  Future<void> _onStarted(
    SuppliersStarted event,
    Emitter<SuppliersState> emit,
  ) async {
    emit(const SuppliersLoading());
    await _load(emit);
  }

  Future<void> _onSearch(
    SuppliersSearchChanged event,
    Emitter<SuppliersState> emit,
  ) async {
    final current = state;
    if (current is SuppliersLoaded) {
      emit(current.copyWith(query: event.query));
    }
  }

  Future<void> _onTab(
    SuppliersTabChanged event,
    Emitter<SuppliersState> emit,
  ) async {
    final current = state;
    if (current is SuppliersLoaded) {
      emit(current.copyWith(tab: event.tab, clearSelected: true));
    }
  }

  Future<void> _onSort(
    SuppliersSortChanged event,
    Emitter<SuppliersState> emit,
  ) async {
    final current = state;
    if (current is SuppliersLoaded) {
      emit(current.copyWith(sort: event.sort));
    }
  }

  Future<void> _onSaved(
    SupplierSaved event,
    Emitter<SuppliersState> emit,
  ) async {
    try {
      await _repository.saveSupplier(event.draft, id: event.id);
      await _load(
        emit,
        message: event.id == null ? 'Supplier added' : 'Supplier updated',
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onDeleted(
    SupplierDeleted event,
    Emitter<SuppliersState> emit,
  ) async {
    try {
      await _repository.deleteSupplier(event.supplierId);
      await _load(emit, message: 'Supplier deleted');
    } on SupplierHasPurchasesException catch (e) {
      _emitActionError(emit, e);
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  void _emitActionError(Emitter<SuppliersState> emit, Object error) {
    final current = state;
    final message = error is SupplierHasPurchasesException
        ? error.toString()
        : userFacingError(error);
    if (current is SuppliersLoaded) {
      emit(current.copyWith(message: message));
    } else {
      emit(SuppliersError(message));
    }
  }

  Future<void> _onPurchasesRequested(
    SupplierPurchasesRequested event,
    Emitter<SuppliersState> emit,
  ) async {
    final current = state;
    if (current is! SuppliersLoaded) return;

    try {
      final supplier = current.suppliers.firstWhere(
        (item) => item.id == event.supplierId,
      );
      final purchases = await _repository.getSupplierPurchases(
        event.supplierId,
      );
      emit(
        current.copyWith(
          selectedSupplierId: supplier.id,
          selectedSupplierName: supplier.name,
          selectedPurchases: purchases,
        ),
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onPayment(
    SupplierPurchasePaymentRecorded event,
    Emitter<SuppliersState> emit,
  ) async {
    final current = state;
    if (current is! SuppliersLoaded) return;

    try {
      await _repository.recordPurchasePayment(
        purchaseId: event.purchaseId,
        amount: event.amount,
      );
      await _load(emit, message: 'Payment recorded');
      if (current.selectedSupplierId != null) {
        add(SupplierPurchasesRequested(current.selectedSupplierId!));
      }
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onRefresh(
    SuppliersRefreshRequested event,
    Emitter<SuppliersState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onDismiss(
    SuppliersMessageDismissed event,
    Emitter<SuppliersState> emit,
  ) async {
    final current = state;
    if (current is SuppliersLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  Future<void> _load(Emitter<SuppliersState> emit, {String? message}) async {
    try {
      final current = state;
      final query = current is SuppliersLoaded ? current.query : '';
      final tab = current is SuppliersLoaded ? current.tab : SuppliersTab.all;
      final sort = current is SuppliersLoaded
          ? current.sort
          : SuppliersSort.nameAZ;
      final selectedId = current is SuppliersLoaded
          ? current.selectedSupplierId
          : null;
      final selectedName = current is SuppliersLoaded
          ? current.selectedSupplierName
          : null;

      final suppliers = await _repository.getSuppliers();
      List<SupplierPurchaseSummary> purchases = const [];
      if (selectedId != null) {
        purchases = await _repository.getSupplierPurchases(selectedId);
      }

      emit(
        SuppliersLoaded(
          suppliers: suppliers,
          query: query,
          tab: tab,
          sort: sort,
          message: message,
          selectedSupplierId: selectedId,
          selectedSupplierName: selectedName,
          selectedPurchases: purchases,
        ),
      );
    } catch (error) {
      emit(SuppliersError(userFacingError(error)));
    }
  }
}

