import 'package:isar_community/isar.dart';

part 'product_batch.g.dart';

/// One stock lot for a product, with its own expiry and quantity.
@collection
class ProductBatch {
  Id id = Isar.autoIncrement;

  @Index()
  late int productId;

  /// Optional lot / batch code from supplier packaging.
  String? batchCode;

  DateTime? manufactureDate;
  DateTime? expiryDate;

  late int quantity;

  /// Unit cost when this lot was received (optional).
  double unitCost = 0;

  @Index()
  late DateTime receivedAt;

  String? note;
}
