import 'package:isar_community/isar.dart';

part 'stock_write_off.g.dart';

@collection
class StockWriteOff {
  Id id = Isar.autoIncrement;

  @Index()
  late int productId;
  late String productName;
  late String productSku;
  late int quantity;
  late double valueAtCost;
  late String reason;
  late String allocationsJson;
  int? userId;
  String? userName;
  String? note;

  @Index()
  late DateTime createdAt;
}
