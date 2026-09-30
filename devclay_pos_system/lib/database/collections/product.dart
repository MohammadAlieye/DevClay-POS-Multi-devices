import 'package:isar_community/isar.dart';

part 'product.g.dart';

@collection
class Product {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String sku;

  @Index()
  late String barcode;

  late String name;
  late String category;
  String? brand;
  String? manufacturer;

  /// Pharmacy: strength / dosage text (e.g. 500mg).
  String? strength;

  /// When true, stock is tracked on [ProductVariant] rows.
  bool hasVariants = false;

  /// Smallest stock/sale unit, e.g. Item, Packet, Bottle.
  String? unit;

  /// piece | weight | volume — stock counted in pcs, grams, or milliliters.
  String sellType = 'piece';
  String boxUnit = 'Box';
  int itemsPerBox = 0;
  String cartonUnit = 'Carton';
  int boxesPerCarton = 0;
  late double sellingPrice;
  double wholesalePrice = 0;
  late double purchasePrice;
  late double taxRate;
  late bool taxInclusive;
  late int stock;

  /// Units at/below which this product is low stock. `0` = use system default.
  int lowStockThreshold = 0;
  late bool isActive;
  DateTime? manufactureDate;
  DateTime? expiryDate;

  /// Absolute path to a local image file under app documents.
  String? imagePath;

  /// When set, product is in the Recycle Bin (hidden from catalog/POS).
  DateTime? deletedAt;
}
