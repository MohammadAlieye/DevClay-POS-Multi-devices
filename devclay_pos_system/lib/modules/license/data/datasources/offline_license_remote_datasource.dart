import 'package:devclay_license_core/devclay_license_core.dart';

import 'license_remote_datasource.dart';

/// No-op remote used when native Firestore is unsafe (e.g. Windows on ARM).
///
/// Forces the license layer into its offline path instead of calling into the
/// Firebase C++ SDK, which can terminate the process with illegal instruction.
class OfflineLicenseRemoteDataSource implements LicenseRemoteDataSource {
  OfflineLicenseRemoteDataSource();

  static final _offline = StateError(
    'Cloud license service unavailable on this device (offline mode).',
  );

  @override
  Future<AppSettings> fetchSettings() async => const AppSettings();

  @override
  Future<License?> fetchLicenseByKey(String licenseKey) async =>
      throw _offline;

  @override
  Future<void> bindLicenseToMachine({
    required License license,
    required String machineId,
    required String deviceName,
  }) async =>
      throw _offline;

  @override
  Future<void> syncDeviceTrial({
    required String machineId,
    required DateTime startedAt,
    required int trialDays,
  }) async {}

  @override
  Future<Map<String, dynamic>?> fetchDeviceTrial(String machineId) async =>
      null;

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
  }) async =>
      throw _offline;
}
