import '../domain/entities/finance_entities.dart';
import '../domain/repositories/finance_repository.dart';
import 'datasources/finance_local_datasource.dart';

class FinanceRepositoryImpl implements FinanceRepository {
  FinanceRepositoryImpl(this._local);

  final FinanceLocalDataSource _local;

  @override
  Future<FinanceData> load({required FinancePeriod period}) =>
      _local.load(period: period);

  @override
  Future<void> addMovement(FinanceMovementDraft draft) =>
      _local.addMovement(draft);

  @override
  Future<EmployeeItem> saveEmployee(EmployeeDraft draft, {int? id}) =>
      _local.saveEmployee(draft, id: id);

  @override
  Future<void> setEmployeeActive({required int id, required bool isActive}) =>
      _local.setEmployeeActive(id: id, isActive: isActive);

  @override
  Future<void> deleteEmployee(int id) => _local.deleteEmployee(id);

  @override
  Future<void> paySalary(SalaryPayDraft draft) => _local.paySalary(draft);

  @override
  Future<void> settlePayable({
    required int purchaseId,
    required int accountId,
    required double amount,
  }) {
    return _local.settlePayable(
      purchaseId: purchaseId,
      accountId: accountId,
      amount: amount,
    );
  }

  @override
  Future<void> settleReceivable({
    required int customerId,
    required int accountId,
    required double amount,
  }) {
    return _local.settleReceivable(
      customerId: customerId,
      accountId: accountId,
      amount: amount,
    );
  }

  @override
  Future<void> addExpense(ExpenseDraft draft) => _local.addExpense(draft);

  @override
  Future<void> addAdvance(EmployeeAdvanceDraft draft) =>
      _local.addAdvance(draft);

  @override
  Future<void> addCommission(EmployeeCommissionDraft draft) =>
      _local.addCommission(draft);

  @override
  Future<void> clockIn(AttendanceClockInDraft draft) => _local.clockIn(draft);

  @override
  Future<void> clockOut(AttendanceClockOutDraft draft) => _local.clockOut(draft);
}
