import 'package:isar_community/isar.dart';

part 'audit_entry.g.dart';

@collection
class AuditEntry {
  Id id = Isar.autoIncrement;

  @Index()
  late String action;
  late String entityType;
  int? entityId;
  int? userId;
  String? userName;
  late String details;

  @Index()
  late DateTime occurredAt;
}
