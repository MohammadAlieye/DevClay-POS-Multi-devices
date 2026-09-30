import 'package:equatable/equatable.dart';

import '../utils/date_utils.dart';

abstract final class AuditActions {
  static const licenseCreated = 'License Created';
  static const licenseUpdated = 'License Updated';
  static const licenseActivated = 'License Activated';
  static const licenseRenewed = 'License Renewed';
  static const licenseSuspended = 'License Suspended';
  static const licenseExpired = 'License Expired';
  static const licenseDeleted = 'License Deleted';
  static const renewalRequested = 'Renewal Requested';
  static const licenseRequestUpdated = 'License Request Updated';
  static const passwordReset = 'Password Reset';

  static const adminLogin = 'Admin Login';
  static const superAdminAction = 'Super Admin Actions';
  static const customerCreated = 'Customer Created';
  static const customerUpdated = 'Customer Updated';
  static const customerDeleted = 'Customer Deleted';
  static const settingsUpdated = 'Settings Updated';
  static const accountUnlocked = 'Account Unlocked';
}

class AuditLog extends Equatable {
  const AuditLog({
    required this.id,
    required this.action,
    required this.actorUid,
    required this.actorEmail,
    this.targetId,
    this.targetType,
    this.details,
    required this.createdAt,
    this.isSuperAdmin = false,
  });

  final String id;
  final String action;
  final String actorUid;
  final String actorEmail;
  final String? targetId;
  final String? targetType;
  final String? details;
  final DateTime createdAt;
  final bool isSuperAdmin;

  Map<String, dynamic> toFirestore() {
    return {
      'action': action,
      'actorUid': actorUid,
      'actorEmail': actorEmail,
      'targetId': targetId,
      'targetType': targetType,
      'details': details,
      'createdAt': toFirestoreDate(createdAt),
      'isSuperAdmin': isSuperAdmin,
    };
  }

  factory AuditLog.fromFirestore(String id, Map<String, dynamic> data) {
    return AuditLog(
      id: id,
      action: (data['action'] as String?) ?? '',
      actorUid: (data['actorUid'] as String?) ?? '',
      actorEmail: (data['actorEmail'] as String?) ?? '',
      targetId: data['targetId'] as String?,
      targetType: data['targetType'] as String?,
      details: data['details'] as String?,
      createdAt: parseFirestoreDate(data['createdAt']) ?? DateTime.now().toUtc(),
      isSuperAdmin: data['isSuperAdmin'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [id, action, actorUid, createdAt];
}
