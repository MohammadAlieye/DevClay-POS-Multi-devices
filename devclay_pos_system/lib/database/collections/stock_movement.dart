import 'package:isar_community/isar.dart';

part 'stock_movement.g.dart';

@collection
class StockMovement {
  Id id = Isar.autoIncrement;

  @Index()
  late int productId;

  late String productName;
  late String productSku;

  /// adjustment | opening | sale
  late String type;

  late int quantityChange;
  late int quantityAfter;
  String? note;

  @Index()
  late DateTime createdAt;
}
