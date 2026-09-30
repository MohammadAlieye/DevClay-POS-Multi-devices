import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclay_license_core/devclay_license_core.dart';

abstract class LicenseRemoteDataSource {
  Future<AppSettings> fetchSettings();

  Future<License?> fetchLicenseByKey(String licenseKey);

  Future<void> bindLicenseToMachine({
    required License license,
    required String machineId,
    required String deviceName,
  });

  Future<void> syncDeviceTrial({
    required String machineId,
    required DateTime startedAt,
    required int trialDays,
  });

  Future<Map<String, dynamic>?> fetchDeviceTrial(String machineId);

  Future<String> submitLicenseRequest({
    required LicenseRequestType type,
    required String machineId,
    String? deviceName,
    String? licenseKey,
    String? businessName,
    String? ownerName,
    String? customerId,
    String? contactPhone,
    String? contactEmail,
    String? message,
  });
}

class FirestoreLicenseRemoteDataSource implements LicenseRemoteDataSource {
  FirestoreLicenseRemoteDataSource({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  static const _timeout = Duration(seconds: 8);

  @override
  Future<AppSettings> fetchSettings() async {
    try {
      final snap = await _db
          .collection(FirestorePaths.settings)
          .doc(FirestorePaths.settingsGlobal)
          .get()
          .timeout(_timeout);
      return AppSettings.fromFirestore(snap.data());
    } catch (_) {
      return const AppSettings();
    }
  }

  @override
  Future<License?> fetchLicenseByKey(String licenseKey) async {
    final id = LicenseKeyGenerator.toDocumentId(licenseKey);
    final snap = await _db
        .collection(FirestorePaths.licenses)
        .doc(id)
        .get()
        .timeout(_timeout);
    if (!snap.exists || snap.data() == null) return null;
    return License.fromFirestore(snap.id, snap.data()!);
  }

  @override
  Future<void> bindLicenseToMachine({
    required License license,
    required String machineId,
    required String deviceName,
  }) async {
    final now = DateTime.now().toUtc();
    final updated = license.copyWith(
      machineId: machineId,
      deviceName: deviceName,
      activationDate: license.activationDate ?? now,
      status: license.status == LicenseStatus.trial
          ? LicenseStatus.trial
          : LicenseStatus.active,
      updatedAt: now,
    );

    final batch = _db.batch();
    final licenseRef =
        _db.collection(FirestorePaths.licenses).doc(license.id);
    batch.set(licenseRef, updated.toFirestore(), SetOptions(merge: true));

    final historyRef = licenseRef.collection('activationHistory').doc();
    batch.set(historyRef, {
      'machineId': machineId,
      'deviceName': deviceName,
      'activatedAt': now.toIso8601String(),
      'action': AuditActions.licenseActivated,
    });

    final auditRef = _db.collection(FirestorePaths.auditLogs).doc();
    batch.set(auditRef, {
      'action': AuditActions.licenseActivated,
      'actorUid': 'pos-client',
      'actorEmail': 'pos@local',
      'targetId': license.id,
      'targetType': 'license',
      'details': 'Activated on $deviceName ($machineId)',
      'createdAt': now.toIso8601String(),
      'isSuperAdmin': false,
    });

    await batch.commit();
  }

  @override
  Future<void> syncDeviceTrial({
    required String machineId,
    required DateTime startedAt,
    required int trialDays,
  }) async {
    final ref = _db.collection(FirestorePaths.deviceTrials).doc(machineId);
    final existing = await ref.get();
    if (existing.exists) return;
    await ref.set({
      'machineId': machineId,
      'startedAt': startedAt.toUtc().toIso8601String(),
      'trialDays': trialDays,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
    });
  }

  @override
  Future<Map<String, dynamic>?> fetchDeviceTrial(String machineId) async {
    try {
      final snap =
          await _db.collection(FirestorePaths.deviceTrials).doc(machineId).get();
      return snap.data();
    } catch (_) {
      return null;
    }
  }

  @override
  Future<String> submitLicenseRequest({
    required LicenseRequestType type,
    required String machineId,
    String? deviceName,
    String? licenseKey,
    String? businessName,
    String? ownerName,
    String? customerId,
    String? contactPhone,
    String? contactEmail,
    String? message,
  }) async {
    final now = DateTime.now().toUtc();
    final ref = _db.collection(FirestorePaths.licenseRequests).doc();
    final request = LicenseRequest(
      id: ref.id,
      type: type,
      status: LicenseRequestStatus.pending,
      machineId: machineId,
      deviceName: deviceName,
      licenseKey: licenseKey,
      businessName: businessName,
      ownerName: ownerName,
      customerId: customerId,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      message: message,
      createdAt: now,
      updatedAt: now,
    );

    // Drop nulls — cleaner for security rules / Firestore.
    final data = Map<String, dynamic>.from(request.toFirestore())
      ..removeWhere((_, value) => value == null);

    await ref.set(data);

    // Optional audit entry — never fail the user request because of this.
    try {
      await _db.collection(FirestorePaths.auditLogs).add({
        'action': AuditActions.renewalRequested,
        'actorUid': 'pos-client',
        'actorEmail': contactEmail ?? 'pos@local',
        'targetId': ref.id,
        'targetType': 'licenseRequest',
        'details':
            '${type.firestoreValue} request from ${businessName ?? machineId}',
        'createdAt': now.toIso8601String(),
        'isSuperAdmin': false,
      });
    } catch (_) {}

    return ref.id;
  }
}

/// Back-compat alias for existing call sites / DI.
typedef LicenseRemoteDataSourceImpl = FirestoreLicenseRemoteDataSource;
