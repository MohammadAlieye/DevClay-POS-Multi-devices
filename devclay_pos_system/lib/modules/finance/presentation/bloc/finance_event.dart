part of 'finance_bloc.dart';

sealed class FinanceEvent extends Equatable {
  const FinanceEvent();

  @override
  List<Object?> get props => [];
}

class FinanceStarted extends FinanceEvent {
  const FinanceStarted();
}

class FinancePeriodChanged extends FinanceEvent {
  const FinancePeriodChanged(this.period);

  final FinancePeriod period;

  @override
  List<Object?> get props => [period];
}

class FinanceViewTabChanged extends FinanceEvent {
  const FinanceViewTabChanged(this.tab);

  final FinanceViewTab tab;

  @override
  List<Object?> get props => [tab];
}

class FinanceMovementAdded extends FinanceEvent {
  const FinanceMovementAdded(this.draft);

  final FinanceMovementDraft draft;

  @override
  List<Object?> get props => [draft];
}

class FinanceEmployeeSaved extends FinanceEvent {
  const FinanceEmployeeSaved({required this.draft, this.id});

  final EmployeeDraft draft;
  final int? id;

  @override
  List<Object?> get props => [draft, id];
}

class FinanceEmployeeActiveChanged extends FinanceEvent {
  const FinanceEmployeeActiveChanged({
    required this.id,
    required this.isActive,
  });

  final int id;
  final bool isActive;

  @override
  List<Object?> get props => [id, isActive];
}

class FinanceEmployeeDeleted extends FinanceEvent {
  const FinanceEmployeeDeleted(this.id);

  final int id;

  @override
  List<Object?> get props => [id];
}

class FinanceSalaryPaid extends FinanceEvent {
  const FinanceSalaryPaid(this.draft);

  final SalaryPayDraft draft;

  @override
  List<Object?> get props => [draft];
}

class FinancePayableSettled extends FinanceEvent {
  const FinancePayableSettled({
    required this.purchaseId,
    required this.accountId,
    required this.amount,
  });

  final int purchaseId;
  final int accountId;
  final double amount;

  @override
  List<Object?> get props => [purchaseId, accountId, amount];
}

class FinanceReceivableSettled extends FinanceEvent {
  const FinanceReceivableSettled({
    required this.customerId,
    required this.accountId,
    required this.amount,
  });

  final int customerId;
  final int accountId;
  final double amount;

  @override
  List<Object?> get props => [customerId, accountId, amount];
}

class FinanceRefreshRequested extends FinanceEvent {
  const FinanceRefreshRequested();
}

class FinanceMessageDismissed extends FinanceEvent {
  const FinanceMessageDismissed();
}

class FinanceExpenseAdded extends FinanceEvent {
  const FinanceExpenseAdded(this.draft);

  final ExpenseDraft draft;

  @override
  List<Object?> get props => [draft];
}

class FinanceAdvanceAdded extends FinanceEvent {
  const FinanceAdvanceAdded(this.draft);

  final EmployeeAdvanceDraft draft;

  @override
  List<Object?> get props => [draft];
}

class FinanceCommissionAdded extends FinanceEvent {
  const FinanceCommissionAdded(this.draft);

  final EmployeeCommissionDraft draft;

  @override
  List<Object?> get props => [draft];
}

class FinanceAttendanceClockedIn extends FinanceEvent {
  const FinanceAttendanceClockedIn(this.draft);

  final AttendanceClockInDraft draft;

  @override
  List<Object?> get props => [draft];
}

class FinanceAttendanceClockedOut extends FinanceEvent {
  const FinanceAttendanceClockedOut(this.draft);

  final AttendanceClockOutDraft draft;

  @override
  List<Object?> get props => [draft];
}
