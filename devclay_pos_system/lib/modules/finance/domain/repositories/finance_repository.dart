import '../entities/finance_entities.dart';

abstract class FinanceRepository {
  Future<FinanceData> load({required FinancePeriod period});

  Future<void> addMovement(FinanceMovementDraft draft);

  Future<EmployeeItem> saveEmployee(EmployeeDraft draft, {int? id});

  Future<void> setEmployeeActive({required int id, required bool isActive});

  Future<void> deleteEmployee(int id);

  Future<void> paySalary(SalaryPayDraft draft);

  Future<void> settlePayable({
    required int purchaseId,
    required int accountId,
    required double amount,
  });

  Future<void> settleReceivable({
    required int customerId,
    required int accountId,
    required double amount,
  });

  Future<void> addExpense(ExpenseDraft draft);

  Future<void> addAdvance(EmployeeAdvanceDraft draft);

  Future<void> addCommission(EmployeeCommissionDraft draft);

  Future<void> clockIn(AttendanceClockInDraft draft);

  Future<void> clockOut(AttendanceClockOutDraft draft);
}
