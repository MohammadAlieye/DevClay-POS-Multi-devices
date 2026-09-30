import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:isar_community/isar.dart';

import '../../database/collections/app_setting.dart';
import '../../database/collections/label_template.dart';
import '../../database/isar_service.dart';
import '../../database/restaurant_floor_seed.dart';
import '../../modules/labels/domain/entities/label_entities.dart';
import '../../widgets/field_limits.dart';
import '../lan_api/client/lan_api_client.dart';
import '../lan_api/lan_mode_service.dart';
import 'store_profiles.dart';

/// Reads/writes store vertical profile on [AppSetting] and applies defaults.
class StoreProfileService extends ChangeNotifier {
  StoreProfileService(this._isarService);

  static const settingsKey = 'default';

  final IsarService _isarService;
  bool _configured = false;
  bool _loaded = false;
  StoreProfileId _profileId = StoreProfileId.generalRetail;

  Isar get _isar => _isarService.instance;

  bool get isConfiguredCached => _configured;
  StoreProfileId get profileIdCached => _profileId;

  Future<void> load() async {
    final record = await _record();
    _configured = record.storeProfileConfigured;
    _profileId = StoreProfileId.fromStorage(record.storeProfile);
    _loaded = true;
    notifyListeners();
  }

  Future<AppSetting> _record() async {
    final existing = await _isar.appSettings
        .filter()
        .keyEqualTo(settingsKey)
        .findFirst();
    if (existing != null) return existing;

    late AppSetting created;
    await _isar.writeTxn(() async {
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
        ..receiptTerms = ''
        ..receiptCounterName = 'Counter 1'
        ..receiptSystemName = 'POS-01'
        ..fbrInvoiceEnabled = false
        ..printerName = 'Default thermal printer'
        ..autoPrintReceipt = false
        ..paperWidthMm = 80
        ..receiptContentWidthMm = 72
        ..receiptPrintAlign = 'center'
        ..productUnitsCsv = ''
        ..productCategoriesCsv = ''
        ..themeMode = 'light'
        ..accentPreset = 'ocean'
        ..primaryPreset = 'slate'
        ..storeProfile = ''
        ..storeProfileConfigured = false;
      await _isar.appSettings.put(created);
    });
    return created;
  }

  Future<bool> isConfigured() async {
    if (!_loaded) await load();
    return _configured;
  }

  Future<StoreProfileId> currentProfileId() async {
    final record = await _record();
    if (!record.storeProfileConfigured || record.storeProfile.trim().isEmpty) {
      return StoreProfileId.generalRetail;
    }
    return StoreProfileId.fromStorage(record.storeProfile);
  }

  Future<StoreProfileFlags> currentFlags() async {
    final record = await _record();
    final def =
        StoreProfiles.of(StoreProfileId.fromStorage(record.storeProfile));
    if (!record.storeProfileConfigured) {
      return def.flags;
    }
    return StoreProfileFlags(
      enableBatchesExpiry: record.enableBatchesExpiry,
      batchesExpiryRequired: record.batchesExpiryRequired,
      enableProductVariants: record.enableProductVariants,
      enableVariableMeasureSales: record.enableVariableMeasureSales,
      preferVolumeUnits: record.preferVolumeUnits,
    );
  }

  /// Pulls store profile flags from shop host (client mode).
  Future<void> syncFromHostProfile() async {
    final getIt = GetIt.instance;
    if (!getIt.isRegistered<LanModeService>()) return;
    final lan = getIt<LanModeService>();
    if (!lan.isClient) return;
    final profile = await getIt<LanApiClient>().fetchProfile();
    final record = await _record();
    await _isar.writeTxn(() async {
      record
        ..storeProfile = profile.storeProfile
        ..storeProfileConfigured = profile.storeProfileConfigured
        ..enableBatchesExpiry = profile.enableBatchesExpiry
        ..batchesExpiryRequired = profile.batchesExpiryRequired
        ..enableProductVariants = profile.enableProductVariants
        ..enableVariableMeasureSales = profile.enableVariableMeasureSales
        ..preferVolumeUnits = profile.preferVolumeUnits
        ..productCategoriesCsv = profile.productCategoriesCsv
        ..productUnitsCsv = profile.productUnitsCsv
        ..preferredLabelStoreType = profile.preferredLabelStoreType;
      await _isar.appSettings.put(record);
    });
    _configured = profile.storeProfileConfigured;
    _profileId = StoreProfileId.fromStorage(profile.storeProfile);
    _loaded = true;
    notifyListeners();
  }

  /// Applies profile defaults. When [resetCatalogDefaults] is true, overwrites
  /// categories/units from the profile registry.
  Future<void> applyProfile(
    StoreProfileId id, {
    bool resetCatalogDefaults = true,
    bool markConfigured = true,
  }) async {
    final getIt = GetIt.instance;
    if (getIt.isRegistered<LanModeService>() &&
        getIt<LanModeService>().isClient) {
      throw StateError('Store type is managed on the shop host PC.');
    }
    final def = StoreProfiles.of(id);
    final record = await _record();

    await _isar.writeTxn(() async {
      record
        ..storeProfile = id.storageKey
        ..storeProfileConfigured = markConfigured
        ..enableBatchesExpiry = def.flags.enableBatchesExpiry
        ..batchesExpiryRequired = def.flags.batchesExpiryRequired
        ..enableProductVariants = def.flags.enableProductVariants
        ..enableVariableMeasureSales = def.flags.enableVariableMeasureSales
        ..preferVolumeUnits = def.flags.preferVolumeUnits
        ..preferredLabelStoreType = def.labelStoreType.name
        ..enableRestaurantFloor = id == StoreProfileId.restaurant;

      final categoriesEmpty = record.productCategoriesCsv.trim().isEmpty;
      final unitsEmpty = record.productUnitsCsv.trim().isEmpty;
      if (resetCatalogDefaults || categoriesEmpty) {
        record.productCategoriesCsv =
            DefaultProductCategories.toCsv(def.categories);
      }
      if (resetCatalogDefaults || unitsEmpty) {
        record.productUnitsCsv = DefaultProductUnits.toCsv(def.units);
      }

      await _isar.appSettings.put(record);
      await _ensureDefaultLabelFor(def.labelStoreType);
    });

    if (id == StoreProfileId.restaurant) {
      await RestaurantFloorSeed.ensureSampleFloor(_isar);
    }

    _configured = markConfigured;
    _profileId = id;
    _loaded = true;
    notifyListeners();
  }

  Future<void> _ensureDefaultLabelFor(LabelStoreType type) async {
    final templates = await _isar.labelTemplates.where().findAll();
    if (templates.isEmpty) return;

    LabelTemplate? match;
    for (final t in templates) {
      if (t.storeType == type.name) {
        match = t;
        break;
      }
    }
    match ??= templates.where((t) => t.isDefault).firstOrNull ?? templates.first;

    for (final t in templates) {
      t.isDefault = t.id == match.id;
    }
    await _isar.labelTemplates.putAll(templates);
  }
}
