enum LicenseType {
  trial,
  monthly,
  yearly,
  lifetime,
  custom;

  String get firestoreValue => switch (this) {
        LicenseType.trial => 'Trial',
        LicenseType.monthly => 'Monthly',
        LicenseType.yearly => 'Yearly',
        LicenseType.lifetime => 'Lifetime',
        LicenseType.custom => 'Custom',
      };

  static LicenseType fromFirestore(String? value) {
    switch (value?.trim().toLowerCase()) {
      case 'monthly':
        return LicenseType.monthly;
      case 'yearly':
        return LicenseType.yearly;
      case 'lifetime':
        return LicenseType.lifetime;
      case 'custom':
        return LicenseType.custom;
      case 'trial':
      default:
        return LicenseType.trial;
    }
  }

  Duration? get defaultDuration => switch (this) {
        LicenseType.monthly => const Duration(days: 30),
        LicenseType.yearly => const Duration(days: 365),
        LicenseType.lifetime => null,
        LicenseType.trial => null,
        LicenseType.custom => null,
      };

  bool get requiresCustomDays =>
      this == LicenseType.trial || this == LicenseType.custom;
}
