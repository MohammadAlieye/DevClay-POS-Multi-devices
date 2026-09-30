import 'package:isar_community/isar.dart';

part 'label_print_job.g.dart';

@collection
class LabelPrintJob {
  Id id = Isar.autoIncrement;

  late DateTime printedAt;
  late String templateName;
  late String storeType;
  late String payloadFormat;
  late int productCount;
  late int labelCount;
  late String status;
  late String itemsSummary;
  String? note;
}
