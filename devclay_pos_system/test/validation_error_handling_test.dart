import 'package:devclay_pos_system/modules/products/domain/entities/product_item.dart';
import 'package:devclay_pos_system/modules/products/domain/repositories/products_repository.dart';
import 'package:devclay_pos_system/modules/products/presentation/bloc/products_bloc.dart';
import 'package:devclay_pos_system/utils/user_facing_error.dart';
import 'package:flutter_test/flutter_test.dart';

class _RejectingProductsRepository implements ProductsRepository {
  static const product = ProductItem(
    id: 1,
    sku: 'SKU-001',
    barcode: '100001',
    name: 'Tea',
    category: 'Grocery',
    unit: 'pcs',
    sellingPrice: 100,
    purchasePrice: 80,
    taxRate: 0,
    taxInclusive: true,
    stock: 10,
    isActive: true,
  );

  @override
  Future<List<String>> getCategories() async => const ['Grocery'];

  @override
  Future<List<ProductItem>> getProducts({String query = ''}) async => const [
    product,
  ];

  @override
  Future<ProductItem> createProduct(ProductDraft draft) {
    throw ArgumentError('This SKU is already used.');
  }

  @override
  Future<ProductItem> updateProduct(int id, ProductDraft draft) {
    throw ArgumentError('This SKU is already used.');
  }

  @override
  Future<void> deleteProduct(int id) async {}

  @override
  Future<void> restoreProduct(int id) async {}
}

void main() {
  test('technical exception prefixes are removed from cashier messages', () {
    expect(
      userFacingError(ArgumentError('Enter a valid amount.')),
      'Enter a valid amount.',
    );
    expect(
      userFacingError(StateError('Account not found.')),
      'Account not found.',
    );
  });

  test('product save validation error preserves the loaded screen', () async {
    final bloc = ProductsBloc(_RejectingProductsRepository());
    addTearDown(bloc.close);

    final loadedFuture = bloc.stream.firstWhere(
      (state) => state is ProductsLoaded,
    );
    bloc.add(const ProductsStarted());
    await loadedFuture;

    final errorFuture = bloc.stream.firstWhere(
      (state) => state is ProductsLoaded && state.message != null,
    );
    bloc.add(
      const ProductSaved(
        draft: ProductDraft(
          sku: 'SKU-001',
          barcode: '100002',
          name: 'Coffee',
          category: 'Grocery',
          unit: 'pcs',
          taxRate: 0,
          taxInclusive: true,
          isActive: true,
        ),
      ),
    );

    final result = await errorFuture as ProductsLoaded;
    expect(result.products, isNotEmpty);
    expect(result.message, 'This SKU is already used.');
    expect(bloc.state, isA<ProductsLoaded>());
  });
}
