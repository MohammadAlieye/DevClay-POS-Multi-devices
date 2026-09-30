import 'package:isar_community/isar.dart';

part 'employee.g.dart';

@collection
class Employee {
  Id id = Isar.autoIncrement;

  @Index()
  late String name;

  String? phone;
  String? designation;
  late double monthlySalary;
  late bool isActive;
  DateTime? joinedAt;
  String? notes;
  late DateTime createdAt;

  /// When set, employee is in the Recycle Bin.
  DateTime? deletedAt;
}
