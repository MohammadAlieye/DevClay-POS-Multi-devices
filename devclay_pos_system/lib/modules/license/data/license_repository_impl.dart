import 'package:devclay_license_core/devclay_license_core.dart';

import '../domain/entities/license_gate_state.dart';
import '../domain/repositories/license_repository.dart';
import 'datasources/license_local_datasource.dart';
import 'datasources/license_remote_datasource.dart';

class LicenseRepositoryImpl implements LicenseRepository {
  LicenseRepositoryImpl({
    required LicenseLocalDataSource local,
    required LicenseRemoteDataSource remote,
  })  : _local = local,
        _remote = remote;

  final LicenseLocalDataSource _local;
  final LicenseRemoteDataSource _remote;

  @override
  Future<String> getMachineId() => _local.getOrCreateMachineId();

  @override
  Future<LocalLicensePayload?> getLocalLicense() =>
      _local.readEncryptedLicense();

  @override
  Future<void> clearLocalLicense({bool resetMachineId = false}) =>
      _local.clearAllLocalData(resetMachineId: resetMachineId);

  @override
  Future<String> localStoragePath() => _local.storagePath();

  @override
  Future<AppSettings> fetchSettings() => _remote.fetchSettings();

  @override
  Future<LicenseGateSnapshot> verifyOnStartup() async {
    final machineId = await _local.getOrCreateMachineId();
    AppSettings settings = const AppSettings();
    var offline = false;

    try {
      settings = await _remote.fetchSettings();
    } catch (_) {
      offline = true;
    }

    if (settings.maintenanceMode) {
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.maintenance,
          message: 'DevClayPOS is under maintenance. Please try again later.',
        ),
      );
    }

    final local = await _local.readEncryptedLicense();

    // Legacy auto-trial (no key) is no longer allowed — force key entry.
    if (local == null || local.licenseKey.trim().isEmpty) {
      if (local != null) {
        await _local.clearLicense();
      }
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.activationRequired,
          message:
              'Enter your license key to continue. '
              'Ask DevClayPOS for a Trial or paid license key.',
        ),
      );
    }

    return _verifyActivated(local, machineId, offline: offline);
  }

  Future<LicenseGateSnapshot> _verifyActivated(
    LocalLicensePayload local,
    String machineId, {
    required bool offline,
  }) async {
    if (local.machineId != machineId) {
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.blocked,
          message: 'This license is bound to another machine.',
        ),
      );
    }

    if (!offline) {
      try {
        final remote = await _remote.fetchLicenseByKey(local.licenseKey);
        if (remote == null) {
          return _attachOpenRequest(
            LicenseGateSnapshot(
              mode: LicenseAccessMode.blocked,
              payload: local,
              message: 'License not found. Contact support.',
              offline: offline,
            ),
          );
        }

        if (remote.status == LicenseStatus.suspended) {
          final updated = local.copyWith(
            status: LicenseStatus.suspended,
            businessName: remote.businessName,
            ownerName: remote.ownerName,
            customerId: remote.customerId,
            lastVerifiedAt: DateTime.now().toUtc(),
          );
          await _local.saveEncryptedLicense(updated);
          return _attachOpenRequest(
            LicenseGateSnapshot(
              mode: LicenseAccessMode.blocked,
              payload: updated,
              message: 'License suspended. Contact DevClayPOS support.',
            ),
          );
        }

        if (remote.isExpired || remote.status == LicenseStatus.expired) {
          final updated = local.copyWith(
            status: LicenseStatus.expired,
            expiryDate: remote.expiryDate,
            businessName: remote.businessName,
            ownerName: remote.ownerName,
            customerId: remote.customerId,
            lastVerifiedAt: DateTime.now().toUtc(),
          );
          await _local.saveEncryptedLicense(updated);
          return _attachOpenRequest(
            LicenseGateSnapshot(
              mode: LicenseAccessMode.blocked,
              payload: updated,
              message: 'License expired. Please renew to continue.',
            ),
          );
        }

        if (remote.isBound && remote.machineId != machineId) {
          return _attachOpenRequest(
            const LicenseGateSnapshot(
              mode: LicenseAccessMode.blocked,
              message: 'License is bound to a different machine.',
            ),
          );
        }

        final isTrial = remote.licenseType == LicenseType.trial ||
            remote.status == LicenseStatus.trial;
        final synced = local.copyWith(
          status: remote.status,
          licenseType: remote.licenseType,
          expiryDate: remote.expiryDate,
          businessName: remote.businessName,
          ownerName: remote.ownerName,
          customerId: remote.customerId,
          trialDays: remote.trialDays,
          trialStartedAt: local.trialStartedAt ??
              remote.activationDate ??
              DateTime.now().toUtc(),
          lastVerifiedAt: DateTime.now().toUtc(),
          isTrial: isTrial,
        );
        await _local.saveEncryptedLicense(synced);

        if (!synced.allowsAccess) {
          return _attachOpenRequest(
            LicenseGateSnapshot(
              mode: LicenseAccessMode.blocked,
              payload: synced,
              message: 'License is not valid.',
            ),
          );
        }

        await _local.clearOpenLicenseRequest();
        return LicenseGateSnapshot(
          mode: isTrial
              ? LicenseAccessMode.trial
              : LicenseAccessMode.licensed,
          payload: synced,
          trialDaysRemaining: synced.trialDaysRemaining,
        );
      } catch (_) {
        offline = true;
      }
    }

    // Offline: trust last valid encrypted license
    if (local.allowsAccess) {
      await _local.clearOpenLicenseRequest();
      return LicenseGateSnapshot(
        mode: local.isTrial || local.licenseType == LicenseType.trial
            ? LicenseAccessMode.trial
            : LicenseAccessMode.licensed,
        payload: local,
        offline: true,
        trialDaysRemaining: local.trialDaysRemaining,
        message: 'Offline mode — using last verified license.',
      );
    }

    return _attachOpenRequest(
      LicenseGateSnapshot(
        mode: LicenseAccessMode.blocked,
        payload: local,
        offline: true,
        message: 'License invalid and offline verification failed.',
      ),
    );
  }

  @override
  Future<LicenseGateSnapshot> activateLicense(String licenseKey) async {
    final normalized = LicenseKeyGenerator.normalize(licenseKey);
    if (normalized.isEmpty) {
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.activationRequired,
          message: 'Enter a valid license key.',
        ),
      );
    }

    final machineId = await _local.getOrCreateMachineId();
    final deviceName = await _local.deviceName();

    final remote = await _remote.fetchLicenseByKey(normalized);
    if (remote == null) {
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.activationRequired,
          message: 'License key not found.',
        ),
      );
    }

    final expectedHash = LicenseKeyGenerator.hashKey(normalized);
    if (remote.licenseKeyHash.isNotEmpty &&
        remote.licenseKeyHash != expectedHash) {
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.activationRequired,
          message: 'License key integrity check failed.',
        ),
      );
    }

    if (remote.status == LicenseStatus.suspended) {
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.blocked,
          message: 'This license is suspended.',
        ),
      );
    }

    if (remote.isExpired || remote.status == LicenseStatus.expired) {
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.blocked,
          message: 'This license has expired.',
        ),
      );
    }

    if (remote.isBound && remote.machineId != machineId) {
      return _attachOpenRequest(
        const LicenseGateSnapshot(
          mode: LicenseAccessMode.blocked,
          message: 'This license is already activated on another machine.',
        ),
      );
    }

    if (!remote.isBound) {
      await _remote.bindLicenseToMachine(
        license: remote,
        machineId: machineId,
        deviceName: deviceName,
      );
    }

    final now = DateTime.now().toUtc();
    final isTrial = remote.licenseType == LicenseType.trial ||
        remote.status == LicenseStatus.trial;

    final payload = LocalLicensePayload(
      licenseKey: remote.licenseKey,
      licenseKeyHash: remote.licenseKeyHash.isEmpty
          ? expectedHash
          : remote.licenseKeyHash,
      businessName: remote.businessName,
      ownerName: remote.ownerName,
      customerId: remote.customerId,
      status: isTrial ? LicenseStatus.trial : LicenseStatus.active,
      licenseType: remote.licenseType,
      machineId: machineId,
      deviceName: deviceName,
      activationDate: remote.activationDate ?? now,
      expiryDate: remote.expiryDate,
      trialStartedAt: isTrial ? (remote.activationDate ?? now) : null,
      trialDays: isTrial ? remote.trialDays : null,
      lastVerifiedAt: now,
      isTrial: isTrial,
    );

    await _local.saveEncryptedLicense(payload);
    await _local.clearOpenLicenseRequest();

    return LicenseGateSnapshot(
      mode: isTrial ? LicenseAccessMode.trial : LicenseAccessMode.licensed,
      payload: payload,
      trialDaysRemaining: payload.trialDaysRemaining,
      message: isTrial
          ? 'Trial license activated successfully.'
          : 'License activated successfully.',
    );
  }

  @override
  Future<OpenLicenseRequest?> getOpenLicenseRequest() {
    return _local.readOpenLicenseRequest();
  }

  @override
  Future<String> submitLicenseRequest({
    required LicenseRequestType type,
    String? contactPhone,
    String? contactEmail,
    String? message,
  }) async {
    final existing = await _local.readOpenLicenseRequest();
    if (existing != null) return existing.id;

    final machineId = await _local.getOrCreateMachineId();
    final local = await _local.readEncryptedLicense();
    final deviceName = await _local.deviceName();
    final sentAt = DateTime.now().toUtc();

    final id = await _remote.submitLicenseRequest(
      type: type,
      machineId: machineId,
      deviceName: deviceName,
      licenseKey: local?.licenseKey,
      businessName: local?.businessName,
      ownerName: local?.ownerName,
      customerId: local?.customerId,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      message: message,
    );

    await _local.saveOpenLicenseRequest(
      OpenLicenseRequest(id: id, sentAt: sentAt, type: type),
    );
    return id;
  }

  Future<LicenseGateSnapshot> _attachOpenRequest(
    LicenseGateSnapshot snapshot,
  ) async {
    final open = await _local.readOpenLicenseRequest();
    if (open == null) return snapshot;
    return snapshot.copyWith(openRequest: open);
  }
}
