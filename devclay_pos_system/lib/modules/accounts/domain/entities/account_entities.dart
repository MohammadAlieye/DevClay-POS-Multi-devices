import 'package:equatable/equatable.dart';

enum AccountType { cash, bank, mobile }

enum LedgerType { income, expense }

enum AccountsPeriod { all, today, week, month }

enum AccountsViewTab { overview, transactions, accounts }

class AccountItem extends Equatable {
  const AccountItem({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    required this.isDefault,
    required this.isActive,
    this.notes,
  });

  final int id;
  final String name;
  final String type;
  final double balance;
  final bool isDefault;
  final bool isActive;
  final String? notes;

  AccountType get accountType => AccountType.values.firstWhere(
        (value) => value.name == type,
        orElse: () => AccountType.cash,
      );

  @override
  List<Object?> get props =>
      [id, name, type, balance, isDefault, isActive, notes];
}

class AccountDraft extends Equatable {
  const AccountDraft({
    required this.name,
    required this.type,
    required this.openingBalance,
    this.isDefault = false,
    this.isActive = true,
    this.notes,
  });

  final String name;
  final AccountType type;
  final double openingBalance;
  final bool isDefault;
  final bool isActive;
  final String? notes;

  @override
  List<Object?> get props =>
      [name, type, openingBalance, isDefault, isActive, notes];
}

class LedgerEntryItem extends Equatable {
  const LedgerEntryItem({
    required this.id,
    required this.accountId,
    required this.accountName,
    required this.type,
    required this.category,
    required this.amount,
    required this.entryDate,
    required this.createdAt,
    this.reference,
    this.note,
  });

  final int id;
  final int accountId;
  final String accountName;
  final String type;
  final String category;
  final double amount;
  final DateTime entryDate;
  final DateTime createdAt;
  final String? reference;
  final String? note;

  LedgerType get ledgerType => type == 'income'
      ? LedgerType.income
      : LedgerType.expense;

  bool get isToday {
    final now = DateTime.now();
    return entryDate.year == now.year &&
        entryDate.month == now.month &&
        entryDate.day == now.day;
  }

  bool get isThisWeek {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day)
        .subtract(Duration(days: now.weekday - 1));
    final end = start.add(const Duration(days: 7));
    return !entryDate.isBefore(start) && entryDate.isBefore(end);
  }

  bool get isThisMonth {
    final now = DateTime.now();
    return entryDate.year == now.year && entryDate.month == now.month;
  }

  bool isInPeriod(AccountsPeriod period) {
    return switch (period) {
      AccountsPeriod.all => true,
      AccountsPeriod.today => isToday,
      AccountsPeriod.week => isThisWeek,
      AccountsPeriod.month => isThisMonth,
    };
  }

  @override
  List<Object?> get props => [
        id,
        accountId,
        accountName,
        type,
        category,
        amount,
        entryDate,
        createdAt,
        reference,
        note,
      ];
}

class LedgerDraft extends Equatable {
  const LedgerDraft({
    required this.accountId,
    required this.type,
    required this.category,
    required this.amount,
    this.reference,
    this.note,
  });

  final int accountId;
  final LedgerType type;
  final String category;
  final double amount;
  final String? reference;
  final String? note;

  @override
  List<Object?> get props =>
      [accountId, type, category, amount, reference, note];
}

class AccountsOverview extends Equatable {
  const AccountsOverview({
    required this.totalBalance,
    required this.periodIncome,
    required this.periodExpense,
    required this.posSalesTotal,
    required this.purchasePaymentsTotal,
  });

  final double totalBalance;
  final double periodIncome;
  final double periodExpense;
  final double posSalesTotal;
  final double purchasePaymentsTotal;

  double get periodNet => periodIncome - periodExpense;

  @override
  List<Object?> get props => [
        totalBalance,
        periodIncome,
        periodExpense,
        posSalesTotal,
        purchasePaymentsTotal,
      ];
}

const List<String> kIncomeCategories = [
  'Sales deposit',
  'Customer payment',
  'Other income',
  'Adjustment',
];

const List<String> kExpenseCategories = [
  'Salary',
  'Rent',
  'Electricity',
  'Gas',
  'Water',
  'Internet / Phone',
  'Fuel / Transport',
  'Supplies',
  'Maintenance',
  'Marketing',
  'Tax / Fees',
  'Insurance',
  'Staff meals',
  'Other expense',
];
