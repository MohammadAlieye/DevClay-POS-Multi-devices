import 'package:isar_community/isar.dart';

part 'low_stock_item.g.dart';

@collection
class LowStockItem {
  Id id = Isar.autoIncrement;

  late String name;
  late String sku;
  late int quantity;
  late int reorderLevel;
}
