import 'package:equatable/equatable.dart';

/// Standard business expense categories for Finance → Expenses.
const kFinanceExpenseCategories = [
  'Electricity',
  'Gas',
  'Internet',
  'Shop rent',
  'Transport',
  'Maintenance',
  'Tea/food',
  'Packaging',
  'Miscellaneous',
  'Marketing',
  'Delivery expenses',
];

enum FinancePeriod { today, week, month, all }

enum FinanceViewTab {
  overview,
  employees,
  attendance,
  expenses,
  salaryHistory,
  advances,
  commission,
  cashIn,
  cashOut,
  withdrawals,
  payables,
  receivables,
}

enum FinanceMovementKind {
  cashIn,
  cashOut,
  ownerWithdrawal,
  salary,
}

class FinanceAccountOption extends Equatable {
  const FinanceAccountOption({
    required this.id,
    required this.name,
    required this.balance,
    required this.type,
  });

  final int id;
  final String name;
  final double balance;
  final String type;

  @override
  List<Object?> get props => [id, name, balance, type];
}

class FinanceMovement extends Equatable {
  const FinanceMovement({
    required this.id,
    required this.kind,
    required this.accountId,
    required this.accountName,
    required this.amount,
    required this.entryDate,
    this.reference,
    this.note,
    this.employeeId,
    this.employeeName,
  });

  final int id;
  final FinanceMovementKind kind;
  final int accountId;
  final String accountName;
  final double amount;
  final DateTime entryDate;
  final String? reference;
  final String? note;
  final int? employeeId;
  final String? employeeName;

  @override
  List<Object?> get props => [
        id,
        kind,
        accountId,
        accountName,
        amount,
        entryDate,
        reference,
        note,
        employeeId,
        employeeName,
      ];
}

class FinanceMovementDraft extends Equatable {
  const FinanceMovementDraft({
    required this.kind,
    required this.accountId,
    required this.amount,
    this.reference,
    this.note,
    this.employeeId,
  });

  final FinanceMovementKind kind;
  final int accountId;
  final double amount;
  final String? reference;
  final String? note;
  final int? employeeId;

  @override
  List<Object?> get props =>
      [kind, accountId, amount, reference, note, employeeId];
}

class EmployeeItem extends Equatable {
  const EmployeeItem({
    required this.id,
    required this.name,
    required this.monthlySalary,
    required this.isActive,
    this.phone,
    this.designation,
    this.joinedAt,
    this.notes,
  });

  final int id;
  final String name;
  final double monthlySalary;
  final bool isActive;
  final String? phone;
  final String? designation;
  final DateTime? joinedAt;
  final String? notes;

  @override
  List<Object?> get props => [
        id,
        name,
        monthlySalary,
        isActive,
        phone,
        designation,
        joinedAt,
        notes,
      ];
}

class EmployeeDraft extends Equatable {
  const EmployeeDraft({
    required this.name,
    required this.monthlySalary,
    this.phone,
    this.designation,
    this.joinedAt,
    this.notes,
    this.isActive = true,
  });

  final String name;
  final double monthlySalary;
  final String? phone;
  final String? designation;
  final DateTime? joinedAt;
  final String? notes;
  final bool isActive;

  @override
  List<Object?> get props =>
      [name, monthlySalary, phone, designation, joinedAt, notes, isActive];
}

class SalaryPayDraft extends Equatable {
  const SalaryPayDraft({
    required this.employeeId,
    required this.accountId,
    required this.baseAmount,
    this.commissionAmount = 0,
    this.salesCount,
    this.reference,
    this.note,
  });

  final int employeeId;
  final int accountId;
  final double baseAmount;
  final double commissionAmount;
  final int? salesCount;
  final String? reference;
  final String? note;

  double get amount => baseAmount + commissionAmount;

  @override
  List<Object?> get props => [
        employeeId,
        accountId,
        baseAmount,
        commissionAmount,
        salesCount,
        reference,
        note,
      ];
}

/// Encodes salary breakdown in ledger [note] for history display.
class SalaryPaymentMeta {
  const SalaryPaymentMeta({
    required this.baseAmount,
    this.commissionAmount = 0,
    this.salesCount,
  });

  static const _prefix = '__salary_meta__';

  final double baseAmount;
  final double commissionAmount;
  final int? salesCount;

  double get total => baseAmount + commissionAmount;

