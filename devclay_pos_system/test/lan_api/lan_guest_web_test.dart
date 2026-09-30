import 'dart:convert';

import 'package:devclay_pos_system/database/collections/app_setting.dart';
import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:devclay_pos_system/database/restaurant_floor_seed.dart';
import 'package:devclay_pos_system/modules/restaurant/data/datasources/restaurant_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../support/isar_test_bootstrap.dart';
import 'lan_test_harness.dart';

void main() {
  late LanTestHarness h;

  setUpAll(ensureIsarCoreInitialized);

  setUp(() async {
    h = await LanTestHarness.start();
    await h.isar.writeTxn(() async {
      final settings = await h.isar.appSettings
          .filter()
          .keyEqualTo('default')
          .findFirst();
      settings!
        ..storeProfile = 'restaurant'
        ..enableRestaurantFloor = true
        ..enableWebToTable = true
        ..webToTablePin = ''
        ..webToTableTokenSecret = 'guest-secret';
      await h.isar.appSettings.put(settings);
      await h.isar.products.put(
        Product()
          ..sku = 'MAIN-1'
          ..barcode = 'MAIN-1'
          ..name = 'Steak'
          ..category = 'Mains'
          ..sellingPrice = 1200
          ..purchasePrice = 500
          ..taxRate = 0
          ..taxInclusive = true
          ..stock = 20
          ..isActive = true,
      );
    });
    await RestaurantFloorSeed.ensureSampleFloor(h.isar);
  });

  tearDown(() async {
    await h.dispose();
  });

  test('guest menu and table token resolve without auth', () async {
    final restaurant = RestaurantLocalDataSource(h.isarService, forceLocal: true);
    final table = (await restaurant.listTables()).first;

    final menu = await h.get('/guest/api/menu', authed: false);
    expect(menu.statusCode, 200);
    final menuBody = jsonDecode(menu.body) as Map<String, dynamic>;
    expect((menuBody['items'] as List), isNotEmpty);

    final tableRes = await h.get(
      '/guest/api/table/${table.guestToken}',
      authed: false,
    );
    expect(tableRes.statusCode, 200);
    final tableBody = jsonDecode(tableRes.body) as Map<String, dynamic>;
    expect(tableBody['code'], table.code);
  });

  test('guest POST order creates check and kitchen ticket', () async {
    final restaurant = RestaurantLocalDataSource(h.isarService, forceLocal: true);
    final table = (await restaurant.listTables()).first;
    final products = await h.isar.products.filter().skuEqualTo('MAIN-1').findAll();
    final productId = products.first.id;

    final res = await h.post(
      '/guest/api/orders',
      {
        'tableToken': table.guestToken,
        'guests': 2,
        'lines': [
          {'productId': productId, 'quantity': 1},
        ],
      },
      authed: false,
    );
    expect(res.statusCode, 200);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    expect(body['ok'], isTrue);
    expect(body['checkId'], isNotNull);

    final tickets = await restaurant.listKitchenTickets(openOnly: true);
    expect(tickets, isNotEmpty);
  });

  test('guest HTML is served', () async {
    final res = await h.get('/guest/', authed: false);
    expect(res.statusCode, 200);
    expect(res.body, contains('Table menu'));
  });
}
