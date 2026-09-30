import 'package:equatable/equatable.dart';

import '../utils/date_utils.dart';
import 'license_status.dart';
import 'license_type.dart';

class License extends Equatable {
  const License({
    required this.id,
    required this.licenseKey,
    required this.licenseKeyHash,
    required this.businessName,
    required this.ownerName,
    required this.phoneNumber,
    required this.email,
    required this.businessAddress,
    required this.status,
    required this.licenseType,
    required this.trialDays,
    this.activationDate,
    this.expiryDate,
    this.machineId,
    this.deviceName,
    this.customerId,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final String licenseKey;
  final String licenseKeyHash;
  final String businessName;
  final String ownerName;
  final String phoneNumber;
  final String email;
  final String businessAddress;
  final LicenseStatus status;
  final LicenseType licenseType;
  final int trialDays;
  final DateTime? activationDate;
  final DateTime? expiryDate;
  final String? machineId;
  final String? deviceName;
  final String? customerId;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  bool get isBound => machineId != null && machineId!.isNotEmpty;

  bool get isExpired {
    if (licenseType == LicenseType.lifetime) return false;
    final expiry = expiryDate;
    if (expiry == null) return false;
    return DateTime.now().toUtc().isAfter(expiry);
  }

  bool get isExpiringSoon {
    if (licenseType == LicenseType.lifetime) return false;
    final expiry = expiryDate;
    if (expiry == null) return false;
    final now = DateTime.now().toUtc();
    if (now.isAfter(expiry)) return false;
    return expiry.difference(now).inDays <= 7;
  }

  bool allowsMachine(String currentMachineId) {
    if (!isBound) return true;
    return machineId == currentMachineId;
  }

  bool get allowsPosAccess {
    if (!status.allowsAccess) return false;
    if (isExpired) return false;
    return true;
  }

  License copyWith({
    String? id,
    String? licenseKey,
    String? licenseKeyHash,
    String? businessName,
    String? ownerName,
    String? phoneNumber,
    String? email,
    String? businessAddress,
    LicenseStatus? status,
    LicenseType? licenseType,
    int? trialDays,
    DateTime? activationDate,
    DateTime? expiryDate,
    String? machineId,
    String? deviceName,
    String? customerId,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool clearMachine = false,
    bool clearExpiry = false,
  }) {
    return License(
      id: id ?? this.id,
      licenseKey: licenseKey ?? this.licenseKey,
      licenseKeyHash: licenseKeyHash ?? this.licenseKeyHash,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      email: email ?? this.email,
      businessAddress: businessAddress ?? this.businessAddress,
      status: status ?? this.status,
      licenseType: licenseType ?? this.licenseType,
      trialDays: trialDays ?? this.trialDays,
      activationDate: activationDate ?? this.activationDate,
      expiryDate: clearExpiry ? null : (expiryDate ?? this.expiryDate),
      machineId: clearMachine ? null : (machineId ?? this.machineId),
      deviceName: clearMachine ? null : (deviceName ?? this.deviceName),
      customerId: customerId ?? this.customerId,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'licenseKey': licenseKey,
      'licenseKeyHash': licenseKeyHash,
      'businessName': businessName,
      'ownerName': ownerName,
      'phoneNumber': phoneNumber,
      'email': email,
      'businessAddress': businessAddress,
      'status': status.firestoreValue,
      'licenseType': licenseType.firestoreValue,
      'trialDays': trialDays,
      'activationDate': toFirestoreDate(activationDate),
      'expiryDate': toFirestoreDate(expiryDate),
      'machineId': machineId,
      'deviceName': deviceName,
      'customerId': customerId,
      'notes': notes,
      'createdAt': toFirestoreDate(createdAt),
      'updatedAt': toFirestoreDate(updatedAt),
      'searchBusinessName': businessName.toLowerCase(),
      'searchOwnerName': ownerName.toLowerCase(),
      'searchPhone': phoneNumber.replaceAll(RegExp(r'\s+'), ''),
      'searchLicenseKey': licenseKey.toUpperCase(),
    };
  }

  factory License.fromFirestore(String id, Map<String, dynamic> data) {
    return License(
      id: id,
      licenseKey: (data['licenseKey'] as String?) ?? id,
      licenseKeyHash: (data['licenseKeyHash'] as String?) ?? '',
      businessName: (data['businessName'] as String?) ?? '',
      ownerName: (data['ownerName'] as String?) ?? '',
      phoneNumber: (data['phoneNumber'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      businessAddress: (data['businessAddress'] as String?) ?? '',
      status: LicenseStatus.fromFirestore(data['status'] as String?),
      licenseType: LicenseType.fromFirestore(data['licenseType'] as String?),
      trialDays: (data['trialDays'] as num?)?.toInt() ?? 15,
      activationDate: parseFirestoreDate(data['activationDate']),
      expiryDate: parseFirestoreDate(data['expiryDate']),
      machineId: data['machineId'] as String?,
      deviceName: data['deviceName'] as String?,
      customerId: data['customerId'] as String?,
      notes: data['notes'] as String?,
      createdAt: parseFirestoreDate(data['createdAt']) ?? DateTime.now().toUtc(),
      updatedAt: parseFirestoreDate(data['updatedAt']) ?? DateTime.now().toUtc(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        licenseKey,
        status,
        licenseType,
        machineId,
        expiryDate,
        updatedAt,
      ];
}
