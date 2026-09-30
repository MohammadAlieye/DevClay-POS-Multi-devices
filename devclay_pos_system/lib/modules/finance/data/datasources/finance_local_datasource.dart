import 'package:isar_community/isar.dart';

import '../../../../database/collections/account.dart';
import '../../../../database/collections/customer.dart';
import '../../../../database/collections/customer_ledger_entry.dart';
import '../../../../database/collections/employee.dart';
import '../../../../database/collections/employee_attendance.dart';
import '../../../../database/collections/employee_advance.dart';
import '../../../../database/collections/employee_commission.dart';
import '../../../../database/collections/finance_expense.dart';
import '../../../../database/collections/ledger_entry.dart';
import '../../../../database/collections/purchase.dart';
import '../../../../database/isar_service.dart';
import '../../../../services/media/finance_attachment_store.dart';
import '../../domain/entities/finance_entities.dart';

class FinanceLocalDataSource {
  FinanceLocalDataSource(this._isarService, [FinanceAttachmentStore? attachments])
      : _attachments = attachments ?? FinanceAttachmentStore();

  final IsarService _isarService;
  final FinanceAttachmentStore _attachments;

  Future<FinanceData> load({required FinancePeriod period}) async {
    final isar = _isarService.instance;
    final accounts = await isar.accounts
        .filter()
        .isActiveEqualTo(true)
        .sortByName()
        .findAll();
    final employees = await isar.employees.where().sortByName().findAll();
    final entries = await isar.ledgerEntrys.where().sortByEntryDateDesc().findAll();
    final purchases = await isar.purchases.where().findAll();
    final customers = await isar.customers.where().findAll();
    final expenseRows = await isar.financeExpenses
        .filter()
        .deletedAtIsNull()
        .sortByEntryDateDesc()
        .findAll();
    final advanceRows =
        await isar.employeeAdvances.where().sortByEntryDateDesc().findAll();
    final commissionRows = await isar.employeeCommissions
        .where()
        .sortByEntryDateDesc()
        .findAll();
    final attendanceRows = await isar.employeeAttendances
        .where()
        .sortByClockInAtDesc()
        .findAll();

    final accountOptions = accounts
        .map(
          (a) => FinanceAccountOption(
            id: a.id,
            name: a.name,
            balance: a.balance,
            type: a.type,
          ),
        )
        .toList();

    final employeeItems = employees
        .where((e) => e.deletedAt == null)
        .map(_mapEmployee)
        .toList();

    final movements = entries
        .where((e) => _isFinanceKind(e.movementKind))
        .where((e) => _inPeriod(e.entryDate, period))
        .map(_mapMovement)
        .toList();

    final expenses = expenseRows
        .where((e) => _inPeriod(e.entryDate, period))
        .map(_mapExpense)
        .toList();

    final allSalaryHistory = entries
        .where((e) => e.movementKind == FinanceMovementKind.salary.storageKey)
        .map(_mapSalaryHistory)
        .toList();

    final salaryHistory = allSalaryHistory
        .where((e) => _inPeriod(e.entryDate, period))
        .toList();

    final advances = advanceRows
        .where((e) => _inPeriod(e.entryDate, period))
        .map(_mapAdvance)
        .toList();

    final commissions = commissionRows
        .where((e) => _inPeriod(e.entryDate, period))
        .map(_mapCommission)
        .toList();

    final activeEmployees =
        employeeItems.where((e) => e.isActive).toList();
    final activeEmployeeIds = {
      for (final employee in activeEmployees) employee.id,
    };

    final liveAttendance = attendanceRows
        .where((row) => activeEmployeeIds.contains(row.employeeId))
        .toList();

    final attendances = liveAttendance.map(_mapAttendance).toList();

    final payables = purchases
        .where((p) => p.dueAmount > 0)
        .map(
          (p) => PayableItem(
            purchaseId: p.id,
            supplierName: p.supplierName,
            invoiceNo: p.invoiceNo,
            dueAmount: p.dueAmount,
            total: p.total,
            purchaseDate: p.purchaseDate,
          ),
        )
        .toList()
      ..sort((a, b) => b.dueAmount.compareTo(a.dueAmount));

    final receivables = customers
        .where((c) => c.isActive && c.balance > 0)
        .map(
          (c) => ReceivableItem(
            customerId: c.id,
            customerName: c.name,
            phone: c.phone,
            balance: c.balance,
          ),
        )
        .toList()
      ..sort((a, b) => b.balance.compareTo(a.balance));

    double sumKind(FinanceMovementKind kind) => movements
        .where((m) => m.kind == kind)
        .fold(0.0, (sum, m) => sum + m.amount);

    final todayIds = liveAttendance
        .where((row) => _inPeriod(row.clockInAt, FinancePeriod.today))
        .map((row) => row.employeeId)
        .toSet();
    final currentlyInIds = liveAttendance
        .where((row) => row.clockOutAt == null)
        .map((row) => row.employeeId)
        .toSet();
    final presentToday = {...todayIds, ...currentlyInIds};
    final periodHours = liveAttendance
        .where((row) => _inPeriod(row.clockInAt, period))
        .map(_mapAttendance)
        .fold<Duration>(
          Duration.zero,
          (sum, item) => sum + item.duration,
        );

    return FinanceData(
      overview: FinanceOverview(
        totalBalance:
            accounts.fold(0.0, (sum, a) => sum + a.balance),
        cashIn: sumKind(FinanceMovementKind.cashIn),
        cashOut: sumKind(FinanceMovementKind.cashOut),
        withdrawals: sumKind(FinanceMovementKind.ownerWithdrawal),
        salariesPaid: sumKind(FinanceMovementKind.salary),
        expensesTotal:
            expenses.fold(0.0, (sum, e) => sum + e.amount),
        advancesTotal:
            advances.fold(0.0, (sum, a) => sum + a.amount),
        commissionsTotal:
            commissions.fold(0.0, (sum, c) => sum + c.amount),
        payablesDue:
            payables.fold(0.0, (sum, p) => sum + p.dueAmount),
        receivablesDue:
            receivables.fold(0.0, (sum, r) => sum + r.balance),
        activeEmployees: activeEmployees.length,
        monthlyPayroll: activeEmployees.fold(
          0.0,
          (sum, e) => sum + e.monthlySalary,
        ),
        presentToday: presentToday.length,
        currentlyIn: currentlyInIds.length,
        attendanceHours: periodHours,
      ),
      accounts: accountOptions,
      movements: movements,
      expenses: expenses,
      salaryHistory: salaryHistory,
      allSalaryHistory: allSalaryHistory,
      advances: advances,
      commissions: commissions,
      employees: employeeItems,
      attendances: attendances,
      payables: payables,
      receivables: receivables,
    );
  }

