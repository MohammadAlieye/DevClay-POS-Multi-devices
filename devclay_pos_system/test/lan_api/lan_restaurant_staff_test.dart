import 'dart:convert';

import 'package:devclay_pos_system/database/collections/app_setting.dart';
import 'package:devclay_pos_system/database/collections/customer.dart';
import 'package:devclay_pos_system/database/collections/customer_ledger_entry.dart';
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
        ..enableWebToTable = true;
      await h.isar.appSettings.put(settings);
    });
    await RestaurantFloorSeed.ensureSampleFloor(h.isar);
  });

  tearDown(() async {
    await h.dispose();
  });

  test('GET restaurant floors and tables (authed)', () async {
    final floors = await h.get('/api/v1/restaurant/floors');
    expect(floors.statusCode, 200);
    final floorBody = jsonDecode(floors.body) as Map<String, dynamic>;
    expect((floorBody['items'] as List), isNotEmpty);

    final tables = await h.get('/api/v1/restaurant/tables');
    expect(tables.statusCode, 200);
    final tableBody = jsonDecode(tables.body) as Map<String, dynamic>;
    expect((tableBody['items'] as List), isNotEmpty);
  });

  test('open check and fire kitchen via staff API', () async {
    final restaurant = RestaurantLocalDataSource(h.isarService, forceLocal: true);
    final table = (await restaurant.listTables()).first;

    final open = await h.post('/api/v1/restaurant/checks/open', {
      'tableId': table.id,
      'guests': 2,
    });
    expect(open.statusCode, 200);
    final check = jsonDecode(open.body) as Map<String, dynamic>;
    final checkId = check['id'] as int;

    final fire = await h.post(
      '/api/v1/restaurant/checks/$checkId/fire-kitchen',
      {'course': 'main'},
    );
    expect(fire.statusCode, 200);

    final tickets = await h.get('/api/v1/restaurant/kitchen/tickets');
    expect(tickets.statusCode, 200);
    final ticketBody = jsonDecode(tickets.body) as Map<String, dynamic>;
    expect((ticketBody['items'] as List), isNotEmpty);
  });

  test('GET customer ledger and sales', () async {
    late int customerId;
    await h.isar.writeTxn(() async {
      customerId = await h.isar.customers.put(
        Customer()
          ..name = 'Khata Test'
          ..phone = '03001234567'
          ..balance = 100
          ..creditLimit = 5000
          ..isActive = true
          ..createdAt = DateTime.now(),
      );
      await h.isar.customerLedgerEntrys.put(
        CustomerLedgerEntry()
          ..customerId = customerId
          ..customerName = 'Khata Test'
          ..type = 'debit'
          ..amount = 100
          ..balanceAfter = 100
          ..note = 'seed'
          ..entryDate = DateTime.now()
          ..createdAt = DateTime.now(),
      );
    });

    final ledger = await h.get('/api/v1/customers/$customerId/ledger');
    expect(ledger.statusCode, 200);
    final ledgerBody = jsonDecode(ledger.body) as Map<String, dynamic>;
    expect((ledgerBody['items'] as List), isNotEmpty);

    final sales = await h.get('/api/v1/customers/$customerId/sales');
    expect(sales.statusCode, 200);
    final salesBody = jsonDecode(sales.body) as Map<String, dynamic>;
    expect(salesBody['items'], isA<List>());
  });
}
