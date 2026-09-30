import 'package:isar_community/isar.dart';

part 'ledger_entry.g.dart';

@collection
class LedgerEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late int accountId;

  late String accountName;

  /// income | expense
  late String type;
  late String category;
  late double amount;
  String? reference;
  String? note;

  /// cashIn | cashOut | ownerWithdrawal | salary | general
  String movementKind = 'general';

  int? employeeId;
  String? employeeName;

  /// Staff member responsible for this financial movement.
  int? userId;
  String? userName;

  @Index()
  late DateTime entryDate;
  late DateTime createdAt;
}
