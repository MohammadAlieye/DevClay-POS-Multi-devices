import '../entities/settings_entities.dart';

abstract class SettingsRepository {
  Future<AppSettingsSnapshot> getSettings();

  Future<AppSettingsSnapshot> saveSettings(AppSettingsDraft draft);

  Future<void> saveThemePreference({
    required String themeMode,
    required String accentPreset,
    required String primaryPreset,
  });

  Future<AppSettingsSnapshot> exportBackup();

  Future<AppSettingsSnapshot> importBackup();

  Future<void> clearDatabaseWithBackup();

  ReceiptBranding receiptBranding(AppSettingsSnapshot settings);
}
