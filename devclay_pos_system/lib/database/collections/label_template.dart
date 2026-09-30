import 'package:isar_community/isar.dart';

part 'label_template.g.dart';

@collection
class LabelTemplate {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String key;

  late String name;
  late String storeType;
  late String description;

  late double widthMm;
  late double heightMm;
  late String symbology;
  late String payloadFormat;

  late bool showProductName;
  late bool showSku;
  late bool showPrice;
  late bool showBrand;
  late bool showUnit;
  late bool showCategory;
  late bool showExpirySlot;
  late bool showBatchSlot;

  late int defaultCopies;
  late bool isDefault;
  late bool isBuiltIn;
  late DateTime updatedAt;
}
