import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/finance_entities.dart';
import '../../domain/repositories/finance_repository.dart';

part 'finance_event.dart';
part 'finance_state.dart';

class FinanceBloc extends Bloc<FinanceEvent, FinanceState> {
  FinanceBloc(this._repository) : super(const FinanceInitial()) {
    on<FinanceStarted>(_onStarted);
    on<FinancePeriodChanged>(_onPeriod);
    on<FinanceViewTabChanged>(_onTab);
    on<FinanceMovementAdded>(_onMovement);
    on<FinanceEmployeeSaved>(_onEmployeeSaved);
    on<FinanceEmployeeActiveChanged>(_onEmployeeActive);
    on<FinanceEmployeeDeleted>(_onEmployeeDeleted);
    on<FinanceSalaryPaid>(_onSalary);
    on<FinancePayableSettled>(_onPayable);
    on<FinanceReceivableSettled>(_onReceivable);
    on<FinanceExpenseAdded>(_onExpense);
    on<FinanceAdvanceAdded>(_onAdvance);
    on<FinanceCommissionAdded>(_onCommission);
    on<FinanceAttendanceClockedIn>(_onClockIn);
    on<FinanceAttendanceClockedOut>(_onClockOut);
    on<FinanceRefreshRequested>(_onRefresh);
    on<FinanceMessageDismissed>(_onDismiss);
  }

  final FinanceRepository _repository;

  Future<void> _onStarted(
    FinanceStarted event,
    Emitter<FinanceState> emit,
  ) async {
    emit(const FinanceLoading());
    await _load(emit);
  }

  Future<void> _onPeriod(
    FinancePeriodChanged event,
    Emitter<FinanceState> emit,
  ) async {
    final current = state;
    if (current is! FinanceLoaded) return;
    emit(current.copyWith(period: event.period));
    await _load(emit, preserve: current.copyWith(period: event.period));
  }

  Future<void> _onTab(
    FinanceViewTabChanged event,
    Emitter<FinanceState> emit,
  ) async {
    final current = state;
    if (current is! FinanceLoaded) return;
    emit(current.copyWith(viewTab: event.tab));
  }

  Future<void> _onMovement(
    FinanceMovementAdded event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.addMovement(event.draft);
      await _load(emit, message: '${event.draft.kind.label} recorded');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onEmployeeSaved(
    FinanceEmployeeSaved event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.saveEmployee(event.draft, id: event.id);
      await _load(
        emit,
        message: event.id == null ? 'Employee added' : 'Employee updated',
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onEmployeeActive(
    FinanceEmployeeActiveChanged event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.setEmployeeActive(
        id: event.id,
        isActive: event.isActive,
      );
      await _load(
        emit,
        message: event.isActive ? 'Employee activated' : 'Employee deactivated',
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onEmployeeDeleted(
    FinanceEmployeeDeleted event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.deleteEmployee(event.id);
      await _load(emit, message: 'Employee moved to Recycle Bin');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onSalary(
    FinanceSalaryPaid event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.paySalary(event.draft);
      await _load(emit, message: 'Salary paid');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onPayable(
    FinancePayableSettled event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.settlePayable(
        purchaseId: event.purchaseId,
        accountId: event.accountId,
        amount: event.amount,
      );
      await _load(emit, message: 'Payable settled');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onReceivable(
    FinanceReceivableSettled event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.settleReceivable(
        customerId: event.customerId,
        accountId: event.accountId,
        amount: event.amount,
      );
      await _load(emit, message: 'Receivable collected');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onExpense(
    FinanceExpenseAdded event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.addExpense(event.draft);
      await _load(emit, message: 'Expense recorded');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onAdvance(
    FinanceAdvanceAdded event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.addAdvance(event.draft);
      await _load(emit, message: 'Advance recorded');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onCommission(
    FinanceCommissionAdded event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.addCommission(event.draft);
      await _load(emit, message: 'Commission paid');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onClockIn(
    FinanceAttendanceClockedIn event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.clockIn(event.draft);
      await _load(emit, message: 'Checked in');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onClockOut(
    FinanceAttendanceClockedOut event,
    Emitter<FinanceState> emit,
  ) async {
    try {
      await _repository.clockOut(event.draft);
      await _load(emit, message: 'Checked out');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onRefresh(
    FinanceRefreshRequested event,
    Emitter<FinanceState> emit,
  ) async {
    await _load(emit);
  }

  void _onDismiss(FinanceMessageDismissed event, Emitter<FinanceState> emit) {
    final current = state;
    if (current is FinanceLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  void _emitActionError(Emitter<FinanceState> emit, Object error) {
    final current = state;
    final message = userFacingError(error);
    if (current is FinanceLoaded) {
      emit(current.copyWith(message: message));
    } else {
      emit(FinanceError(message));
    }
  }

  Future<void> _load(
    Emitter<FinanceState> emit, {
    String? message,
    FinanceLoaded? preserve,
  }) async {
    try {
      final current = state;
      final ui = preserve ?? (current is FinanceLoaded ? current : null);
      final period = ui?.period ?? FinancePeriod.month;
      final viewTab = ui?.viewTab ?? FinanceViewTab.overview;
      final data = await _repository.load(period: period);
      emit(
        FinanceLoaded(
          data: data,
          period: period,
          viewTab: viewTab,
          message: message,
        ),
      );
    } catch (error) {
      emit(FinanceError(userFacingError(error)));
    }
  }
}
