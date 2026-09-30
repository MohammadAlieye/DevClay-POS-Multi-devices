import '../../../products/domain/entities/product_item.dart';
import '../entities/label_entities.dart';

abstract class LabelsRepository {
  Future<List<LabelTemplateItem>> getTemplates();

  Future<LabelTemplateItem?> getDefaultTemplate();

  Future<LabelTemplateItem> saveTemplate(LabelTemplateDraft draft, {int? id});

  Future<void> deleteTemplate(int id);

  Future<List<LabelPrintJobItem>> getPrintHistory({int limit = 50});

  Future<List<ProductItem>> getProducts({String query = ''});

  Future<List<String>> getCategories();

  Future<LabelPrintResult> printLabels({
    required LabelTemplateItem template,
    required List<LabelProductLine> lines,
    required String storeName,
    String? printerName,
  });

  LabelProductLine productToLine(ProductItem product, {int copies = 1});
}