  String encodeNote(String? userNote) {
    final parts = <String>['base=$baseAmount'];
    if (commissionAmount > 0) {
      parts.add('commission=$commissionAmount');
    }
    if (salesCount != null && salesCount! > 0) {
      parts.add('sales=$salesCount');
    }
    final meta = '$_prefix${parts.join(';')}';
    final trimmed = userNote?.trim();
    if (trimmed == null || trimmed.isEmpty) return meta;
    return '$meta\n$trimmed';
  }

  static ({SalaryPaymentMeta? breakdown, String? userNote}) parse(String? note) {
    if (note == null || note.isEmpty) {
      return (breakdown: null, userNote: null);
    }
    final lines = note.split('\n');
    final first = lines.first.trim();
    if (!first.startsWith(_prefix)) {
      return (breakdown: null, userNote: note);
    }
    final payload = first.substring(_prefix.length);
    double? base;
    double commission = 0;
    int? sales;
    for (final part in payload.split(';')) {
      final kv = part.split('=');
      if (kv.length != 2) continue;
      final key = kv[0].trim();
      final value = kv[1].trim();
      switch (key) {
        case 'base':
          base = double.tryParse(value);
        case 'commission':
          commission = double.tryParse(value) ?? 0;
        case 'sales':
          sales = int.tryParse(value);
      }
    }
    if (base == null) {
      return (breakdown: null, userNote: note);
    }
    final userNote = lines.length > 1 ? lines.sublist(1).join('\n').trim() : null;
    return (
      breakdown: SalaryPaymentMeta(
        baseAmount: base,
        commissionAmount: commission,
        salesCount: sales,
      ),
      userNote: userNote?.isEmpty == true ? null : userNote,
    );
  }
}

class PayableItem extends Equatable {
  const PayableItem({
    required this.purchaseId,
    required this.supplierName,
    required this.invoiceNo,
    required this.dueAmount,
    required this.total,
    required this.purchaseDate,
  });

  final int purchaseId;
  final String supplierName;
  final String invoiceNo;
  final double dueAmount;
  final double total;
  final DateTime purchaseDate;

  @override
  List<Object?> get props =>
      [purchaseId, supplierName, invoiceNo, dueAmount, total, purchaseDate];
}

class ReceivableItem extends Equatable {
  const ReceivableItem({
    required this.customerId,
    required this.customerName,
    required this.phone,
    required this.balance,
  });

  final int customerId;
  final String customerName;
  final String phone;
  final double balance;

  @override
  List<Object?> get props => [customerId, customerName, phone, balance];
}

class ExpenseItem extends Equatable {
  const ExpenseItem({
    required this.id,
    required this.category,
    required this.amount,
    required this.accountId,
    required this.accountName,
    required this.entryDate,
    this.description,
    this.paidBy,
    this.receiptPath,
  });

  final int id;
  final String category;
  final double amount;
  final int accountId;
  final String accountName;
  final DateTime entryDate;
  final String? description;
  final String? paidBy;
  final String? receiptPath;

  @override
  List<Object?> get props => [
        id,
        category,
        amount,
        accountId,
        accountName,
        entryDate,
        description,
        paidBy,
        receiptPath,
      ];
}

class ExpenseDraft extends Equatable {
  const ExpenseDraft({
    required this.category,
    required this.amount,
    required this.accountId,
    required this.entryDate,
    this.description,
    this.paidBy,
    this.receiptSourcePath,
  });

  final String category;
  final double amount;
  final int accountId;
  final DateTime entryDate;
  final String? description;
  final String? paidBy;
  final String? receiptSourcePath;

  @override
  List<Object?> get props => [
        category,
        amount,
        accountId,
        entryDate,
        description,
        paidBy,
        receiptSourcePath,
      ];
}

class EmployeeAdvanceItem extends Equatable {
  const EmployeeAdvanceItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.amount,
    required this.accountId,
    required this.accountName,
    required this.entryDate,
    this.note,
  });

  final int id;
  final int employeeId;
  final String employeeName;
  final double amount;
  final int accountId;
  final String accountName;
  final DateTime entryDate;
  final String? note;

  @override
  List<Object?> get props => [
        id,
        employeeId,
        employeeName,
        amount,
        accountId,
        accountName,
        entryDate,
        note,
      ];
}

class EmployeeAdvanceDraft extends Equatable {
  const EmployeeAdvanceDraft({
    required this.employeeId,
    required this.accountId,
    required this.amount,
    required this.entryDate,
    this.note,
  });

  final int employeeId;
  final int accountId;
  final double amount;
  final DateTime entryDate;
  final String? note;

  @override
  List<Object?> get props =>
      [employeeId, accountId, amount, entryDate, note];
}

