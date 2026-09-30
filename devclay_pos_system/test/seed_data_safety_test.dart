import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:devclay_pos_system/database/collections/app_setting.dart';
import 'package:devclay_pos_system/database/collections/app_notification.dart';
import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:devclay_pos_system/database/isar_service.dart';
import 'package:devclay_pos_system/database/seed_data.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

void main() {
  late Directory testDirectory;
  late Isar isar;

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
      'devclay_seed_safety_',
    );
    isar = await Isar.open(
      IsarService.schemas,
      directory: testDirectory.path,
      name: 'seed_safety_${DateTime.now().microsecondsSinceEpoch}',
    );
    await SeedData.ensureSeeded(isar);
  });

  tearDown(() async {
    if (isar.isOpen) await isar.close(deleteFromDisk: true);
    if (await testDirectory.exists()) {
      await testDirectory.delete(recursive: true);
    }
  });

  test(
    'missing legacy seed notification never wipes business data or theme',
    () async {
      final settings = await isar.appSettings
          .filter()
          .keyEqualTo('default')
          .findFirst();
      final product = await isar.products.where().findFirst();
      expect(settings, isNotNull);
      expect(product, isNotNull);
      final savedSettings = settings!;
      final savedProduct = product!;

      final originalCount = await isar.products.count();
      await isar.writeTxn(() async {
        savedSettings
          ..themeMode = 'dark'
          ..accentPreset = 'emerald'
          ..seedRevision = '';
        savedProduct.name = 'Customer-owned product';
        await isar.appSettings.put(savedSettings);
        await isar.products.put(savedProduct);
        await isar.appNotifications.clear();
      });

      await SeedData.ensureSeeded(isar);

      final preservedSettings = await isar.appSettings
          .filter()
          .keyEqualTo('default')
          .findFirst();
      final preservedProduct = await isar.products.get(savedProduct.id);
      expect(await isar.products.count(), originalCount);
      expect(preservedProduct?.name, 'Customer-owned product');
      expect(preservedSettings?.themeMode, 'dark');
      expect(preservedSettings?.accentPreset, 'emerald');
      expect(preservedSettings?.seedRevision, isNotEmpty);
    },
  );

  test('an older seed revision is migrated without resetting data', () async {
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    final product = await isar.products.where().findFirst();
    expect(settings, isNotNull);
    expect(product, isNotNull);
    final savedSettings = settings!;
    final savedProduct = product!;
    await isar.writeTxn(() async {
      savedSettings
        ..themeMode = 'dark'
        ..seedRevision = 'older-release';
      savedProduct.name = 'Keep this product';
      await isar.appSettings.put(savedSettings);
      await isar.products.put(savedProduct);
    });

    await SeedData.ensureSeeded(isar);

    expect(
      (await isar.products.get(savedProduct.id))?.name,
      'Keep this product',
    );
    expect((await isar.appSettings.get(savedSettings.id))?.themeMode, 'dark');
  });
}
