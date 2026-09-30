import 'dart:io';
import 'dart:convert';
import 'dart:ffi';

import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:devclay_pos_system/database/collections/product_batch.dart';
import 'package:devclay_pos_system/database/product_batch_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  late Directory testDirectory;
  late Isar isar;
  late Product product;

  setUpAll(() async {
    final configFile = File('.dart_tool/package_config.json');
    final config =
        jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
    final packages = config['packages'] as List<dynamic>;
    final package = packages.cast<Map<String, dynamic>>().firstWhere(
      (item) => item['name'] == 'isar_community_flutter_libs',
    );
    final configUri = configFile.absolute.uri;
    final resolvedRoot = configUri.resolve(package['rootUri'] as String);
    final packageRoot = resolvedRoot.toString().endsWith('/')
        ? resolvedRoot
        : Uri.parse('${resolvedRoot.toString()}/');
    final relativeLibrary = Platform.isMacOS
        ? 'macos/libisar.dylib'
        : Platform.isWindows
        ? 'windows/libisar.dll'
        : 'linux/libisar.so';
    final libraryPath = packageRoot.resolve(relativeLibrary).toFilePath();
    await Isar.initializeIsarCore(libraries: {Abi.current(): libraryPath});
  });

  setUp(() async {
    testDirectory = await Directory.systemTemp.createTemp('devclay_pos_test_');
    isar = await Isar.open(
      [ProductSchema, ProductBatchSchema],
      directory: testDirectory.path,
      name: 'batch_store_test',
    );
    product = Product()
      ..sku = 'TEST-001'
      ..barcode = 'TEST-001'
      ..name = 'Test product'
      ..category = 'Test'
      ..sellingPrice = 20
      ..purchasePrice = 10
      ..taxRate = 0
      ..taxInclusive = false
      ..stock = 0
      ..isActive = true;

    await isar.writeTxn(() async {
      await isar.products.put(product);
      await ProductBatchStore.receive(
        isar: isar,
        product: product,
        quantity: 3,
        batchCode: 'B-001',
      );
    });
  });

  tearDown(() async {
    if (isar.isOpen) await isar.close(deleteFromDisk: true);
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  test(
    'insufficient stock rejects the full deduction without changing stock',
    () async {
      await expectLater(
        isar.writeTxn(
          () => ProductBatchStore.deductFefo(
            isar: isar,
            product: product,
            quantity: 4,
          ),
        ),
        throwsA(isA<StateError>()),
      );

      expect(await ProductBatchStore.totalBatchQty(isar, product.id), 3);
    },
  );

  test('available stock is deducted completely', () async {
    final allocations = await isar.writeTxn(
      () => ProductBatchStore.deductFefo(
        isar: isar,
        product: product,
        quantity: 3,
      ),
    );

    expect(allocations.fold<int>(0, (sum, item) => sum + item.quantity), 3);
    expect(await ProductBatchStore.totalBatchQty(isar, product.id), 0);
  });

  test('cashier-selected batch deducts only that exact batch', () async {
    await isar.writeTxn(() async {
      await ProductBatchStore.receive(
        isar: isar,
        product: product,
        quantity: 5,
        batchCode: 'B-002',
        expiryDate: DateTime(2030, 1, 1),
      );
    });
    final before = await ProductBatchStore.batchesForProduct(isar, product.id);
    final first = before.firstWhere((batch) => batch.batchCode == 'B-001');
    final selected = before.firstWhere((batch) => batch.batchCode == 'B-002');

    final allocations = await isar.writeTxn(
      () => ProductBatchStore.deductFromBatch(
        isar: isar,
        product: product,
        batchId: selected.id,
        quantity: 2,
      ),
    );

    final after = await ProductBatchStore.batchesForProduct(isar, product.id);
    expect(after.firstWhere((batch) => batch.id == first.id).quantity, 3);
    expect(after.firstWhere((batch) => batch.id == selected.id).quantity, 3);
    expect(allocations.single.batchId, selected.id);
    expect(await ProductBatchStore.totalBatchQty(isar, product.id), 6);
  });
}