class AttendanceItem extends Equatable {
  const AttendanceItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.clockInAt,
    this.clockOutAt,
    this.note,
  });

  final int id;
  final int employeeId;
  final String employeeName;
  final DateTime clockInAt;
  final DateTime? clockOutAt;
  final String? note;

  bool get isOpen => clockOutAt == null;

  Duration get duration {
    final end = clockOutAt ?? DateTime.now();
    return end.difference(clockInAt);
  }

  String get durationLabel {
    final d = duration;
    if (d.isNegative) return '0m';
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    if (hours <= 0) return '${minutes}m';
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  @override
  List<Object?> get props =>
      [id, employeeId, employeeName, clockInAt, clockOutAt, note];
}

class AttendanceStats {
  const AttendanceStats({
    required this.checkIns,
    required this.days,
    required this.hours,
  });

  final int checkIns;
  final int days;
  final Duration hours;

  String get hoursLabel {
    if (hours.isNegative) return '0m';
    final h = hours.inHours;
    final m = hours.inMinutes.remainder(60);
    if (h <= 0) return '${m}m';
    return '${h}h ${m.toString().padLeft(2, '0')}m';
  }

  factory AttendanceStats.from(Iterable<AttendanceItem> items) {
    final days = <String>{};
    var total = Duration.zero;
    var checkIns = 0;
    for (final item in items) {
      checkIns += 1;
      final date = item.clockInAt;
      days.add('${date.year}-${date.month}-${date.day}');
      total += item.duration;
    }
    return AttendanceStats(checkIns: checkIns, days: days.length, hours: total);
  }
}

class AttendanceClockInDraft extends Equatable {
  const AttendanceClockInDraft({
    required this.employeeId,
    this.note,
  });

  final int employeeId;
  final String? note;

  @override
  List<Object?> get props => [employeeId, note];
}

class AttendanceClockOutDraft extends Equatable {
  const AttendanceClockOutDraft({
    required this.attendanceId,
    this.note,
  });

  final int attendanceId;
  final String? note;

  @override
  List<Object?> get props => [attendanceId, note];
}

enum CommissionPayMode { fixed, percent }

class EmployeeCommissionItem extends Equatable {
  const EmployeeCommissionItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.amount,
    required this.accountId,
    required this.accountName,
    required this.entryDate,
    this.mode = CommissionPayMode.fixed,
    this.percentage,
    this.baseAmount,
    this.reference,
    this.note,
  });

  final int id;
  final int employeeId;
  final String employeeName;
  final double amount;
  final int accountId;
  final String accountName;
  final DateTime entryDate;
  final CommissionPayMode mode;
  final double? percentage;
  final double? baseAmount;
  final String? reference;
  final String? note;

  @override
  List<Object?> get props => [
        id,
        employeeId,
        employeeName,
        amount,
        accountId,
        accountName,
        entryDate,
        mode,
        percentage,
        baseAmount,
        reference,
        note,
      ];
}

class EmployeeCommissionDraft extends Equatable {
  const EmployeeCommissionDraft({
    required this.employeeId,
    required this.accountId,
    required this.amount,
    required this.entryDate,
    this.mode = CommissionPayMode.fixed,
    this.percentage,
    this.baseAmount,
    this.reference,
    this.note,
  });

  final int employeeId;
  final int accountId;
  final double amount;
  final DateTime entryDate;
  final CommissionPayMode mode;
  final double? percentage;
  final double? baseAmount;
  final String? reference;
  final String? note;

  @override
  List<Object?> get props => [
        employeeId,
        accountId,
        amount,
        entryDate,
        mode,
        percentage,
        baseAmount,
        reference,
        note,
      ];
}

class SalaryHistoryItem extends Equatable {
  const SalaryHistoryItem({
    required this.id,
    required this.employeeId,
    required this.employeeName,
    required this.amount,
    required this.baseAmount,
    required this.accountId,
    required this.accountName,
    required this.entryDate,
    this.commissionAmount = 0,
    this.salesCount,
    this.reference,
    this.note,
  });

  final int id;
  final int? employeeId;
  final String employeeName;
  /// Total paid (base + commission).
  final double amount;
  final double baseAmount;
  final double commissionAmount;
  final int? salesCount;
  final int accountId;
  final String accountName;
  final DateTime entryDate;
  final String? reference;
  final String? note;

  bool get hasCommission => commissionAmount > 0.009;

