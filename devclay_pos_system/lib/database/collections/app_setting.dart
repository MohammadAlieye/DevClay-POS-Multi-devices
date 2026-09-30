import 'package:isar_community/isar.dart';

part 'app_setting.g.dart';

@collection
class AppSetting {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late String businessName;
  late String businessPhone;
  late String businessEmail;
  late String businessAddress;
  late String taxNumber;

  late double defaultTaxRate;
  late bool defaultTaxInclusive;

  /// Master switch: when false, tax is hidden in products/POS and treated as 0.
  bool taxEnabled = true;

  late String receiptFooter;
  late bool showBusinessInfoOnReceipt;

  /// Receipt heading, e.g. "Sale Receipt".
  String receiptTitle = 'Sale Receipt';

  /// Absolute path to logo image under app documents (optional).
  String? receiptLogoPath;

  /// Multi-line terms shown near the bottom of the receipt.
  String receiptTerms = '';

  /// Optional counter label printed on receipts.
  String receiptCounterName = 'Counter 1';

  /// Optional POS / system label printed on receipts.
  String receiptSystemName = 'POS-01';

  /// When true, print FBR fee + verification block (integration later).
  bool fbrInvoiceEnabled = false;

  /// When enabled, cashier accounts must open a drawer shift before selling.
  bool cashierShiftRequired = false;

  late String printerName;
  late bool autoPrintReceipt;
  late int paperWidthMm;

  /// Printable content width in mm (typically 68–76 for 80 mm paper).
  /// Keeps layout inside the real printable area of thermal printers.
  int receiptContentWidthMm = 72;

  /// Horizontal alignment of receipt content on the roll: `left` or `center`.
  String receiptPrintAlign = 'center';

  DateTime? lastBackupAt;
  String? lastBackupPath;

  /// Comma-separated product units (pcs, half, karahi, …).
  String productUnitsCsv = '';

  /// Comma-separated product categories managed in Settings.
  String productCategoriesCsv = '';

  /// light | dark | system
  String themeMode = 'light';

  /// Accent preset id (ocean, sky_green, emerald, …).
  String accentPreset = 'ocean';

  /// Primary / chrome preset id (slate, navy, forest, …).
  String primaryPreset = 'slate';

  /// Internal database initialization marker. This must never be stored in
  /// user-clearable notifications because losing it could trigger reseeding.
  String seedRevision = '';

  /// One-time migration: kg/L stock converted to gram/ml base units.
  bool stockBaseUnitsMigrated = false;

  /// Store vertical: pharmacy | clothing | milk | super_store | general_retail.
  String storeProfile = '';

  /// True after the store-profile wizard (or Settings) has been completed.
  bool storeProfileConfigured = false;

  /// Feature flags (seeded from profile; overridable in Settings later).
  bool enableBatchesExpiry = true;
  bool batchesExpiryRequired = false;
  bool enableProductVariants = false;
  bool enableVariableMeasureSales = true;
  bool preferVolumeUnits = false;

  /// Preferred [LabelStoreType] name for labels module.
  String preferredLabelStoreType = 'retail';
}
