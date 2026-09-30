import 'package:equatable/equatable.dart';

import '../constants/license_constants.dart';

class AppSettings extends Equatable {
  const AppSettings({
    this.defaultTrialDays = LicenseConstants.defaultTrialDays,
    this.trialEnabled = true,
    this.appVersion = '1.0.0',
    this.minimumSupportedVersion = '1.0.0',
    this.maintenanceMode = false,
  });

  final int defaultTrialDays;
  final bool trialEnabled;
  final String appVersion;
  final String minimumSupportedVersion;
  final bool maintenanceMode;

  AppSettings copyWith({
    int? defaultTrialDays,
    bool? trialEnabled,
    String? appVersion,
    String? minimumSupportedVersion,
    bool? maintenanceMode,
  }) {
    return AppSettings(
      defaultTrialDays: defaultTrialDays ?? this.defaultTrialDays,
      trialEnabled: trialEnabled ?? this.trialEnabled,
      appVersion: appVersion ?? this.appVersion,
      minimumSupportedVersion:
          minimumSupportedVersion ?? this.minimumSupportedVersion,
      maintenanceMode: maintenanceMode ?? this.maintenanceMode,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'defaultTrialDays': defaultTrialDays,
      'trialEnabled': trialEnabled,
      'appVersion': appVersion,
      'minimumSupportedVersion': minimumSupportedVersion,
      'maintenanceMode': maintenanceMode,
    };
  }

  factory AppSettings.fromFirestore(Map<String, dynamic>? data) {
    if (data == null) return const AppSettings();
    return AppSettings(
      defaultTrialDays: (data['defaultTrialDays'] as num?)?.toInt() ??
          LicenseConstants.defaultTrialDays,
      trialEnabled: data['trialEnabled'] as bool? ?? true,
      appVersion: (data['appVersion'] as String?) ?? '1.0.0',
      minimumSupportedVersion:
          (data['minimumSupportedVersion'] as String?) ?? '1.0.0',
      maintenanceMode: data['maintenanceMode'] as bool? ?? false,
    );
  }

  @override
  List<Object?> get props => [
        defaultTrialDays,
        trialEnabled,
        appVersion,
        minimumSupportedVersion,
        maintenanceMode,
      ];
}
