import '../entities/product_item.dart';

abstract class ProductsRepository {
  Future<List<ProductItem>> getProducts({String query = ''});

  Future<List<String>> getCategories();

  Future<ProductItem> createProduct(ProductDraft draft);

  Future<ProductItem> updateProduct(int id, ProductDraft draft);

  Future<void> deleteProduct(int id);
  Future<void> restoreProduct(int id);
}
