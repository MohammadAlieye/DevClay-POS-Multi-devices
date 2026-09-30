import 'package:isar_community/isar.dart';

import '../../database/collections/audit_entry.dart';
import '../../database/collections/auth_session.dart';
import '../../database/collections/user_account.dart';

class RetailActor {
  const RetailActor({required this.id, required this.name, required this.role});

  final int id;
  final String name;
  final String role;

  bool get isOwnerOrManager => role == 'owner' || role == 'manager';
}

abstract final class RetailActorStore {
  static Future<RetailActor?> current(Isar isar) async {
    final session = await isar.authSessions
        .filter()
        .keyEqualTo('current')
        .findFirst();
    final userId = session?.userId;
    if (userId == null) return null;
    final user = await isar.userAccounts.get(userId);
    if (user == null || !user.isActive || user.deletedAt != null) return null;
    return RetailActor(id: user.id, name: user.displayName, role: user.role);
  }

  /// Must be called inside an Isar write transaction.
  static Future<void> audit({
    required Isar isar,
    required String action,
    required String entityType,
    required String details,
    RetailActor? actor,
    int? entityId,
    DateTime? occurredAt,
  }) async {
    await isar.auditEntrys.put(
      AuditEntry()
        ..action = action
        ..entityType = entityType
        ..entityId = entityId
        ..userId = actor?.id
        ..userName = actor?.name
        ..details = details
        ..occurredAt = occurredAt ?? DateTime.now(),
    );
  }
}
