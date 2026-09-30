import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:uuid/uuid.dart';

import '../../auth/domain/entities/admin_user.dart';

class DashboardStats {
  const DashboardStats({
    required this.totalCustomers,
    required this.activeLicenses,
    required this.trialLicenses,
    required this.expiredLicenses,
    required this.suspendedLicenses,
    required this.expiringSoon,
  });

  final int totalCustomers;
  final int activeLicenses;
  final int trialLicenses;
  final int expiredLicenses;
  final int suspendedLicenses;
  final int expiringSoon;
}

class ActivationHistoryEntry {
  const ActivationHistoryEntry({
    required this.id,
    required this.machineId,
    required this.deviceName,
    required this.activatedAt,
    required this.action,
  });

  final String id;
  final String machineId;
  final String deviceName;
  final DateTime activatedAt;
  final String action;
}

class CustomerWithLicense {
  const CustomerWithLicense({
    required this.customer,
    this.license,
  });

  final LicenseCustomer customer;
  final License? license;
}

class AdminLicenseRepository {
  AdminLicenseRepository({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> get _licenses =>
      _db.collection(FirestorePaths.licenses);

  CollectionReference<Map<String, dynamic>> get _customers =>
      _db.collection(FirestorePaths.customers);

  CollectionReference<Map<String, dynamic>> get _audit =>
      _db.collection(FirestorePaths.auditLogs);

  Future<void> _log(
    AdminUser actor, {
    required String action,
    String? targetId,
    String? targetType,
    String? details,
  }) async {
    await _audit.add({
      'action': action,
      'actorUid': actor.uid,
      'actorEmail': actor.email,
      'targetId': targetId,
      'targetType': targetType,
      'details': details,
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'isSuperAdmin': actor.isSuperAdmin,
    });
  }

  Future<DashboardStats> getDashboardStats() async {
    final licenses = await _licenses.get();
    final customers = await _customers.get();
    var active = 0;
    var trial = 0;
    var expired = 0;
    var suspended = 0;
    var expiringSoon = 0;

    for (final doc in licenses.docs) {
      final license = License.fromFirestore(doc.id, doc.data());
      switch (license.status) {
        case LicenseStatus.active:
          active++;
        case LicenseStatus.trial:
          trial++;
        case LicenseStatus.expired:
          expired++;
        case LicenseStatus.suspended:
          suspended++;
      }
      if (license.isExpired && license.status != LicenseStatus.expired) {
        expired++;
      }
      if (license.isExpiringSoon) expiringSoon++;
    }

    return DashboardStats(
      totalCustomers: customers.size,
      activeLicenses: active,
      trialLicenses: trial,
      expiredLicenses: expired,
      suspendedLicenses: suspended,
      expiringSoon: expiringSoon,
    );
  }

  Future<List<License>> listLicenses({String? query}) async {
    QuerySnapshot<Map<String, dynamic>> snap;
    try {
      snap = await _licenses.orderBy('createdAt', descending: true).get();
    } catch (_) {
      snap = await _licenses.get();
    }
    var items =
        snap.docs.map((d) => License.fromFirestore(d.id, d.data())).toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      items = items.where((l) {
        return l.businessName.toLowerCase().contains(q) ||
            l.ownerName.toLowerCase().contains(q) ||
            l.phoneNumber.contains(q) ||
            l.licenseKey.toLowerCase().contains(q) ||
            l.email.toLowerCase().contains(q);
      }).toList();
    }
    return items;
  }

  Future<License?> getLicense(String id) async {
    final snap = await _licenses.doc(id).get();
    if (!snap.exists || snap.data() == null) return null;
    return License.fromFirestore(snap.id, snap.data()!);
  }

  DateTime? _expiryForType({
    required LicenseType licenseType,
    required int durationDays,
    DateTime? from,
  }) {
    final now = from ?? DateTime.now().toUtc();
    final duration = licenseType.defaultDuration;
    if (duration != null) return now.add(duration);
    if (licenseType == LicenseType.trial || licenseType == LicenseType.custom) {
      return now.add(Duration(days: durationDays));
    }
    return null; // lifetime
  }

  Future<License> createLicense({
    required AdminUser actor,
    required String businessName,
    required String ownerName,
    required String phoneNumber,
    required String email,
    required String businessAddress,
    required LicenseType licenseType,
    required int trialDays,
    int? customDays,
    String? notes,
    String? customerId,
    String? licenseKey,
  }) async {
    final key = LicenseKeyGenerator.normalize(
      licenseKey?.isNotEmpty == true
          ? licenseKey!
          : LicenseKeyGenerator.generate(),
    );
    final now = DateTime.now().toUtc();
    final durationDays = licenseType == LicenseType.custom
        ? (customDays ?? trialDays)
        : trialDays;
    final expiry = _expiryForType(
      licenseType: licenseType,
      durationDays: durationDays,
      from: now,
    );

    final license = License(
      id: LicenseKeyGenerator.toDocumentId(key),
      licenseKey: key,
      licenseKeyHash: LicenseKeyGenerator.hashKey(key),
      businessName: businessName.trim(),
      ownerName: ownerName.trim(),
      phoneNumber: phoneNumber.trim(),
      email: email.trim(),
      businessAddress: businessAddress.trim(),
      status: licenseType == LicenseType.trial
          ? LicenseStatus.trial
          : LicenseStatus.active,
      licenseType: licenseType,
      trialDays: durationDays,
      expiryDate: expiry,
      customerId: customerId,
      notes: notes,
      createdAt: now,
      updatedAt: now,
    );

    await _licenses.doc(license.id).set(license.toFirestore());

    if (customerId != null && customerId.isNotEmpty) {
      await _customers.doc(customerId).update({
        'licenseId': license.id,
      });
    }

    await _log(
      actor,
      action: AuditActions.licenseCreated,
      targetId: license.id,
      targetType: 'license',
      details: 'Created ${license.licenseType.firestoreValue} for $businessName',
    );

    return license;
  }

  Future<License> updateLicense({
    required AdminUser actor,
    required License license,
    required String businessName,
    required String ownerName,
    required String phoneNumber,
    required String email,
    required String businessAddress,
    required LicenseType licenseType,
    required LicenseStatus status,
    required int durationDays,
    String? notes,
    DateTime? expiryDate,
    bool clearMachineBinding = false,
  }) async {
    final now = DateTime.now().toUtc();
    DateTime? expiry = expiryDate;
    if (licenseType == LicenseType.lifetime) {
      expiry = null;
    } else {
      expiry ??= _expiryForType(
        licenseType: licenseType,
        durationDays: durationDays,
        from: license.activationDate ?? now,
      );
    }

    final updated = license.copyWith(
      businessName: businessName.trim(),
      ownerName: ownerName.trim(),
      phoneNumber: phoneNumber.trim(),
      email: email.trim(),
      businessAddress: businessAddress.trim(),
      licenseType: licenseType,
      status: status,
      trialDays: durationDays,
      notes: notes,
      expiryDate: expiry,
      clearExpiry: licenseType == LicenseType.lifetime,
      clearMachine: clearMachineBinding,
      updatedAt: now,
    );

    await _licenses.doc(license.id).set(updated.toFirestore());
    await _log(
      actor,
      action: AuditActions.licenseUpdated,
      targetId: license.id,
      targetType: 'license',
      details: 'Updated license details for ${updated.businessName}',
    );
    return updated;
  }

  Future<void> renewLicense({
    required AdminUser actor,
    required License license,
    required LicenseType newType,
    int? customDays,
  }) async {
    final now = DateTime.now().toUtc();
    final base = (license.expiryDate != null && license.expiryDate!.isAfter(now))
        ? license.expiryDate!
        : now;
    final expiry = _expiryForType(
      licenseType: newType,
      durationDays: customDays ?? license.trialDays,
      from: base,
    );

    final updated = license.copyWith(
      licenseType: newType,
      status: LicenseStatus.active,
      expiryDate: expiry,
      clearExpiry: newType == LicenseType.lifetime,
      trialDays: customDays ?? license.trialDays,
      updatedAt: now,
    );

    await _licenses.doc(license.id).set(updated.toFirestore());
    await _log(
      actor,
      action: AuditActions.licenseRenewed,
      targetId: license.id,
      targetType: 'license',
      details: 'Renewed as ${newType.firestoreValue}',
    );
  }

  Future<void> suspendLicense({
    required AdminUser actor,
    required License license,
  }) async {
    final updated = license.copyWith(
      status: LicenseStatus.suspended,
      updatedAt: DateTime.now().toUtc(),
    );
    await _licenses.doc(license.id).set(updated.toFirestore());
    await _log(
      actor,
      action: AuditActions.licenseSuspended,
      targetId: license.id,
      targetType: 'license',
    );
  }

  Future<void> expireLicense({
    required AdminUser actor,
    required License license,
  }) async {
    final updated = license.copyWith(
      status: LicenseStatus.expired,
      expiryDate: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    await _licenses.doc(license.id).set(updated.toFirestore());
    await _log(
      actor,
      action: AuditActions.licenseExpired,
      targetId: license.id,
      targetType: 'license',
    );
  }

  Future<void> activateLicenseManually({
    required AdminUser actor,
    required License license,
    required String machineId,
    required String deviceName,
  }) async {
    final now = DateTime.now().toUtc();
    final updated = license.copyWith(
      machineId: machineId,
      deviceName: deviceName,
      activationDate: license.activationDate ?? now,
      status: license.licenseType == LicenseType.trial
          ? LicenseStatus.trial
          : LicenseStatus.active,
      updatedAt: now,
    );
    final batch = _db.batch();
    final ref = _licenses.doc(license.id);
    batch.set(ref, updated.toFirestore());
    batch.set(ref.collection('activationHistory').doc(), {
      'machineId': machineId,
      'deviceName': deviceName,
      'activatedAt': now.toIso8601String(),
      'action': AuditActions.licenseActivated,
      'byAdmin': actor.email,
    });
    await batch.commit();
    await _log(
      actor,
      action: AuditActions.licenseActivated,
      targetId: license.id,
      targetType: 'license',
      details: 'Manual activation on $deviceName',
    );
  }

  Future<void> deleteLicense({
    required AdminUser actor,
    required License license,
  }) async {
    await _licenses.doc(license.id).delete();
    await _log(
      actor,
      action: AuditActions.licenseDeleted,
      targetId: license.id,
      targetType: 'license',
    );
  }

  Future<List<ActivationHistoryEntry>> getActivationHistory(
    String licenseId,
  ) async {
    final snap = await _licenses
        .doc(licenseId)
        .collection('activationHistory')
        .orderBy('activatedAt', descending: true)
        .get();
    return snap.docs.map((d) {
      final data = d.data();
      return ActivationHistoryEntry(
        id: d.id,
        machineId: (data['machineId'] as String?) ?? '',
        deviceName: (data['deviceName'] as String?) ?? '',
        activatedAt: DateTime.tryParse(
              (data['activatedAt'] as String?) ?? '',
            )?.toUtc() ??
            DateTime.now().toUtc(),
        action: (data['action'] as String?) ?? '',
      );
    }).toList();
  }

  // ----- Customers -----

  Future<List<LicenseCustomer>> listCustomers({String? query}) async {
    QuerySnapshot<Map<String, dynamic>> snap;
    try {
      snap = await _customers.orderBy('createdAt', descending: true).get();
    } catch (_) {
      snap = await _customers.get();
    }
    var items = snap.docs
        .map((d) => LicenseCustomer.fromFirestore(d.id, d.data()))
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      items = items.where((c) {
        return c.businessName.toLowerCase().contains(q) ||
            c.ownerName.toLowerCase().contains(q) ||
            c.phone.contains(q) ||
            c.email.toLowerCase().contains(q);
      }).toList();
    }
    return items;
  }

  /// Customers with their linked license (by licenseId or customerId).
  Future<List<CustomerWithLicense>> listCustomersWithLicenses({
    String? query,
  }) async {
    final customers = await listCustomers(query: query);
    final licenses = await listLicenses();
    final byId = {for (final l in licenses) l.id: l};
    final byCustomerId = <String, License>{};
    for (final l in licenses) {
      final cid = l.customerId;
      if (cid != null && cid.isNotEmpty) {
        byCustomerId[cid] = l;
      }
    }

    return customers.map((c) {
      License? license;
      if (c.licenseId != null && byId.containsKey(c.licenseId)) {
        license = byId[c.licenseId];
      } else {
        license = byCustomerId[c.id];
      }
      return CustomerWithLicense(customer: c, license: license);
    }).toList();
  }

  Future<LicenseCustomer> createCustomer({
    required AdminUser actor,
    required String businessName,
    required String ownerName,
    required String phone,
    required String email,
    required String address,
  }) async {
    final id = const Uuid().v4();
    final customer = LicenseCustomer(
      id: id,
      businessName: businessName.trim(),
      ownerName: ownerName.trim(),
      phone: phone.trim(),
      email: email.trim(),
      address: address.trim(),
      createdAt: DateTime.now().toUtc(),
    );
    await _customers.doc(id).set(customer.toFirestore());
    await _log(
      actor,
      action: AuditActions.customerCreated,
      targetId: id,
      targetType: 'customer',
    );
    return customer;
  }

  Future<void> updateCustomer({
    required AdminUser actor,
    required LicenseCustomer customer,
  }) async {
    await _customers.doc(customer.id).set(customer.toFirestore());
    await _log(
      actor,
      action: AuditActions.customerUpdated,
      targetId: customer.id,
      targetType: 'customer',
    );
  }

  Future<void> deleteCustomer({
    required AdminUser actor,
    required String customerId,
  }) async {
    await _customers.doc(customerId).delete();
    await _log(
      actor,
      action: AuditActions.customerDeleted,
      targetId: customerId,
      targetType: 'customer',
    );
  }

  // ----- Settings -----

  Future<AppSettings> getSettings() async {
    final snap = await _db
        .collection(FirestorePaths.settings)
        .doc(FirestorePaths.settingsGlobal)
        .get();
    return AppSettings.fromFirestore(snap.data());
  }

  Future<void> saveSettings({
    required AdminUser actor,
    required AppSettings settings,
  }) async {
    await _db
        .collection(FirestorePaths.settings)
        .doc(FirestorePaths.settingsGlobal)
        .set(settings.toFirestore(), SetOptions(merge: true));
    await _log(
      actor,
      action: AuditActions.settingsUpdated,
      targetId: FirestorePaths.settingsGlobal,
      targetType: 'settings',
    );
  }

  // ----- Audit -----

  Future<List<AuditLog>> listAuditLogs({int limit = 100}) async {
    final snap = await _audit
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();
    return snap.docs
        .map((d) => AuditLog.fromFirestore(d.id, d.data()))
        .toList();
  }

  // ----- License requests -----

  Future<List<LicenseRequest>> listLicenseRequests({
    LicenseRequestStatus? status,
  }) async {
    QuerySnapshot<Map<String, dynamic>> snap;
    try {
      snap = await _db
          .collection(FirestorePaths.licenseRequests)
          .orderBy('createdAt', descending: true)
          .get();
    } catch (_) {
      snap = await _db.collection(FirestorePaths.licenseRequests).get();
    }

    var items = snap.docs
        .map((d) => LicenseRequest.fromFirestore(d.id, d.data()))
        .toList();
    items.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    if (status != null) {
      items = items.where((r) => r.status == status).toList();
    }
    return items;
  }

  Future<void> updateLicenseRequestStatus({
    required AdminUser actor,
    required LicenseRequest request,
    required LicenseRequestStatus status,
    String? adminNote,
  }) async {
    final updated = request.copyWith(
      status: status,
      adminNote: adminNote,
      updatedAt: DateTime.now().toUtc(),
    );
    await _db
        .collection(FirestorePaths.licenseRequests)
        .doc(request.id)
        .set(updated.toFirestore(), SetOptions(merge: true));
    await _log(
      actor,
      action: AuditActions.licenseRequestUpdated,
      targetId: request.id,
      targetType: 'licenseRequest',
      details:
          'Marked ${request.type.firestoreValue} as ${status.firestoreValue}',
    );
  }

  Future<List<License>> globalSearch(String query) =>
      listLicenses(query: query);
}