  Future<void> addExpense(ExpenseDraft draft) async {
    if (draft.amount <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }
    final category = draft.category.trim();
    if (category.isEmpty) {
      throw ArgumentError('Expense category is required.');
    }

    final isar = _isarService.instance;
    final account = await isar.accounts.get(draft.accountId);
    if (account == null) throw StateError('Account not found.');

    String? receiptPath;
    if (draft.receiptSourcePath != null &&
        draft.receiptSourcePath!.trim().isNotEmpty) {
      receiptPath = await _attachments.saveFromPath(draft.receiptSourcePath!);
    }

    final now = DateTime.now();
    final nextBalance =
        (account.balance - draft.amount).clamp(-999999999.0, 999999999.0);

    await isar.writeTxn(() async {
      account.balance = nextBalance.toDouble();
      await isar.accounts.put(account);

      final ledger = LedgerEntry()
        ..accountId = account.id
        ..accountName = account.name
        ..type = 'expense'
        ..category = category
        ..amount = draft.amount
        ..reference = _emptyToNull(draft.paidBy)
        ..note = _emptyToNull(draft.description)
        ..movementKind = 'expense'
        ..entryDate = draft.entryDate
        ..createdAt = now;
      final ledgerId = await isar.ledgerEntrys.put(ledger);

      await isar.financeExpenses.put(
        FinanceExpense()
          ..category = category
          ..amount = draft.amount
          ..accountId = account.id
          ..accountName = account.name
          ..entryDate = draft.entryDate
          ..description = _emptyToNull(draft.description)
          ..paidBy = _emptyToNull(draft.paidBy)
          ..receiptPath = receiptPath
          ..ledgerEntryId = ledgerId
          ..createdAt = now,
      );
    });
  }

