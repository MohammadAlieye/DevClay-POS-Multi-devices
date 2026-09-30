import 'package:equatable/equatable.dart';

import '../utils/date_utils.dart';

class LicenseCustomer extends Equatable {
  const LicenseCustomer({
    required this.id,
    required this.businessName,
    required this.ownerName,
    required this.phone,
    required this.email,
    required this.address,
    this.licenseId,
    required this.createdAt,
  });

  final String id;
  final String businessName;
  final String ownerName;
  final String phone;
  final String email;
  final String address;
  final String? licenseId;
  final DateTime createdAt;

  LicenseCustomer copyWith({
    String? id,
    String? businessName,
    String? ownerName,
    String? phone,
    String? email,
    String? address,
    String? licenseId,
    DateTime? createdAt,
    bool clearLicenseId = false,
  }) {
    return LicenseCustomer(
      id: id ?? this.id,
      businessName: businessName ?? this.businessName,
      ownerName: ownerName ?? this.ownerName,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      licenseId: clearLicenseId ? null : (licenseId ?? this.licenseId),
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'businessName': businessName,
      'ownerName': ownerName,
      'phone': phone,
      'email': email,
      'address': address,
      'licenseId': licenseId,
      'createdAt': toFirestoreDate(createdAt),
      'searchBusinessName': businessName.toLowerCase(),
      'searchOwnerName': ownerName.toLowerCase(),
      'searchPhone': phone.replaceAll(RegExp(r'\s+'), ''),
    };
  }

  factory LicenseCustomer.fromFirestore(String id, Map<String, dynamic> data) {
    return LicenseCustomer(
      id: id,
      businessName: (data['businessName'] as String?) ?? '',
      ownerName: (data['ownerName'] as String?) ?? '',
      phone: (data['phone'] as String?) ?? '',
      email: (data['email'] as String?) ?? '',
      address: (data['address'] as String?) ?? '',
      licenseId: data['licenseId'] as String?,
      createdAt: parseFirestoreDate(data['createdAt']) ?? DateTime.now().toUtc(),
    );
  }

  @override
  List<Object?> get props => [id, businessName, phone, licenseId];
}
