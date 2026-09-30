import 'package:isar_community/isar.dart';

part 'employee_commission.g.dart';

@collection
class EmployeeCommission {
  Id id = Isar.autoIncrement;

  @Index()
  late int employeeId;

  late String employeeName;

  late double amount;

  /// fixed | percent
  String mode = 'fixed';

  /// Used when mode is percent (e.g. 5 for 5%).
  double? percentage;

  /// Sales / base amount used for percent commission.
  double? baseAmount;

  @Index()
  late int accountId;

  late String accountName;

  @Index()
  late DateTime entryDate;

  String? reference;
  String? note;

  int? ledgerEntryId;

  late DateTime createdAt;
}