  Future<void> addAdvance(EmployeeAdvanceDraft draft) async {
    if (draft.amount <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }

    final isar = _isarService.instance;
    final employee = await isar.employees.get(draft.employeeId);
    if (employee == null || employee.deletedAt != null) {
      throw StateError('Employee not found.');
    }
    final account = await isar.accounts.get(draft.accountId);
    if (account == null) throw StateError('Account not found.');

    final now = DateTime.now();
    final nextBalance =
        (account.balance - draft.amount).clamp(-999999999.0, 999999999.0);

    await isar.writeTxn(() async {
      account.balance = nextBalance.toDouble();
      await isar.accounts.put(account);

      final ledger = LedgerEntry()
        ..accountId = account.id
        ..accountName = account.name
        ..type = 'expense'
        ..category = 'Employee Advance'
        ..amount = draft.amount
        ..reference = employee.name
        ..note = _emptyToNull(draft.note)
        ..movementKind = 'advance'
        ..employeeId = employee.id
        ..employeeName = employee.name
        ..entryDate = draft.entryDate
        ..createdAt = now;
      final ledgerId = await isar.ledgerEntrys.put(ledger);

      await isar.employeeAdvances.put(
        EmployeeAdvance()
          ..employeeId = employee.id
          ..employeeName = employee.name
          ..amount = draft.amount
          ..accountId = account.id
          ..accountName = account.name
          ..entryDate = draft.entryDate
          ..note = _emptyToNull(draft.note)
          ..ledgerEntryId = ledgerId
          ..createdAt = now,
      );
    });
  }

  Future<void> addCommission(EmployeeCommissionDraft draft) async {
    if (draft.amount <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }

    final isar = _isarService.instance;
    final employee = await isar.employees.get(draft.employeeId);
    if (employee == null || employee.deletedAt != null) {
      throw StateError('Employee not found.');
    }
    final account = await isar.accounts.get(draft.accountId);
    if (account == null) throw StateError('Account not found.');

    final now = DateTime.now();
    final nextBalance =
        (account.balance - draft.amount).clamp(-999999999.0, 999999999.0);

    await isar.writeTxn(() async {
      account.balance = nextBalance.toDouble();
      await isar.accounts.put(account);

      final modeLabel = draft.mode == CommissionPayMode.percent
          ? 'Commission · ${draft.percentage}% of ${draft.baseAmount}'
          : 'Commission · Fixed Rs';
      final ledgerNote = _emptyToNull(draft.note) ??
          (draft.mode == CommissionPayMode.percent
              ? '${draft.percentage}% of base'
              : 'Fixed commission');

      final ledger = LedgerEntry()
        ..accountId = account.id
        ..accountName = account.name
        ..type = 'expense'
        ..category = 'Employee Commission'
        ..amount = draft.amount
        ..reference = _emptyToNull(draft.reference) ?? modeLabel
        ..note = ledgerNote
        ..movementKind = 'commission'
        ..employeeId = employee.id
        ..employeeName = employee.name
        ..entryDate = draft.entryDate
        ..createdAt = now;
      final ledgerId = await isar.ledgerEntrys.put(ledger);

      await isar.employeeCommissions.put(
        EmployeeCommission()
          ..employeeId = employee.id
          ..employeeName = employee.name
          ..amount = draft.amount
          ..mode = draft.mode.name
          ..percentage = draft.percentage
          ..baseAmount = draft.baseAmount
          ..accountId = account.id
          ..accountName = account.name
          ..entryDate = draft.entryDate
          ..reference = _emptyToNull(draft.reference)
          ..note = _emptyToNull(draft.note)
          ..ledgerEntryId = ledgerId
          ..createdAt = now,
      );
    });
  }

  Future<void> clockIn(AttendanceClockInDraft draft) async {
    final isar = _isarService.instance;
    final employee = await isar.employees.get(draft.employeeId);
    if (employee == null || employee.deletedAt != null) {
      throw StateError('Employee not found.');
    }
    if (!employee.isActive) {
      throw StateError('Employee is inactive.');
    }

    final open = await isar.employeeAttendances
        .filter()
        .employeeIdEqualTo(employee.id)
        .clockOutAtIsNull()
        .findFirst();
    if (open != null) {
      throw StateError('${employee.name} is already checked in.');
    }

    final now = DateTime.now();
    await isar.writeTxn(() async {
      await isar.employeeAttendances.put(
        EmployeeAttendance()
          ..employeeId = employee.id
          ..employeeName = employee.name
          ..clockInAt = now
          ..note = _emptyToNull(draft.note)
          ..createdAt = now,
      );
    });
  }

