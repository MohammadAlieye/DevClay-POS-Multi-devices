import '../domain/entities/product_item.dart';
import '../domain/repositories/products_repository.dart';
import 'datasources/products_local_datasource.dart';

class ProductsRepositoryImpl implements ProductsRepository {
  ProductsRepositoryImpl(this._local);

  final ProductsLocalDataSource _local;

  @override
  Future<List<ProductItem>> getProducts({String query = ''}) {
    return _local.getProducts(query: query);
  }

  @override
  Future<List<String>> getCategories() => _local.getCategories();

  @override
  Future<ProductItem> createProduct(ProductDraft draft) {
    return _local.createProduct(draft);
  }

  @override
  Future<ProductItem> updateProduct(int id, ProductDraft draft) {
    return _local.updateProduct(id, draft);
  }

  @override
  Future<void> deleteProduct(int id) => _local.deleteProduct(id);

  @override
  Future<void> restoreProduct(int id) => _local.restoreProduct(id);
}
