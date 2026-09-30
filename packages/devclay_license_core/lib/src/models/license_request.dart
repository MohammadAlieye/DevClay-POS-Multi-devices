import 'package:equatable/equatable.dart';

import '../utils/date_utils.dart';

enum LicenseRequestType {
  renew,
  newLicense,
  support;

  String get firestoreValue => switch (this) {
        LicenseRequestType.renew => 'Renew',
        LicenseRequestType.newLicense => 'New License',
        LicenseRequestType.support => 'Support',
      };

  static LicenseRequestType fromFirestore(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'new license':
      case 'new':
        return LicenseRequestType.newLicense;
      case 'support':
        return LicenseRequestType.support;
      case 'renew':
      default:
        return LicenseRequestType.renew;
    }
  }
}

enum LicenseRequestStatus {
  pending,
  inProgress,
  resolved,
  rejected;

  String get firestoreValue => switch (this) {
        LicenseRequestStatus.pending => 'Pending',
        LicenseRequestStatus.inProgress => 'In Progress',
        LicenseRequestStatus.resolved => 'Resolved',
        LicenseRequestStatus.rejected => 'Rejected',
      };

  static LicenseRequestStatus fromFirestore(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'in progress':
        return LicenseRequestStatus.inProgress;
      case 'resolved':
        return LicenseRequestStatus.resolved;
      case 'rejected':
        return LicenseRequestStatus.rejected;
      case 'pending':
      default:
        return LicenseRequestStatus.pending;
    }
  }
}

class LicenseRequest extends Equatable {
  const LicenseRequest({
    required this.id,
    required this.type,
    required this.status,
    required this.machineId,
    this.deviceName,
    this.licenseKey,
    this.businessName,
    this.ownerName,
    this.customerId,
    this.contactPhone,
    this.contactEmail,
    this.message,
    this.adminNote,
    required this.createdAt,
    required this.updatedAt,
  });

  final String id;
  final LicenseRequestType type;
  final LicenseRequestStatus status;
  final String machineId;
  final String? deviceName;
  final String? licenseKey;
  final String? businessName;
  final String? ownerName;
  final String? customerId;
  final String? contactPhone;
  final String? contactEmail;
  final String? message;
  final String? adminNote;
  final DateTime createdAt;
  final DateTime updatedAt;

  Map<String, dynamic> toFirestore() {
    return {
      'type': type.firestoreValue,
      'status': status.firestoreValue,
      'machineId': machineId,
      'deviceName': deviceName,
      'licenseKey': licenseKey,
      'businessName': businessName,
      'ownerName': ownerName,
      'customerId': customerId,
      'contactPhone': contactPhone,
      'contactEmail': contactEmail,
      'message': message,
      'adminNote': adminNote,
      'createdAt': toFirestoreDate(createdAt),
      'updatedAt': toFirestoreDate(updatedAt),
      'searchBusinessName': (businessName ?? '').toLowerCase(),
      'searchLicenseKey': (licenseKey ?? '').toUpperCase(),
    };
  }

  factory LicenseRequest.fromFirestore(String id, Map<String, dynamic> data) {
    return LicenseRequest(
      id: id,
      type: LicenseRequestType.fromFirestore(data['type'] as String?),
      status: LicenseRequestStatus.fromFirestore(data['status'] as String?),
      machineId: (data['machineId'] as String?) ?? '',
      deviceName: data['deviceName'] as String?,
      licenseKey: data['licenseKey'] as String?,
      businessName: data['businessName'] as String?,
      ownerName: data['ownerName'] as String?,
      customerId: data['customerId'] as String?,
      contactPhone: data['contactPhone'] as String?,
      contactEmail: data['contactEmail'] as String?,
      message: data['message'] as String?,
      adminNote: data['adminNote'] as String?,
      createdAt: parseFirestoreDate(data['createdAt']) ?? DateTime.now().toUtc(),
      updatedAt: parseFirestoreDate(data['updatedAt']) ?? DateTime.now().toUtc(),
    );
  }

  LicenseRequest copyWith({
    LicenseRequestStatus? status,
    String? adminNote,
    DateTime? updatedAt,
  }) {
    return LicenseRequest(
      id: id,
      type: type,
      status: status ?? this.status,
      machineId: machineId,
      deviceName: deviceName,
      licenseKey: licenseKey,
      businessName: businessName,
      ownerName: ownerName,
      customerId: customerId,
      contactPhone: contactPhone,
      contactEmail: contactEmail,
      message: message,
      adminNote: adminNote ?? this.adminNote,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [id, status, type, licenseKey, updatedAt];
}
