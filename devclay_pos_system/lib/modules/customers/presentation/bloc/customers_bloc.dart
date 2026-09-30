import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/customer_entities.dart';
import '../../domain/repositories/customers_repository.dart';

part 'customers_event.dart';
part 'customers_state.dart';

class CustomersBloc extends Bloc<CustomersEvent, CustomersState> {
  CustomersBloc(this._repository) : super(const CustomersInitial()) {
    on<CustomersStarted>(_onStarted);
    on<CustomersSearchChanged>(_onSearch);
    on<CustomersTabChanged>(_onTab);
    on<CustomerSaved>(_onSaved);
    on<CustomerPaymentRecorded>(_onPayment);
    on<CustomerBalanceAdjusted>(_onAdjustBalance);
    on<CustomersRefreshRequested>(_onRefresh);
    on<CustomersMessageDismissed>(_onDismiss);
    on<CustomerSalesRequested>(_onCustomerSales);
  }

  final CustomersRepository _repository;

  Future<void> _onStarted(
    CustomersStarted event,
    Emitter<CustomersState> emit,
  ) async {
    emit(const CustomersLoading());
    await _load(emit);
  }

  Future<void> _onSearch(
    CustomersSearchChanged event,
    Emitter<CustomersState> emit,
  ) async {
    final current = state;
    if (current is CustomersLoaded) {
      emit(current.copyWith(query: event.query));
    }
  }

  Future<void> _onTab(
    CustomersTabChanged event,
    Emitter<CustomersState> emit,
  ) async {
    final current = state;
    if (current is CustomersLoaded) {
      emit(current.copyWith(tab: event.tab, clearSelectedSales: true));
    }
  }

  Future<void> _onSaved(
    CustomerSaved event,
    Emitter<CustomersState> emit,
  ) async {
    try {
      await _repository.saveCustomer(event.draft, id: event.id);
      await _load(
        emit,
        message: event.id == null ? 'Customer added' : 'Customer updated',
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onPayment(
    CustomerPaymentRecorded event,
    Emitter<CustomersState> emit,
  ) async {
    try {
      await _repository.recordPayment(
        customerId: event.customerId,
        amount: event.amount,
        note: event.note,
      );
      await _load(emit, message: 'Payment recorded');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onAdjustBalance(
    CustomerBalanceAdjusted event,
    Emitter<CustomersState> emit,
  ) async {
    try {
      await _repository.adjustBalance(
        customerId: event.customerId,
        amountChange: event.amountChange,
        note: event.note,
      );
      await _load(emit, message: 'Balance updated');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onRefresh(
    CustomersRefreshRequested event,
    Emitter<CustomersState> emit,
  ) async {
    await _load(emit);
  }

  Future<void> _onDismiss(
    CustomersMessageDismissed event,
    Emitter<CustomersState> emit,
  ) async {
    final current = state;
    if (current is CustomersLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  Future<void> _onCustomerSales(
    CustomerSalesRequested event,
    Emitter<CustomersState> emit,
  ) async {
    final current = state;
    if (current is! CustomersLoaded) return;
    try {
      final sales = await _repository.getCustomerSales(event.customerName);
      final khata = await _repository.getKhataLedger(event.customerId);
      emit(
        current.copyWith(
          selectedCustomerSales: sales,
          selectedKhataEntries: khata,
          selectedCustomerName: event.customerName,
        ),
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  void _emitActionError(Emitter<CustomersState> emit, Object error) {
    final current = state;
    final message = userFacingError(error);
    if (current is CustomersLoaded) {
      emit(current.copyWith(message: message));
    } else {
      emit(CustomersError(message));
    }
  }

  Future<void> _load(Emitter<CustomersState> emit, {String? message}) async {
    try {
      final current = state;
      final query = current is CustomersLoaded ? current.query : '';
      final tab = current is CustomersLoaded ? current.tab : CustomersTab.all;
      final customers = await _repository.getCustomers();
      emit(
        CustomersLoaded(
          customers: customers,
          query: query,
          tab: tab,
          message: message,
        ),
      );
    } catch (error) {
      emit(CustomersError(userFacingError(error)));
    }
  }
}
