import 'package:isar_community/isar.dart';

part 'employee_attendance.g.dart';

@collection
class EmployeeAttendance {
  Id id = Isar.autoIncrement;

  @Index()
  late int employeeId;

  late String employeeName;

  @Index()
  late DateTime clockInAt;

  DateTime? clockOutAt;

  String? note;

  late DateTime createdAt;
}
