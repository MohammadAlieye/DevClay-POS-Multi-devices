import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:devclay_pos_system/database/collections/supplier.dart';
import 'package:devclay_pos_system/database/isar_service.dart';
import 'package:devclay_pos_system/modules/purchases/data/datasources/purchases_local_datasource.dart';
import 'package:devclay_pos_system/modules/purchases/domain/entities/purchase_entities.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

class _TestIsarService extends IsarService {
  _TestIsarService(this.isar);

  final Isar isar;

  @override
  Isar get instance => isar;
}

void main() {
  late Directory testDirectory;
  late Isar isar;
  late PurchasesLocalDataSource dataSource;

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
      'devclay_supplier_save_',
    );
    isar = await Isar.open(
      [SupplierSchema],
      directory: testDirectory.path,
      name: 'supplier_save_${DateTime.now().microsecondsSinceEpoch}',
    );
    dataSource = PurchasesLocalDataSource(_TestIsarService(isar));
  });

  tearDown(() async {
    if (isar.isOpen) await isar.close(deleteFromDisk: true);
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  test('supplier can be saved with name only', () async {
    final saved = await dataSource.saveSupplier(
      const SupplierDraft(name: 'Akbar Traders', phone: ''),
    );

    expect(saved.name, 'Akbar Traders');
    expect(saved.phone, isEmpty);
    expect(await isar.suppliers.count(), 1);
  });

  test('supplier opening balance is saved on create', () async {
    final saved = await dataSource.saveSupplier(
      const SupplierDraft(
        name: 'Old Khata Traders',
        phone: '',
        openingBalance: 25000,
      ),
    );

    expect(saved.balance, 25000);
    final row = await isar.suppliers.get(saved.id);
    expect(row?.balance, 25000);
  });

  test('supplier credit opening balance is negative', () async {
    final saved = await dataSource.saveSupplier(
      const SupplierDraft(
        name: 'Advance Supplier',
        phone: '',
        openingBalance: -5000,
      ),
    );

    expect(saved.balance, -5000);
  });

  test('NaN stored balance is treated as zero', () async {
    await isar.writeTxn(() async {
      await isar.suppliers.put(
        Supplier()
          ..name = 'Old Supplier'
          ..phone = ''
          ..isActive = true
          ..balance = double.nan
          ..createdAt = DateTime.now(),
      );
    });

    final loaded = await dataSource.getSuppliers();
    expect(loaded.single.balance, 0);
    expect(loaded.single.balance.isNaN, isFalse);
  });

  test('supplier name is still required', () async {
    await expectLater(
      dataSource.saveSupplier(
        const SupplierDraft(name: '  ', phone: '03001234567'),
      ),
      throwsA(
        isA<ArgumentError>().having(
          (error) => error.message,
          'message',
          'Supplier name is required.',
        ),
      ),
    );
    expect(await isar.suppliers.count(), 0);
  });
}
