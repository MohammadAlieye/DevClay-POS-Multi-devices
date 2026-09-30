import 'package:isar_community/isar.dart';

part 'finance_expense.g.dart';

@collection
class FinanceExpense {
  Id id = Isar.autoIncrement;

  @Index()
  late String category;

  late double amount;

  @Index()
  late int accountId;

  late String accountName;

  @Index()
  late DateTime entryDate;

  String? description;
  String? paidBy;
  String? receiptPath;

  int? ledgerEntryId;

  late DateTime createdAt;

  DateTime? deletedAt;
}
