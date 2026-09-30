import '../../modules/labels/domain/entities/label_entities.dart';
import '../../widgets/field_limits.dart';

/// Store vertical profile ids persisted on [AppSetting.storeProfile].
enum StoreProfileId {
  pharmacy,
  clothing,
  milk,
  superStore,
  generalRetail;

  String get storageKey => switch (this) {
        StoreProfileId.pharmacy => 'pharmacy',
        StoreProfileId.clothing => 'clothing',
        StoreProfileId.milk => 'milk',
        StoreProfileId.superStore => 'super_store',
        StoreProfileId.generalRetail => 'general_retail',
      };

  String get displayName => switch (this) {
        StoreProfileId.pharmacy => 'Pharmacy',
        StoreProfileId.clothing => 'Clothing',
        StoreProfileId.milk => 'Milk shop',
        StoreProfileId.superStore => 'Super store',
        StoreProfileId.generalRetail => 'General retail',
      };

  String get description => switch (this) {
        StoreProfileId.pharmacy =>
          'Medicines with batch and expiry tracking (FEFO).',
        StoreProfileId.clothing =>
          'Apparel with size and color variants.',
        StoreProfileId.milk =>
          'Dairy with volume sales (L / ml) and short expiry.',
        StoreProfileId.superStore =>
          'Broad catalog covering grocery and more.',
        StoreProfileId.generalRetail =>
          'Standard retail defaults for general shops.',
      };

  static StoreProfileId fromStorage(String? raw) {
    final key = (raw ?? '').trim().toLowerCase();
    return switch (key) {
      'pharmacy' => StoreProfileId.pharmacy,
      'clothing' => StoreProfileId.clothing,
      'milk' => StoreProfileId.milk,
      'super_store' || 'superstore' => StoreProfileId.superStore,
      'general_retail' || 'general' || 'retail' => StoreProfileId.generalRetail,
      _ => StoreProfileId.generalRetail,
    };
  }
}

/// Feature flags derived from a store profile (overridable on AppSetting).
class StoreProfileFlags {
  const StoreProfileFlags({
    required this.enableBatchesExpiry,
    required this.batchesExpiryRequired,
    required this.enableProductVariants,
    required this.enableVariableMeasureSales,
    required this.preferVolumeUnits,
  });

  final bool enableBatchesExpiry;
  final bool batchesExpiryRequired;
  final bool enableProductVariants;
  final bool enableVariableMeasureSales;
  final bool preferVolumeUnits;
}

/// Static registry of defaults per store profile.
class StoreProfileDefinition {
  const StoreProfileDefinition({
    required this.id,
    required this.categories,
    required this.extraUnits,
    required this.flags,
    required this.labelStoreType,
  });

  final StoreProfileId id;
  final List<String> categories;
  final List<String> extraUnits;
  final StoreProfileFlags flags;
  final LabelStoreType labelStoreType;

  List<String> get units =>
      DefaultProductUnits.mergeWithBase(extraUnits);
}

/// Clothing size presets (editable later in product editor).
abstract final class ClothingSizePresets {
  static const List<String> apparel = [
    'XS',
    'S',
    'M',
    'L',
    'XL',
    'XXL',
  ];

  static const List<String> shoes = [
    '36',
    '37',
    '38',
    '39',
    '40',
    '41',
    '42',
    '43',
    '44',
    '45',
  ];

  static List<String> get all => [...apparel, ...shoes];
}

abstract final class StoreProfiles {
  static const List<StoreProfileId> allIds = StoreProfileId.values;

  static StoreProfileDefinition of(StoreProfileId id) => switch (id) {
        StoreProfileId.pharmacy => _pharmacy,
        StoreProfileId.clothing => _clothing,
        StoreProfileId.milk => _milk,
        StoreProfileId.superStore => _superStore,
        StoreProfileId.generalRetail => _generalRetail,
      };

  static final StoreProfileDefinition _pharmacy = StoreProfileDefinition(
    id: StoreProfileId.pharmacy,
    categories: const [
      'Medicines',
      'OTC',
      'Personal Care',
      'Baby',
      'Other',
    ],
    extraUnits: const ['pack', 'strip', 'bottle'],
    flags: const StoreProfileFlags(
      enableBatchesExpiry: true,
      batchesExpiryRequired: true,
      enableProductVariants: false,
      enableVariableMeasureSales: false,
      preferVolumeUnits: false,
    ),
    labelStoreType: LabelStoreType.pharmacy,
  );

  static final StoreProfileDefinition _clothing = StoreProfileDefinition(
    id: StoreProfileId.clothing,
    categories: const [
      'Men',
      'Women',
      'Kids',
      'Accessories',
      'Other',
    ],
    extraUnits: const ['pair', 'set'],
    flags: const StoreProfileFlags(
      enableBatchesExpiry: false,
      batchesExpiryRequired: false,
      enableProductVariants: true,
      enableVariableMeasureSales: false,
      preferVolumeUnits: false,
    ),
    labelStoreType: LabelStoreType.clothing,
  );

  static final StoreProfileDefinition _milk = StoreProfileDefinition(
    id: StoreProfileId.milk,
    categories: const [
      'Fresh milk',
      'Yogurt',
      'Butter',
      'Cheese',
      'Other dairy',
    ],
    extraUnits: const ['bottle', 'pack'],
    flags: const StoreProfileFlags(
      enableBatchesExpiry: true,
      batchesExpiryRequired: false,
      enableProductVariants: false,
      enableVariableMeasureSales: true,
      preferVolumeUnits: true,
    ),
    labelStoreType: LabelStoreType.grocery,
  );

  static final StoreProfileDefinition _superStore = StoreProfileDefinition(
    id: StoreProfileId.superStore,
    categories: const [
      'Grocery',
      'Beverages',
      'Dairy',
      'Snacks',
      'Personal Care',
      'Household',
      'Electronics',
      'Clothing basics',
      'Other',
    ],
    extraUnits: const ['pack', 'box'],
    flags: const StoreProfileFlags(
      enableBatchesExpiry: true,
      batchesExpiryRequired: false,
      enableProductVariants: false,
      enableVariableMeasureSales: true,
      preferVolumeUnits: false,
    ),
    labelStoreType: LabelStoreType.retail,
  );

  static final StoreProfileDefinition _generalRetail = StoreProfileDefinition(
    id: StoreProfileId.generalRetail,
    categories: DefaultProductCategories.all,
    extraUnits: DefaultProductUnits.customDefaults,
    flags: const StoreProfileFlags(
      enableBatchesExpiry: true,
      batchesExpiryRequired: false,
      enableProductVariants: false,
      enableVariableMeasureSales: true,
      preferVolumeUnits: false,
    ),
    labelStoreType: LabelStoreType.retail,
  );
}
