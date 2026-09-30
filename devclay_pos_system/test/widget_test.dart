import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:devclay_pos_system/themes/app_colors.dart';
import 'package:devclay_pos_system/modules/pos/domain/entities/pos_entities.dart';
import 'package:devclay_pos_system/modules/pos/presentation/bloc/pos_bloc.dart';
import 'package:devclay_pos_system/modules/pos/domain/repositories/pos_repository.dart';
import 'package:devclay_pos_system/modules/pos/presentation/widgets/pos_product_grid.dart';
import 'package:devclay_pos_system/modules/products/presentation/widgets/product_editor_sheet.dart';
import 'package:devclay_pos_system/modules/purchases/domain/entities/purchase_entities.dart';
import 'package:devclay_pos_system/modules/purchases/presentation/widgets/purchase_editor_sheet.dart';
import 'package:devclay_pos_system/modules/sales/domain/entities/sale_entities.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _FakePosRepository implements PosRepository {
  _FakePosRepository([this.products = const []]);

  final List<PosProduct> products;

  @override
  Future<List<PosProduct>> getProducts() async => products;

  @override
  Future<List<String>> getCategories() async => const ['Grocery'];

  @override
  Future<List<HeldSaleSummary>> getHeldSales() async => const [];

  @override
  Future<List<PosCustomer>> getCustomers() async => const [];

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  test('brand accent token matches design system', () {
    expect(AppColors.accent.toARGB32(), 0xFF2563EB);
  });

  test('POS payable total matches the whole rupee amount shown to cashier', () {
    const product = PosProduct(
      id: 1,
      sku: 'TEST',
      barcode: '1',
      name: 'Taxed product',
      category: 'Test',
      sellingPrice: 587,
      purchasePrice: 400,
      taxRate: 17,
      taxInclusive: false,
      stock: 10,
    );
    const state = PosReady(
      allProducts: [product],
      categories: ['Test'],
      selectedCategory: 'All',
      query: '',
      lines: [CartLine(product: product, quantity: 1)],
      cartDiscount: 0,
      cartDiscountMode: CartDiscountMode.fixed,
      heldSales: [],
    );

    expect(state.totals.total, 687);
  });

  testWidgets('new product low-stock alert starts at 10', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1600, 1400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showProductEditorSheet(
              context: context,
              categories: const ['Grocery'],
            ),
            child: const Text('Add product'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('Add product'));
    await tester.pumpAndSettle();

    final lowStockField = tester.widget<TextField>(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField &&
            widget.decoration?.labelText == 'Low stock alert',
      ),
    );
    expect(lowStockField.controller?.text, '10');
  });

  testWidgets('POS multi-batch product adds automatically without a popup', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 800));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final now = DateTime(2026, 8, 20);
    final product = PosProduct(
      id: 2,
      sku: 'BATCHED',
      barcode: '2',
      name: 'Batch product',
      category: 'Grocery',
      sellingPrice: 100,
      purchasePrice: 80,
      taxRate: 0,
      taxInclusive: true,
      stock: 8,
      batches: [
        PosBatchLot(
          id: 10,
          quantity: 3,
          receivedAt: now,
          batchCode: 'B-001',
          expiryDate: DateTime(2027, 1, 1),
        ),
        PosBatchLot(
          id: 11,
          quantity: 5,
          receivedAt: now,
          batchCode: 'B-002',
          expiryDate: DateTime(2027, 6, 1),
        ),
      ],
    );
    final bloc = PosBloc(_FakePosRepository([product]));
    addTearDown(bloc.close);

    await tester.pumpWidget(
      BlocProvider.value(
        value: bloc,
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 800,
              height: 700,
              child: PosProductGrid(
                products: [product],
                cartQuantities: const {},
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
    addTearDown(mouse.removePointer);
    await mouse.addPointer(location: const Offset(10, 10));
    await mouse.moveTo(tester.getCenter(find.text('Batch product')));
    await tester.tap(find.text('Batch product'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Choose batch'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  test('receipt line shows the automatically allocated batch names', () {
    const line = SaleLineItem(
      productId: 1,
      productName: 'Coca-Cola',
      productSku: 'COKE',
      quantity: 3,
      unitPrice: 100,
      lineDiscount: 0,
      lineTotal: 300,
      batchAllocations: [
        {'batchCode': 'CC-SOON', 'quantity': 1},
        {'batchCode': 'CC-OK', 'quantity': 2},
      ],
    );

    expect(line.batchSummary, 'Batch CC-SOON × 1, CC-OK × 2');
  });

  testWidgets('new purchase starts pieces per box at 1', (tester) async {
    await tester.binding.setSurfaceSize(const Size(1400, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    const product = PurchaseProductOption(
      id: 1,
      name: 'Tea carton',
      sku: 'TEA-1',
      purchasePrice: 100,
      sellingPrice: 150,
      stock: 10,
      itemsPerBox: 6,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showPurchaseEditorSheet(
              context: context,
              suppliers: const [
                SupplierItem(
                  id: 1,
                  name: 'Supplier',
                  phone: '',
                  isActive: true,
                ),
              ],
              products: const [product],
              supplierDue: (_) => 0,
            ),
            child: const Text('New purchase'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('New purchase'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Product'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Tea carton (TEA-1)').last);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Unit'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Item'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Box').last);
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(
      find.byWidgetPredicate(
        (widget) =>
            widget is TextField && widget.decoration?.labelText == 'Pcs / box',
      ),
    );
    expect(field.controller?.text, '1');
  });
}