  Future<void> clockOut(AttendanceClockOutDraft draft) async {
    final isar = _isarService.instance;
    final row = await isar.employeeAttendances.get(draft.attendanceId);
    if (row == null) {
      throw StateError('Attendance record not found.');
    }
    if (row.clockOutAt != null) {
      throw StateError('${row.employeeName} is already checked out.');
    }

    final now = DateTime.now();
    if (!now.isAfter(row.clockInAt)) {
      throw StateError('Check out must be after check in.');
    }

    final extraNote = _emptyToNull(draft.note);
    await isar.writeTxn(() async {
      row.clockOutAt = now;
      if (extraNote != null) {
        final existing = _emptyToNull(row.note);
        row.note = existing == null ? extraNote : '$existing · $extraNote';
      }
      await isar.employeeAttendances.put(row);
    });
  }

  Future<void> addMovement(FinanceMovementDraft draft) async {
    if (draft.amount <= 0) {
      throw ArgumentError('Amount must be greater than zero.');
    }
    final isar = _isarService.instance;
    final account = await isar.accounts.get(draft.accountId);
    if (account == null) throw StateError('Account not found.');

    Employee? employee;
    if (draft.employeeId != null) {
      employee = await isar.employees.get(draft.employeeId!);
      if (employee == null) throw StateError('Employee not found.');
    }

    final now = DateTime.now();
    final delta = draft.kind.isExpense ? -draft.amount : draft.amount;
    final nextBalance =
        (account.balance + delta).clamp(-999999999.0, 999999999.0);

    await isar.writeTxn(() async {
      account.balance = nextBalance.toDouble();
      await isar.accounts.put(account);
      await isar.ledgerEntrys.put(
        LedgerEntry()
          ..accountId = account.id
          ..accountName = account.name
          ..type = draft.kind.isExpense ? 'expense' : 'income'
          ..category = draft.kind.ledgerCategory
          ..amount = draft.amount
          ..reference = _emptyToNull(draft.reference)
          ..note = _emptyToNull(draft.note)
          ..movementKind = draft.kind.storageKey
          ..employeeId = employee?.id
          ..employeeName = employee?.name
          ..entryDate = now
          ..createdAt = now,
      );
    });
  }

  Future<EmployeeItem> saveEmployee(EmployeeDraft draft, {int? id}) async {
    final name = draft.name.trim();
    if (name.isEmpty) throw ArgumentError('Employee name is required.');
    if (draft.monthlySalary < 0) {
      throw ArgumentError('Salary cannot be negative.');
    }

    final isar = _isarService.instance;
    late int savedId;
    await isar.writeTxn(() async {
      final existing = id == null ? null : await isar.employees.get(id);
      final employee = existing ?? Employee();
      if (existing == null) {
        employee.createdAt = DateTime.now();
      }
      employee
        ..name = name
        ..phone = _emptyToNull(draft.phone)
        ..designation = _emptyToNull(draft.designation)
        ..monthlySalary = draft.monthlySalary
        ..isActive = draft.isActive
        ..joinedAt = draft.joinedAt
        ..notes = _emptyToNull(draft.notes);
      savedId = await isar.employees.put(employee);
    });

    final saved = await isar.employees.get(savedId);
    return _mapEmployee(saved!);
  }

