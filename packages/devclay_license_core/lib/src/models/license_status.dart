enum LicenseStatus {
  trial,
  active,
  suspended,
  expired;

  String get firestoreValue => switch (this) {
        LicenseStatus.trial => 'Trial',
        LicenseStatus.active => 'Active',
        LicenseStatus.suspended => 'Suspended',
        LicenseStatus.expired => 'Expired',
      };

  static LicenseStatus fromFirestore(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'active':
        return LicenseStatus.active;
      case 'suspended':
        return LicenseStatus.suspended;
      case 'expired':
        return LicenseStatus.expired;
      case 'trial':
      default:
        return LicenseStatus.trial;
    }
  }

  bool get allowsAccess =>
      this == LicenseStatus.trial || this == LicenseStatus.active;
}
