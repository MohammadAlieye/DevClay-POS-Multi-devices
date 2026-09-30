import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../../../../database/collections/app_setting.dart';
import '../../../../database/collections/store.dart';
import '../../../../database/isar_service.dart';
import '../../../../database/seed_data.dart';
import '../../domain/entities/settings_entities.dart';
import '../../../../widgets/field_limits.dart';

class SettingsLocalDataSource {
  SettingsLocalDataSource(this._isarService);

  static const String settingsKey = 'default';
  static const String isarFileName = 'devclay_pos.isar';

  /// Human-readable stamp for backup filenames, e.g. `19-Aug-2026_10-57AM`.
  static String backupFileStamp([DateTime? when]) {
    return DateFormat('dd-MMM-yyyy_hh-mma').format(when ?? DateTime.now());
  }

  static String backupFileName(String kind, [DateTime? when]) {
    return 'devclay_pos_${kind}_${backupFileStamp(when)}.isar';
  }

  final IsarService _isarService;

  Future<AppSettingsSnapshot> getSettings() async {
    final record = await _getOrCreateRecord();
    final store = await _getPrimaryStore();
    return _mapSettings(record, store: store);
  }

  Future<AppSettingsSnapshot> saveSettings(AppSettingsDraft draft) async {
    final businessName = draft.businessName.trim();
    if (businessName.isEmpty) {
      throw ArgumentError('Business name is required.');
    }
    if (draft.defaultTaxRate < 0 || draft.defaultTaxRate > 100) {
      throw ArgumentError('Default tax rate must be between 0 and 100.');
    }
    final productUnits = DefaultProductUnits.mergeWithBase(
      draft.productUnits
          .map((unit) => unit.trim())
          .where((unit) => unit.isNotEmpty),
    );
    if (productUnits.isEmpty) {
      throw ArgumentError('At least one product unit is required.');
    }
    final productCategories = DefaultProductCategories.fromCsv(
      DefaultProductCategories.toCsv(draft.productCategories),
    );
    if (draft.paperWidthMm != 58 && draft.paperWidthMm != 80) {
      throw ArgumentError('Paper width must be 58 mm or 80 mm.');
    }
    final contentWidth = draft.receiptContentWidthMm;
    if (contentWidth < 40 || contentWidth > draft.paperWidthMm) {
      throw ArgumentError(
        'Content width must be between 40 mm and paper width.',
      );
    }
    final printAlign = draft.receiptPrintAlign.trim().toLowerCase() == 'left'
        ? 'left'
        : 'center';
    final receiptTitle = draft.receiptTitle.trim().isEmpty
        ? 'Sale Receipt'
        : draft.receiptTitle.trim();

    final isar = _isarService.instance;
    final record = await _getOrCreateRecord();
    final store = await _getPrimaryStore();

    await isar.writeTxn(() async {
      record
        ..businessName = businessName
        ..businessPhone = draft.businessPhone.trim()
        ..businessEmail = draft.businessEmail.trim()
        ..businessAddress = draft.businessAddress.trim()
        ..taxNumber = draft.taxNumber.trim()
        ..defaultTaxRate = draft.defaultTaxRate
        ..defaultTaxInclusive = draft.defaultTaxInclusive
        ..taxEnabled = draft.taxEnabled
        ..receiptFooter = draft.receiptFooter.trim()
        ..showBusinessInfoOnReceipt = draft.showBusinessInfoOnReceipt
        ..receiptTitle = receiptTitle
        ..receiptLogoPath = draft.receiptLogoPath
        ..receiptTerms = draft.receiptTerms.trim()
        ..receiptCounterName = draft.receiptCounterName.trim()
        ..receiptSystemName = draft.receiptSystemName.trim()
        ..fbrInvoiceEnabled = draft.fbrInvoiceEnabled
        ..printerName = draft.printerName.trim()
        ..autoPrintReceipt = draft.autoPrintReceipt
        ..paperWidthMm = draft.paperWidthMm
        ..receiptContentWidthMm = contentWidth
        ..receiptPrintAlign = printAlign
        ..productUnitsCsv = DefaultProductUnits.toCsv(productUnits)
        ..productCategoriesCsv =
            DefaultProductCategories.toCsv(productCategories)
        ..themeMode = draft.themeMode
        ..accentPreset = draft.accentPreset
        ..primaryPreset = draft.primaryPreset;
      await isar.appSettings.put(record);

      final primary =
          store ??
          (Store()
            ..code = 'MAIN'
            ..isActive = true);
      primary
        ..name = businessName
        ..city = draft.businessCity.trim()
        ..address = draft.businessAddress.trim();
      await isar.stores.put(primary);
    });

    final updatedStore = await _getPrimaryStore();
    return _mapSettings(record, store: updatedStore);
  }