  Future<void> setEmployeeActive({
    required int id,
    required bool isActive,
  }) async {
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      final employee = await isar.employees.get(id);
      if (employee == null) return;
      employee.isActive = isActive;
      await isar.employees.put(employee);
      if (!isActive) {
        await _closeOpenAttendance(isar, id);
      }
    });
  }

  Future<void> deleteEmployee(int id) async {
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      final employee = await isar.employees.get(id);
      if (employee == null) return;
      employee.deletedAt = DateTime.now();
      employee.isActive = false;
      await isar.employees.put(employee);
      await _closeOpenAttendance(isar, id);
    });
  }

  Future<void> _closeOpenAttendance(Isar isar, int employeeId) async {
    final open = await isar.employeeAttendances
        .filter()
        .employeeIdEqualTo(employeeId)
        .clockOutAtIsNull()
        .findAll();
    if (open.isEmpty) return;
    final now = DateTime.now();
    for (final row in open) {
      row.clockOutAt = now.isAfter(row.clockInAt)
          ? now
          : row.clockInAt.add(const Duration(minutes: 1));
      await isar.employeeAttendances.put(row);
    }
  }

  Future<void> paySalary(SalaryPayDraft draft) async {
    if (draft.amount <= 0) {
      throw ArgumentError('Salary amount must be greater than zero.');
    }
    final meta = SalaryPaymentMeta(
      baseAmount: draft.baseAmount,
      commissionAmount: draft.commissionAmount,
      salesCount: draft.salesCount,
    );
    await addMovement(
      FinanceMovementDraft(
        kind: FinanceMovementKind.salary,
        accountId: draft.accountId,
        amount: draft.amount,
        employeeId: draft.employeeId,
        reference: draft.reference,
        note: meta.encodeNote(draft.note),
      ),
    );
  }

  Future<void> settlePayable({
    required int purchaseId,
    required int accountId,
    required double amount,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be greater than zero.');
    final isar = _isarService.instance;
    final purchase = await isar.purchases.get(purchaseId);
    if (purchase == null) throw StateError('Purchase not found.');
    if (amount > purchase.dueAmount + 0.001) {
      throw ArgumentError('Amount exceeds payable due.');
    }
    final account = await isar.accounts.get(accountId);
    if (account == null) throw StateError('Account not found.');

    final now = DateTime.now();
    final nextDue = (purchase.dueAmount - amount).clamp(0.0, double.infinity);
    final nextPaid = purchase.paidAmount + amount;
    final nextBalance =
        (account.balance - amount).clamp(-999999999.0, 999999999.0);

    await isar.writeTxn(() async {
      purchase
        ..paidAmount = nextPaid
        ..dueAmount = nextDue.toDouble()
        ..status = nextDue <= 0 ? 'paid' : 'open';
      await isar.purchases.put(purchase);

      account.balance = nextBalance.toDouble();
      await isar.accounts.put(account);

      await isar.ledgerEntrys.put(
        LedgerEntry()
          ..accountId = account.id
          ..accountName = account.name
          ..type = 'expense'
          ..category = 'Cash Out'
          ..amount = amount
          ..reference = purchase.invoiceNo
          ..note = 'Payable · ${purchase.supplierName}'
          ..movementKind = FinanceMovementKind.cashOut.storageKey
          ..entryDate = now
          ..createdAt = now,
      );
    });
  }

  Future<void> settleReceivable({
    required int customerId,
    required int accountId,
    required double amount,
  }) async {
    if (amount <= 0) throw ArgumentError('Amount must be greater than zero.');
    final isar = _isarService.instance;
    final customer = await isar.customers.get(customerId);
    if (customer == null) throw StateError('Customer not found.');
    if (amount > customer.balance + 0.001) {
      throw ArgumentError('Amount exceeds receivable balance.');
    }
    final account = await isar.accounts.get(accountId);
    if (account == null) throw StateError('Account not found.');

    final now = DateTime.now();
    final nextCustomerBalance =
        (customer.balance - amount).clamp(0.0, double.infinity);
    final nextAccountBalance =
        (account.balance + amount).clamp(-999999999.0, 999999999.0);

    await isar.writeTxn(() async {
      customer.balance = nextCustomerBalance.toDouble();
      await isar.customers.put(customer);
      await isar.customerLedgerEntrys.put(
        CustomerLedgerEntry()
          ..customerId = customer.id
          ..customerName = customer.name
          ..type = 'credit'
          ..amount = amount
          ..balanceAfter = nextCustomerBalance.toDouble()
          ..note = 'Payment received in Finance'
          ..entryDate = now
          ..createdAt = now,
      );

      account.balance = nextAccountBalance.toDouble();
      await isar.accounts.put(account);

      await isar.ledgerEntrys.put(
        LedgerEntry()
          ..accountId = account.id
          ..accountName = account.name
          ..type = 'income'
          ..category = 'Cash In'
          ..amount = amount
          ..reference = customer.name
          ..note = 'Receivable collected'
          ..movementKind = FinanceMovementKind.cashIn.storageKey
          ..entryDate = now
          ..createdAt = now,
      );
    });
  }

  bool _isFinanceKind(String kind) {
    return kind == 'cashIn' ||
        kind == 'cashOut' ||
        kind == 'ownerWithdrawal' ||
        kind == 'salary';
  }

  FinanceMovementKind _parseKind(String kind) {
    return FinanceMovementKind.values.firstWhere(
      (value) => value.storageKey == kind,
      orElse: () => FinanceMovementKind.cashOut,
    );
  }

  FinanceMovement _mapMovement(LedgerEntry entry) {
    return FinanceMovement(
      id: entry.id,
      kind: _parseKind(entry.movementKind),
      accountId: entry.accountId,
      accountName: entry.accountName,
      amount: entry.amount,
      entryDate: entry.entryDate,
      reference: entry.reference,
      note: entry.note,
      employeeId: entry.employeeId,
      employeeName: entry.employeeName,
    );
  }

  EmployeeItem _mapEmployee(Employee employee) {
    return EmployeeItem(
      id: employee.id,
      name: employee.name,
      monthlySalary: employee.monthlySalary,
      isActive: employee.isActive,
      phone: employee.phone,
      designation: employee.designation,
      joinedAt: employee.joinedAt,
      notes: employee.notes,
    );
  }

  ExpenseItem _mapExpense(FinanceExpense expense) {
    return ExpenseItem(
      id: expense.id,
      category: expense.category,
      amount: expense.amount,
      accountId: expense.accountId,
      accountName: expense.accountName,
      entryDate: expense.entryDate,
      description: expense.description,
      paidBy: expense.paidBy,
      receiptPath: expense.receiptPath,
    );
  }

  SalaryHistoryItem _mapSalaryHistory(LedgerEntry entry) {
    final parsed = SalaryPaymentMeta.parse(entry.note);
    final breakdown = parsed.breakdown;
    return SalaryHistoryItem(
      id: entry.id,
      employeeId: entry.employeeId,
      employeeName: entry.employeeName ?? 'Employee',
      amount: entry.amount,
      baseAmount: breakdown?.baseAmount ?? entry.amount,
      commissionAmount: breakdown?.commissionAmount ?? 0,
      salesCount: breakdown?.salesCount,
      accountId: entry.accountId,
      accountName: entry.accountName,
      entryDate: entry.entryDate,
      reference: entry.reference,
      note: parsed.userNote ?? (breakdown == null ? entry.note : null),
    );
  }

  EmployeeAdvanceItem _mapAdvance(EmployeeAdvance advance) {
    return EmployeeAdvanceItem(
      id: advance.id,
      employeeId: advance.employeeId,
      employeeName: advance.employeeName,
      amount: advance.amount,
      accountId: advance.accountId,
      accountName: advance.accountName,
      entryDate: advance.entryDate,
      note: advance.note,
    );
  }

  EmployeeCommissionItem _mapCommission(EmployeeCommission commission) {
    return EmployeeCommissionItem(
      id: commission.id,
      employeeId: commission.employeeId,
      employeeName: commission.employeeName,
      amount: commission.amount,
      accountId: commission.accountId,
      accountName: commission.accountName,
      entryDate: commission.entryDate,
      mode: commission.mode == 'percent'
          ? CommissionPayMode.percent
          : CommissionPayMode.fixed,
      percentage: commission.percentage,
      baseAmount: commission.baseAmount,
      reference: commission.reference,
      note: commission.note,
    );
  }

  AttendanceItem _mapAttendance(EmployeeAttendance row) {
    return AttendanceItem(
      id: row.id,
      employeeId: row.employeeId,
      employeeName: row.employeeName,
      clockInAt: row.clockInAt,
      clockOutAt: row.clockOutAt,
      note: row.note,
    );
  }

  bool _inPeriod(DateTime date, FinancePeriod period) {
    final now = DateTime.now();
    return switch (period) {
      FinancePeriod.all => true,
      FinancePeriod.today =>
        date.year == now.year &&
            date.month == now.month &&
            date.day == now.day,
      FinancePeriod.week => () {
          final start = DateTime(now.year, now.month, now.day)
              .subtract(Duration(days: now.weekday - 1));
          final end = start.add(const Duration(days: 7));
          return !date.isBefore(start) && date.isBefore(end);
        }(),
      FinancePeriod.month =>
        date.year == now.year && date.month == now.month,
    };
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }
}
