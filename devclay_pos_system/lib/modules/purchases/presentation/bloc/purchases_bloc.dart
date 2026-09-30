import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/khata_balance.dart';
import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/purchase_entities.dart';
import '../../domain/repositories/purchases_repository.dart';

part 'purchases_event.dart';
part 'purchases_state.dart';

class PurchasesBloc extends Bloc<PurchasesEvent, PurchasesState> {
  PurchasesBloc(this._repository) : super(const PurchasesInitial()) {
    on<PurchasesStarted>(_onStarted);
    on<PurchasesSearchChanged>(_onSearch);
    on<PurchasesTabChanged>(_onTab);
    on<PurchasesSupplierFilterChanged>(_onSupplierFilter);
    on<PurchaseCreated>(_onPurchaseCreated);
    on<PurchasePaymentRecorded>(_onPayment);
    on<SupplierPaymentRecorded>(_onSupplierPayment);
    on<SupplierSaved>(_onSupplierSaved);
    on<SupplierBalanceAdjusted>(_onSupplierBalanceAdjusted);
    on<PurchasesRefreshRequested>(_onRefresh);
    on<PurchasesMessageDismissed>(_onDismiss);
  }

  final PurchasesRepository _repository;

  Future<void> _onStarted(
    PurchasesStarted event,
    Emitter<PurchasesState> emit,
  ) async {
    emit(const PurchasesLoading());
    await _load(emit);
  }

  Future<void> _onSearch(
    PurchasesSearchChanged event,
    Emitter<PurchasesState> emit,
  ) async {
    final current = state;
    if (current is PurchasesLoaded) {
      emit(current.copyWith(query: event.query));
    }
  }

  Future<void> _onTab(
    PurchasesTabChanged event,
    Emitter<PurchasesState> emit,
  ) async {
    final current = state;
    if (current is PurchasesLoaded) {
      emit(current.copyWith(tab: event.tab));
    }
  }

  Future<void> _onSupplierFilter(
    PurchasesSupplierFilterChanged event,
    Emitter<PurchasesState> emit,
  ) async {
    final current = state;
    if (current is PurchasesLoaded) {
      emit(current.copyWith(supplierFilter: event.filter));
    }
  }

  Future<void> _onPurchaseCreated(
    PurchaseCreated event,
    Emitter<PurchasesState> emit,
  ) async {
    try {
      await _repository.createPurchase(event.draft);
      await _load(emit, message: 'Purchase saved and stock updated');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onPayment(
    PurchasePaymentRecorded event,
    Emitter<PurchasesState> emit,
  ) async {
    try {
      await _repository.recordPayment(
        purchaseId: event.purchaseId,
        amount: event.amount,
      );
      await _load(emit, message: 'Payment recorded');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onSupplierPayment(
    SupplierPaymentRecorded event,
    Emitter<PurchasesState> emit,
  ) async {
    try {
      await _repository.recordSupplierPayment(
        supplierId: event.supplierId,
        amount: event.amount,
      );
      await _load(emit, message: 'Supplier payment recorded');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onSupplierSaved(
    SupplierSaved event,
    Emitter<PurchasesState> emit,
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

  Future<void> _onSupplierBalanceAdjusted(
    SupplierBalanceAdjusted event,
    Emitter<PurchasesState> emit,
  ) async {
    try {
      await _repository.adjustSupplierBalance(
        supplierId: event.supplierId,
        amountChange: event.amountChange,
        note: event.note,
      );
      await _load(emit, message: 'Supplier balance updated');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  void _emitActionError(Emitter<PurchasesState> emit, Object error) {
    final current = state;
    final message = userFacingError(error);
    if (current is PurchasesLoaded) {
      emit(current.copyWith(message: message));
    } else {
      emit(PurchasesError(message));
    }
  }

  Future<void> _onRefresh(
    PurchasesRefreshRequested event,
    Emitter<PurchasesState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onDismiss(
    PurchasesMessageDismissed event,
    Emitter<PurchasesState> emit,
  ) async {
    final current = state;
    if (current is PurchasesLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  Future<void> _load(Emitter<PurchasesState> emit, {String? message}) async {
    try {
      final current = state;
      final query = current is PurchasesLoaded ? current.query : '';
      final tab = current is PurchasesLoaded
          ? current.tab
          : PurchasesTab.purchases;

      final purchases = await _repository.getPurchases();
      final suppliers = await _repository.getSuppliers();
      final products = await _repository.getProductOptions();

      emit(
        PurchasesLoaded(
          purchases: purchases,
          suppliers: suppliers,
          products: products,
          query: query,
          tab: tab,
          message: message,
        ),
      );
    } catch (error) {
      emit(PurchasesError(userFacingError(error)));
    }
  }
}
