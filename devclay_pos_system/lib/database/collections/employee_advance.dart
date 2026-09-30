import 'package:isar_community/isar.dart';

part 'employee_advance.g.dart';

@collection
class EmployeeAdvance {
  Id id = Isar.autoIncrement;

  @Index()
  late int employeeId;

  late String employeeName;

  late double amount;

  @Index()
  late int accountId;

  late String accountName;

  @Index()
  late DateTime entryDate;

  String? note;

  int? ledgerEntryId;

  late DateTime createdAt;
}
