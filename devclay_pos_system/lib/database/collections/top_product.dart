import 'package:isar_community/isar.dart';

part 'top_product.g.dart';

@collection
class TopProduct {
  Id id = Isar.autoIncrement;

  late String name;
  late String sku;
  late int unitsSold;
  late double revenue;
  late int rank;
}