  Future<AppSettingsSnapshot> exportBackup() async {
    final destPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save DevClayPOS backup',
      fileName: backupFileName('backup'),
      type: FileType.custom,
      allowedExtensions: const ['isar'],
    );
    if (destPath == null) {
      throw ArgumentError('Backup cancelled.');
    }

    await _copyDatabaseSafely(destPath);

    final isar = _isarService.instance;
    final record = await _getOrCreateRecord();
    await isar.writeTxn(() async {
      record
        ..lastBackupAt = DateTime.now()
        ..lastBackupPath = destPath;
      await isar.appSettings.put(record);
    });

    final store = await _getPrimaryStore();
    return _mapSettings(record, store: store);
  }

  Future<AppSettingsSnapshot> importBackup() async {
    final result = await FilePicker.platform.pickFiles(
      dialogTitle: 'Import DevClayPOS backup',
      type: FileType.custom,
      allowedExtensions: const ['isar'],
      withData: false,
    );
    if (result == null || result.files.isEmpty) {
      throw ArgumentError('Import cancelled.');
    }

    final path = result.files.single.path;
    if (path == null || path.trim().isEmpty) {
      throw ArgumentError('Could not read the selected backup file.');
    }

    final backup = File(path);
    await _isarService.restoreFromBackupFile(backup);

    final record = await _getOrCreateRecord();
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      record
        ..lastBackupAt = DateTime.now()
        ..lastBackupPath = path;
      await isar.appSettings.put(record);
    });

    final store = await _getPrimaryStore();
    return _mapSettings(record, store: store);
  }

  Future<void> saveThemePreference({
    required String themeMode,
    required String accentPreset,
    required String primaryPreset,
  }) async {
    final isar = _isarService.instance;
    final record = await _getOrCreateRecord();
    await isar.writeTxn(() async {
      record
        ..themeMode = themeMode
        ..accentPreset = accentPreset
        ..primaryPreset = primaryPreset;
      await isar.appSettings.put(record);
    });
  }

  Future<void> clearDatabaseWithBackup() async {
    // User must save a backup file first. Cancelled backup aborts clear.
    final destPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Save backup before clearing data',
      fileName: backupFileName('before-clear'),
      type: FileType.custom,
      allowedExtensions: const ['isar'],
    );
    if (destPath == null) {
      throw ArgumentError('Backup cancelled. No data was removed.');
    }

    await _copyDatabaseSafely(destPath);
    final backup = File(destPath);
    if (!await backup.exists() || await backup.length() < 64) {
      throw StateError(
        'Safety backup could not be verified. No data was removed.',
      );
    }

    await SeedData.resetCustomerDatabase(_isarService.instance);

    final isar = _isarService.instance;
    final record = await _getOrCreateRecord();
    await isar.writeTxn(() async {
      record
        ..lastBackupAt = DateTime.now()
        ..lastBackupPath = destPath;
      await isar.appSettings.put(record);
    });
  }

  Future<void> _copyDatabaseSafely(String destinationPath) async {
    final dir = await getApplicationDocumentsDirectory();
    final source = File('${dir.path}/$isarFileName');
    if (!await source.exists()) {
      throw StateError('Database file not found.');
    }

    Object? copyError;
    await _isarService.close();
    try {
      await source.copy(destinationPath);
    } catch (error) {
      copyError = error;
    } finally {
      await _isarService.open();
    }
    if (copyError != null) {
      throw StateError('Backup failed. No data was removed: $copyError');
    }
  }

  Future<Store?> _getPrimaryStore() async {
    final stores = await _isarService.instance.stores
        .filter()
        .isActiveEqualTo(true)
        .findAll();
    if (stores.isEmpty) return null;
    stores.sort((a, b) => a.id.compareTo(b.id));
    return stores.first;
  }

  Future<AppSetting> _getOrCreateRecord() async {
    final isar = _isarService.instance;
    final existing = await isar.appSettings
        .filter()
        .keyEqualTo(settingsKey)
        .findFirst();
    if (existing != null) {
      await _ensureReceiptDefaults(existing);
      return existing;
    }

    late AppSetting created;
    await isar.writeTxn(() async {
      created = AppSetting()
        ..key = settingsKey
        ..businessName = 'My Store'
        ..businessPhone = ''
        ..businessEmail = ''
        ..businessAddress = ''
        ..taxNumber = ''
        ..defaultTaxRate = 17
        ..defaultTaxInclusive = true
        ..taxEnabled = true
        ..receiptFooter = 'Thank you for shopping with us!'
        ..showBusinessInfoOnReceipt = true
        ..receiptTitle = 'Sale Receipt'
        ..receiptLogoPath = null
        ..receiptTerms = DefaultReceiptTerms.text
        ..receiptCounterName = 'Counter 1'
        ..receiptSystemName = 'POS-01'
        ..fbrInvoiceEnabled = false
        ..printerName = 'Default thermal printer'
        ..autoPrintReceipt = false
        ..paperWidthMm = 80
        ..receiptContentWidthMm = 72
        ..receiptPrintAlign = 'center'
        ..productUnitsCsv = DefaultProductUnits.toCsv(DefaultProductUnits.all)
        ..productCategoriesCsv =
            DefaultProductCategories.toCsv(DefaultProductCategories.all)
        ..themeMode = 'light'
        ..accentPreset = 'ocean'
        ..primaryPreset = 'slate';
      await isar.appSettings.put(created);
    });
    return created;
  }

  Future<void> _ensureReceiptDefaults(AppSetting record) async {
    var changed = false;
    if (record.receiptTitle.trim().isEmpty) {
      record.receiptTitle = 'Sale Receipt';
      changed = true;
    }
    if (record.receiptTerms.trim().isEmpty) {
      record.receiptTerms = DefaultReceiptTerms.text;
      changed = true;
    }
    if (record.productUnitsCsv.trim().isEmpty) {
      // Leave empty until store profile wizard seeds units.
    } else {
      final merged = DefaultProductUnits.fromCsv(record.productUnitsCsv);
      final mergedCsv = DefaultProductUnits.toCsv(merged);
      if (mergedCsv != record.productUnitsCsv) {
        record.productUnitsCsv = mergedCsv;
        changed = true;
      }
    }
    // Do not auto-fill grocery categories — store profile wizard owns defaults.
    if (record.receiptContentWidthMm <= 0 ||
        record.receiptContentWidthMm > record.paperWidthMm) {
      record.receiptContentWidthMm = record.paperWidthMm >= 80 ? 72 : 48;
      changed = true;
    }
    final align = record.receiptPrintAlign.trim().toLowerCase();
    if (align != 'left' && align != 'center') {
      record.receiptPrintAlign = 'center';
      changed = true;
    }
    if (!changed) return;
    await _isarService.instance.writeTxn(() async {
      await _isarService.instance.appSettings.put(record);
    });
  }

  AppSettingsSnapshot _mapSettings(AppSetting record, {Store? store}) {
    final storeName = store?.name.trim();
    final useStoreName = storeName != null && storeName.isNotEmpty;
    return AppSettingsSnapshot(
      businessName: useStoreName ? storeName : record.businessName,
      businessCity: store?.city ?? '',
      businessPhone: record.businessPhone,
      businessEmail: record.businessEmail,
      businessAddress: store != null && store.address.trim().isNotEmpty
          ? store.address
          : record.businessAddress,
      taxNumber: record.taxNumber,
      defaultTaxRate: record.defaultTaxRate,
      defaultTaxInclusive: record.defaultTaxInclusive,
      taxEnabled: record.taxEnabled,
      receiptFooter: record.receiptFooter,
      showBusinessInfoOnReceipt: record.showBusinessInfoOnReceipt,
      receiptTitle: record.receiptTitle.trim().isEmpty
          ? 'Sale Receipt'
          : record.receiptTitle,
      receiptLogoPath: record.receiptLogoPath,
      receiptTerms: record.receiptTerms.trim().isEmpty
          ? DefaultReceiptTerms.text
          : record.receiptTerms,
      receiptCounterName: record.receiptCounterName,
      receiptSystemName: record.receiptSystemName,
      fbrInvoiceEnabled: record.fbrInvoiceEnabled,
      printerName: record.printerName,
      autoPrintReceipt: record.autoPrintReceipt,
      paperWidthMm: record.paperWidthMm,
      receiptContentWidthMm: record.receiptContentWidthMm <= 0
          ? (record.paperWidthMm >= 80 ? 72 : 48)
          : record.receiptContentWidthMm,
      receiptPrintAlign: record.receiptPrintAlign.trim().toLowerCase() == 'left'
          ? 'left'
          : 'center',
      lastBackupAt: record.lastBackupAt,
      lastBackupPath: record.lastBackupPath,
      productUnits: DefaultProductUnits.fromCsv(record.productUnitsCsv),
      productCategories:
          DefaultProductCategories.fromCsv(record.productCategoriesCsv),
      themeMode: record.themeMode.trim().isEmpty ? 'light' : record.themeMode,
      accentPreset: record.accentPreset.trim().isEmpty
          ? 'ocean'
          : record.accentPreset,
      primaryPreset: record.primaryPreset.trim().isEmpty
          ? 'slate'
          : record.primaryPreset,
    );
  }
}
