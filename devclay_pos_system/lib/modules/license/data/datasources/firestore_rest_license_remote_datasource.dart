import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:uuid/uuid.dart';

import '../../../../firebase_options.dart';
import 'firestore_rest_client.dart';
import 'license_remote_datasource.dart';

/// License remote over Firestore REST — used on Windows ARM where the native
/// Firestore C++ plugin can hard-crash. Same security rules as the SDK path.
class FirestoreRestLicenseRemoteDataSource implements LicenseRemoteDataSource {
  FirestoreRestLicenseRemoteDataSource({FirestoreRestClient? client})
      : _client = client ??
            FirestoreRestClient(
              projectId: DefaultFirebaseOptions.currentPlatform.projectId,
              apiKey: DefaultFirebaseOptions.currentPlatform.apiKey,
            );

  final FirestoreRestClient _client;
  final _uuid = const Uuid();

  @override
  Future<AppSettings> fetchSettings() async {
    try {
      final data = await _client.getDocument(
        '${FirestorePaths.settings}/${FirestorePaths.settingsGlobal}',
      );
      return AppSettings.fromFirestore(data);
    } catch (_) {
      return const AppSettings();
    }
  }

  @override
  Future<License?> fetchLicenseByKey(String licenseKey) async {
    final id = LicenseKeyGenerator.toDocumentId(licenseKey);
    final data = await _client.getDocument('${FirestorePaths.licenses}/$id');
    if (data == null) return null;
    return License.fromFirestore(id, data);
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

    final payload = Map<String, dynamic>.from(updated.toFirestore())
      ..removeWhere((_, value) => value == null);

    await _client.patchDocument(
      '${FirestorePaths.licenses}/${license.id}',
      payload,
    );

    final historyId = _uuid.v4();
    await _client.createDocument(
      '${FirestorePaths.licenses}/${license.id}/activationHistory',
      {
        'machineId': machineId,
        'deviceName': deviceName,
        'activatedAt': now.toIso8601String(),
        'action': AuditActions.licenseActivated,
      },
      documentId: historyId,
    );

    try {
      await _client.createDocument(
        FirestorePaths.auditLogs,
        {
          'action': AuditActions.licenseActivated,
          'actorUid': 'pos-client',
          'actorEmail': 'pos@local',
          'targetId': license.id,
          'targetType': 'license',
          'details': 'Activated on $deviceName ($machineId)',
          'createdAt': now.toIso8601String(),
          'isSuperAdmin': false,
        },
        documentId: _uuid.v4(),
      );
    } catch (_) {}
  }

  @override
  Future<void> syncDeviceTrial({
    required String machineId,
    required DateTime startedAt,
    required int trialDays,
  }) async {
    final existing =
        await _client.getDocument('${FirestorePaths.deviceTrials}/$machineId');
    if (existing != null) return;
    await _client.createDocument(
      FirestorePaths.deviceTrials,
      {
        'machineId': machineId,
        'startedAt': startedAt.toUtc().toIso8601String(),
        'trialDays': trialDays,
        'createdAt': DateTime.now().toUtc().toIso8601String(),
      },
      documentId: machineId,
    );
  }

  @override
  Future<Map<String, dynamic>?> fetchDeviceTrial(String machineId) async {
    try {
      return await _client.getDocument(
        '${FirestorePaths.deviceTrials}/$machineId',
      );
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
    final id = _uuid.v4();
    final request = LicenseRequest(
      id: id,
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

    final data = Map<String, dynamic>.from(request.toFirestore())
      ..removeWhere((_, value) => value == null);

    await _client.createDocument(
      FirestorePaths.licenseRequests,
      data,
      documentId: id,
    );

    try {
      await _client.createDocument(
        FirestorePaths.auditLogs,
        {
          'action': AuditActions.renewalRequested,
          'actorUid': 'pos-client',
          'actorEmail': contactEmail ?? 'pos@local',
          'targetId': id,
          'targetType': 'licenseRequest',
          'details':
              '${type.firestoreValue} request from ${businessName ?? machineId}',
          'createdAt': now.toIso8601String(),
          'isSuperAdmin': false,
        },
        documentId: _uuid.v4(),
      );
    } catch (_) {}

    return id;
  }
}