  @override
  List<Object?> get props => [
        id,
        employeeId,
        employeeName,
        amount,
        baseAmount,
        commissionAmount,
        salesCount,
        accountId,
        accountName,
        entryDate,
        reference,
        note,
      ];
}

class FinanceOverview extends Equatable {
  const FinanceOverview({
    required this.totalBalance,
    required this.cashIn,
    required this.cashOut,
    required this.withdrawals,
    required this.salariesPaid,
    required this.expensesTotal,
    required this.advancesTotal,
    required this.commissionsTotal,
    required this.payablesDue,
    required this.receivablesDue,
    required this.activeEmployees,
    required this.monthlyPayroll,
    required this.presentToday,
    required this.currentlyIn,
    required this.attendanceHours,
  });

  final double totalBalance;
  final double cashIn;
  final double cashOut;
  final double withdrawals;
  final double salariesPaid;
  final double expensesTotal;
  final double advancesTotal;
  final double commissionsTotal;
  final double payablesDue;
  final double receivablesDue;
  final int activeEmployees;
  final double monthlyPayroll;
  final int presentToday;
  final int currentlyIn;
  final Duration attendanceHours;

  String get attendanceHoursLabel {
    final hours = attendanceHours.inHours;
    final minutes = attendanceHours.inMinutes.remainder(60);
    if (hours <= 0) return '${minutes}m';
    return '${hours}h ${minutes.toString().padLeft(2, '0')}m';
  }

  @override
  List<Object?> get props => [
        totalBalance,
        cashIn,
        cashOut,
        withdrawals,
        salariesPaid,
        expensesTotal,
        advancesTotal,
        commissionsTotal,
        payablesDue,
        receivablesDue,
        activeEmployees,
        monthlyPayroll,
        presentToday,
        currentlyIn,
        attendanceHours,
      ];
}

class FinanceData extends Equatable {
  const FinanceData({
    required this.overview,
    required this.accounts,
    required this.movements,
    required this.expenses,
    required this.salaryHistory,
    required this.allSalaryHistory,
    required this.advances,
    required this.commissions,
    required this.employees,
    required this.attendances,
    required this.payables,
    required this.receivables,
  });

  final FinanceOverview overview;
  final List<FinanceAccountOption> accounts;
  final List<FinanceMovement> movements;
  final List<ExpenseItem> expenses;
  final List<SalaryHistoryItem> salaryHistory;
  /// Unfiltered salary ledger rows — used for monthly paid status.
  final List<SalaryHistoryItem> allSalaryHistory;
  final List<EmployeeAdvanceItem> advances;
  final List<EmployeeCommissionItem> commissions;
  final List<EmployeeItem> employees;
  final List<AttendanceItem> attendances;
  final List<PayableItem> payables;
  final List<ReceivableItem> receivables;

  AttendanceItem? openAttendanceFor(int employeeId) {
    for (final item in attendances) {
      if (item.isOpen && item.employeeId == employeeId) return item;
    }
    return null;
  }

  SalaryHistoryItem? salaryPaymentForMonth(
    int employeeId, {
    DateTime? month,
  }) {
    final m = month ?? DateTime.now();
    for (final item in allSalaryHistory) {
      if (item.employeeId != employeeId) continue;
      if (item.entryDate.year == m.year && item.entryDate.month == m.month) {
        return item;
      }
    }
    return null;
  }

  List<SalaryHistoryItem> salaryHistoryForEmployee(int employeeId) {
    return allSalaryHistory
        .where((item) => item.employeeId == employeeId)
        .toList()
      ..sort((a, b) => b.entryDate.compareTo(a.entryDate));
  }

  @override
  List<Object?> get props => [
        overview,
        accounts,
        movements,
        expenses,
        salaryHistory,
        allSalaryHistory,
        advances,
        commissions,
        employees,
        attendances,
        payables,
        receivables,
      ];
}

extension FinanceMovementKindX on FinanceMovementKind {
  String get storageKey => name;

  String get label => switch (this) {
        FinanceMovementKind.cashIn => 'Cash In',
        FinanceMovementKind.cashOut => 'Cash Out',
        FinanceMovementKind.ownerWithdrawal => 'Owner Withdrawal',
        FinanceMovementKind.salary => 'Salary',
      };

  String get ledgerCategory => switch (this) {
        FinanceMovementKind.cashIn => 'Cash In',
        FinanceMovementKind.cashOut => 'Cash Out',
        FinanceMovementKind.ownerWithdrawal => 'Owner Withdrawal',
        FinanceMovementKind.salary => 'Salary',
      };

  bool get isExpense => this != FinanceMovementKind.cashIn;
}
