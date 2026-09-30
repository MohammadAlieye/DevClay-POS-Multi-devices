import '../domain/entities/settings_entities.dart';
import '../domain/repositories/settings_repository.dart';
import 'datasources/settings_local_datasource.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl(this._local);

  final SettingsLocalDataSource _local;

  @override
  Future<AppSettingsSnapshot> getSettings() => _local.getSettings();

  @override
  Future<AppSettingsSnapshot> saveSettings(AppSettingsDraft draft) {
    return _local.saveSettings(draft);
  }

  @override
  Future<void> saveThemePreference({
    required String themeMode,
    required String accentPreset,
    required String primaryPreset,
  }) {
    return _local.saveThemePreference(
      themeMode: themeMode,
      accentPreset: accentPreset,
      primaryPreset: primaryPreset,
    );
  }

  @override
  Future<AppSettingsSnapshot> exportBackup() => _local.exportBackup();

  @override
  Future<AppSettingsSnapshot> importBackup() => _local.importBackup();

  @override
  Future<void> clearDatabaseWithBackup() => _local.clearDatabaseWithBackup();

  @override
  ReceiptBranding receiptBranding(AppSettingsSnapshot settings) {
    return ReceiptBranding(
      showBusinessInfo: settings.showBusinessInfoOnReceipt,
      receiptTitle: settings.receiptTitle,
      fbrInvoiceEnabled: settings.fbrInvoiceEnabled,
      businessName: settings.businessName,
      businessAddress: settings.businessAddress,
      businessPhone: settings.businessPhone,
      taxNumber: settings.taxNumber,
      receiptFooter: settings.receiptFooter,
      receiptLogoPath: settings.receiptLogoPath,
      receiptTerms: settings.receiptTerms,
      receiptCounterName: settings.receiptCounterName,
      receiptSystemName: settings.receiptSystemName,
    );
  }
}
