import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:devclay_pos_system/database/collections/app_setting.dart';
import 'package:devclay_pos_system/database/isar_service.dart';
import 'package:devclay_pos_system/modules/products/data/datasources/products_local_datasource.dart';
import 'package:devclay_pos_system/modules/products/domain/entities/product_item.dart';
import 'package:devclay_pos_system/services/media/product_image_store.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

class _TestIsarService extends IsarService {
  _TestIsarService(this.isar);

  final Isar isar;

  @override
  Isar get instance => isar;
}

ProductDraft _draft({
  String sku = 'SKU-001',
  String barcode = '100001',
  String name = 'Tea',
  String category = 'Grocery',
  String unit = 'pcs',
}) {
  return ProductDraft(
    sku: sku,
    barcode: barcode,
    name: name,
    category: category,
    unit: unit,
    taxRate: 0,
    taxInclusive: true,
    isActive: true,
    lowStockThreshold: 10,
  );
}

void main() {
  late Directory testDirectory;
  late Isar isar;
  late ProductsLocalDataSource dataSource;

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
    await Isar.initializeIsarCore(
      libraries: {
        Abi.current(): packageRoot.resolve(relativeLibrary).toFilePath(),
      },
    );
  });

  setUp(() async {
    testDirectory = await Directory.systemTemp.createTemp(
      'devclay_product_validation_',
    );
    isar = await Isar.open(
      [ProductSchema, AppSettingSchema],
      directory: testDirectory.path,
      name: 'product_validation_${DateTime.now().microsecondsSinceEpoch}',
    );
    dataSource = ProductsLocalDataSource(
      _TestIsarService(isar),
      ProductImageStore(),
    );
    await isar.writeTxn(() async {
      await isar.appSettings.put(
        AppSetting()
          ..key = 'default'
          ..businessName = 'Test Store'
          ..businessPhone = ''
          ..businessEmail = ''
          ..businessAddress = ''
          ..taxNumber = ''
          ..defaultTaxRate = 0
          ..defaultTaxInclusive = true
          ..receiptFooter = ''
          ..showBusinessInfoOnReceipt = true
          ..printerName = ''
          ..autoPrintReceipt = false
          ..paperWidthMm = 80
          ..productUnitsCsv = 'pcs',
      );
    });
  });

  tearDown(() async {
    if (isar.isOpen) await isar.close(deleteFromDisk: true);
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  test('required product fields are enforced by the data layer', () async {
    await expectLater(
      dataSource.createProduct(_draft(name: '  ')),
      throwsA(
        isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          'Product name is required.',
        ),
      ),
    );
    expect(await isar.products.count(), 0);
  });

  test('duplicate SKU is rejected without replacing the original', () async {
    final original = await dataSource.createProduct(_draft());

    await expectLater(
      dataSource.createProduct(
        _draft(sku: 'sku-001', barcode: '100002', name: 'Coffee'),
      ),
      throwsA(isA<ArgumentError>()),
    );

    expect(await isar.products.count(), 1);
    expect((await isar.products.get(original.id))?.name, 'Tea');
  });

  test('duplicate barcode is rejected', () async {
    await dataSource.createProduct(_draft());

    await expectLater(
      dataSource.createProduct(
        _draft(sku: 'SKU-002', barcode: '100001', name: 'Coffee'),
      ),
      throwsA(isA<ArgumentError>()),
    );

    expect(await isar.products.count(), 1);
  });

  test('a product unit is automatically added to settings', () async {
    await dataSource.createProduct(_draft(unit: 'carton'));

    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    expect(settings?.productUnitsCsv.split(','), contains('carton'));
  });
}
