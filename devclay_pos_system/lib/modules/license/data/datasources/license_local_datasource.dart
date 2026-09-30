import 'dart:convert';
import 'dart:io';

import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../domain/entities/license_gate_state.dart';

/// Desktop-safe encrypted license storage.
///
/// Uses AES-encrypted files under the app support directory so macOS does not
/// depend on Keychain entitlements (which require a development certificate).
class LicenseLocalDataSource {
  static const machineIdFileName = 'machine.id';
  static const deviceSecretFileName = 'device.secret';
  static const licenseFileName = 'license.enc';
  static const pendingRequestFileName = 'license_request.json';

  Future<Directory> supportDir() async {
    final dir = await getApplicationSupportDirectory();
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> _file(String name) async {
    final dir = await supportDir();
    return File('${dir.path}/$name');
  }

  Future<String> _readOrCreateTextFile(
    String name,
    String Function() create,
  ) async {
    final file = await _file(name);
    if (await file.exists()) {
      final value = (await file.readAsString()).trim();
      if (value.isNotEmpty) return value;
    }
    final value = create();
    await file.writeAsString(value, flush: true);
    return value;
  }

  Future<String> getOrCreateMachineId() {
    return _readOrCreateTextFile(machineIdFileName, () => const Uuid().v4());
  }

  Future<String> getOrCreateDeviceSecret() {
    return _readOrCreateTextFile(
      deviceSecretFileName,
      () => const Uuid().v4(),
    );
  }

  Future<void> saveEncryptedLicense(LocalLicensePayload payload) async {
    final secret = await getOrCreateDeviceSecret();
    final cipher = LicenseCrypto.encryptPayload(
      payload: payload,
      deviceSecret: secret,
    );
    final file = await _file(licenseFileName);
    await file.writeAsString(cipher, flush: true);
  }

  Future<LocalLicensePayload?> readEncryptedLicense() async {
    final file = await _file(licenseFileName);
    if (!await file.exists()) return null;
    final cipher = (await file.readAsString()).trim();
    if (cipher.isEmpty) return null;
    final secret = await getOrCreateDeviceSecret();
    try {
      return LicenseCrypto.decryptPayload(
        cipherText: cipher,
        deviceSecret: secret,
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearLicense() async {
    final file = await _file(licenseFileName);
    if (await file.exists()) {
      await file.delete();
    }
  }

  Future<void> saveOpenLicenseRequest(OpenLicenseRequest request) async {
    final file = await _file(pendingRequestFileName);
    await file.writeAsString(
      jsonEncode({
        'id': request.id,
        'sentAt': request.sentAt.toUtc().toIso8601String(),
        'type': request.type.firestoreValue,
      }),
      flush: true,
    );
  }

  Future<OpenLicenseRequest?> readOpenLicenseRequest() async {
    final file = await _file(pendingRequestFileName);
    if (!await file.exists()) return null;
    try {
      final data = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final sentAt = DateTime.tryParse(data['sentAt'] as String? ?? '');
      final id = (data['id'] as String?)?.trim() ?? '';
      if (id.isEmpty || sentAt == null) return null;
      return OpenLicenseRequest(
        id: id,
        sentAt: sentAt.toUtc(),
        type: LicenseRequestType.fromFirestore(data['type'] as String?),
      );
    } catch (_) {
      return null;
    }
  }

  Future<void> clearOpenLicenseRequest() async {
    final file = await _file(pendingRequestFileName);
    if (await file.exists()) {
      await file.delete();
    }
  }

  /// Clears local license (and optionally machine binding) for testing.
  Future<void> clearAllLocalData({bool resetMachineId = false}) async {
    await clearLicense();
    await clearOpenLicenseRequest();
    if (resetMachineId) {
      final machine = await _file(machineIdFileName);
      if (await machine.exists()) {
        await machine.delete();
      }
    }
  }

  Future<String> storagePath() async => (await supportDir()).path;

  Future<String> deviceName() async {
    if (kIsWeb) return 'Web';
    return Platform.localHostname;
  }
}
