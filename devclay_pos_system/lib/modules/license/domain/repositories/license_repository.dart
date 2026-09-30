import 'package:devclay_license_core/devclay_license_core.dart';

import '../entities/license_gate_state.dart';

abstract class LicenseRepository {
  Future<LicenseGateSnapshot> verifyOnStartup();

  Future<LicenseGateSnapshot> activateLicense(String licenseKey);

  Future<AppSettings> fetchSettings();

  Future<String> getMachineId();

  Future<LocalLicensePayload?> getLocalLicense();

  Future<void> clearLocalLicense({bool resetMachineId = false});

  Future<String> localStoragePath();

  Future<OpenLicenseRequest?> getOpenLicenseRequest();

  Future<String> submitLicenseRequest({
    required LicenseRequestType type,
    String? contactPhone,
    String? contactEmail,
    String? message,
  });
}
