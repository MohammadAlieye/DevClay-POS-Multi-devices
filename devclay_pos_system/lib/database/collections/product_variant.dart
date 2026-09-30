import 'package:isar_community/isar.dart';

part 'product_variant.g.dart';

/// Size/color (or similar) variant of a parent [Product].
@collection
class ProductVariant {
  Id id = Isar.autoIncrement;

  @Index()
  late int productId;

  late String size;
  late String color;

  @Index()
  String? barcode;

  String? sku;

  late int stock;

  /// When > 0, overrides parent product selling price for this variant.
  double priceOverride = 0;

  late bool isActive;

  DateTime? deletedAt;
}
