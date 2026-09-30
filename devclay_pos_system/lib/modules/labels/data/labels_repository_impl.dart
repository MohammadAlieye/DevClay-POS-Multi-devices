import '../../products/domain/entities/product_item.dart';
import '../../products/domain/repositories/products_repository.dart';
import '../domain/entities/label_entities.dart';
import '../domain/repositories/labels_repository.dart';
import 'datasources/labels_local_datasource.dart';

class LabelsRepositoryImpl implements LabelsRepository {
  LabelsRepositoryImpl(this._local, this._products);

  final LabelsLocalDataSource _local;
  final ProductsRepository _products;

  @override
  Future<List<LabelTemplateItem>> getTemplates() => _local.getTemplates();

  @override
  Future<LabelTemplateItem?> getDefaultTemplate() => _local.getDefaultTemplate();

  @override
  Future<LabelTemplateItem> saveTemplate(
    LabelTemplateDraft draft, {
    int? id,
  }) {
    return _local.saveTemplate(draft, id: id);
  }

  @override
  Future<void> deleteTemplate(int id) => _local.deleteTemplate(id);

  @override
  Future<List<LabelPrintJobItem>> getPrintHistory({int limit = 50}) {
    return _local.getPrintHistory(limit: limit);
  }

  @override
  Future<List<ProductItem>> getProducts({String query = ''}) {
    return _products.getProducts(query: query);
  }

  @override
  Future<List<String>> getCategories() => _products.getCategories();

  @override
  Future<LabelPrintResult> printLabels({
    required LabelTemplateItem template,
    required List<LabelProductLine> lines,
    required String storeName,
    String? printerName,
  }) {
    return _local.printLabels(
      template: template,
      lines: lines,
      storeName: storeName,
      printerName: printerName,
    );
  }

  @override
  LabelProductLine productToLine(ProductItem product, {int copies = 1}) {
    return _local.productToLine(product, copies: copies);
  }
}
