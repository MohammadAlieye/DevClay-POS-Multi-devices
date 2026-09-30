import 'license_status.dart';
import 'license_type.dart';

/// Payload stored encrypted on the POS device.
class LocalLicensePayload {
  const LocalLicensePayload({
    required this.licenseKey,
    required this.licenseKeyHash,
    required this.businessName,
    required this.status,
    required this.licenseType,
    required this.machineId,
    this.deviceName,
    this.ownerName,
    this.customerId,
    this.activationDate,
    this.expiryDate,
    this.trialStartedAt,
    this.trialDays,
    required this.lastVerifiedAt,
    this.isTrial = false,
  });

  final String licenseKey;
  final String licenseKeyHash;
  final String businessName;
  final LicenseStatus status;
  final LicenseType licenseType;
  final String machineId;
  final String? deviceName;
  final String? ownerName;
  final String? customerId;
  final DateTime? activationDate;
  final DateTime? expiryDate;
  final DateTime? trialStartedAt;
  final int? trialDays;
  final DateTime lastVerifiedAt;
  final bool isTrial;

  bool get isExpired {
    if (isTrial) {
      final start = trialStartedAt;
      final days = trialDays;
      if (start == null || days == null) return true;
      return DateTime.now().toUtc().isAfter(start.add(Duration(days: days)));
    }
    if (licenseType == LicenseType.lifetime) return false;
    final expiry = expiryDate;
    if (expiry == null) return false;
    return DateTime.now().toUtc().isAfter(expiry);
  }

  int? get trialDaysRemaining {
    if (!isTrial || trialStartedAt == null || trialDays == null) return null;
    final end = trialStartedAt!.add(Duration(days: trialDays!));
    final remaining = end.difference(DateTime.now().toUtc()).inDays;
    return remaining < 0 ? 0 : remaining;
  }

  bool get allowsAccess {
    if (status == LicenseStatus.suspended || status == LicenseStatus.expired) {
      return false;
    }
    if (isExpired) return false;
    return status.allowsAccess || isTrial;
  }

  Map<String, dynamic> toJson() {
    return {
      'licenseKey': licenseKey,
      'licenseKeyHash': licenseKeyHash,
      'businessName': businessName,
      'status': status.firestoreValue,
      'licenseType': licenseType.firestoreValue,
      'machineId': machineId,
      'deviceName': deviceName,
      'ownerName': ownerName,
      'customerId': customerId,
      'activationDate': activationDate?.toUtc().toIso8601String(),
      'expiryDate': expiryDate?.toUtc().toIso8601String(),
      'trialStartedAt': trialStartedAt?.toUtc().toIso8601String(),
      'trialDays': trialDays,
      'lastVerifiedAt': lastVerifiedAt.toUtc().toIso8601String(),
      'isTrial': isTrial,
    };
  }

  factory LocalLicensePayload.fromJson(Map<String, dynamic> json) {
    return LocalLicensePayload(
      licenseKey: (json['licenseKey'] as String?) ?? '',
      licenseKeyHash: (json['licenseKeyHash'] as String?) ?? '',
      businessName: (json['businessName'] as String?) ?? '',
      status: LicenseStatus.fromFirestore(json['status'] as String?),
      licenseType: LicenseType.fromFirestore(json['licenseType'] as String?),
      machineId: (json['machineId'] as String?) ?? '',
      deviceName: json['deviceName'] as String?,
      ownerName: json['ownerName'] as String?,
      customerId: json['customerId'] as String?,
      activationDate: json['activationDate'] != null
          ? DateTime.tryParse(json['activationDate'] as String)?.toUtc()
          : null,
      expiryDate: json['expiryDate'] != null
          ? DateTime.tryParse(json['expiryDate'] as String)?.toUtc()
          : null,
      trialStartedAt: json['trialStartedAt'] != null
          ? DateTime.tryParse(json['trialStartedAt'] as String)?.toUtc()
          : null,
      trialDays: (json['trialDays'] as num?)?.toInt(),
      lastVerifiedAt: DateTime.tryParse(
                (json['lastVerifiedAt'] as String?) ?? '',
              )?.toUtc() ??
          DateTime.now().toUtc(),
      isTrial: json['isTrial'] as bool? ?? false,
    );
  }

  LocalLicensePayload copyWith({
    String? licenseKey,
    String? licenseKeyHash,
    String? businessName,
    LicenseStatus? status,
    LicenseType? licenseType,
    String? machineId,
    String? deviceName,
    String? ownerName,
    String? customerId,
    DateTime? activationDate,
    DateTime? expiryDate,
    DateTime? trialStartedAt,
    int? trialDays,
    DateTime? lastVerifiedAt,
    bool? isTrial,
  }) {
    return LocalLicensePayload(
      licenseKey: licenseKey ?? this.licenseKey,
      licenseKeyHash: licenseKeyHash ?? this.licenseKeyHash,
      businessName: businessName ?? this.businessName,
      status: status ?? this.status,
      licenseType: licenseType ?? this.licenseType,
      machineId: machineId ?? this.machineId,
      deviceName: deviceName ?? this.deviceName,
      ownerName: ownerName ?? this.ownerName,
      customerId: customerId ?? this.customerId,
      activationDate: activationDate ?? this.activationDate,
      expiryDate: expiryDate ?? this.expiryDate,
      trialStartedAt: trialStartedAt ?? this.trialStartedAt,
      trialDays: trialDays ?? this.trialDays,
      lastVerifiedAt: lastVerifiedAt ?? this.lastVerifiedAt,
      isTrial: isTrial ?? this.isTrial,
    );
  }
}
