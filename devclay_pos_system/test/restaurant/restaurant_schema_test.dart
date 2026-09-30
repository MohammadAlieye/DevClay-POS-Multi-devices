import 'dart:io';

import 'package:devclay_pos_system/database/collections/app_setting.dart';
import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:devclay_pos_system/database/isar_service.dart';
import 'package:devclay_pos_system/database/restaurant_floor_seed.dart';
import 'package:devclay_pos_system/modules/restaurant/data/datasources/restaurant_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar_community/isar.dart';

import '../lan_api/lan_test_harness.dart';
import '../support/isar_test_bootstrap.dart';

void main() {
  setUpAll(ensureIsarCoreInitialized);

  late Directory directory;
  late Isar isar;
  late RestaurantLocalDataSource restaurant;

  setUp(() async {
    directory = await Directory.systemTemp.createTemp('restaurant_test_');
    isar = await Isar.open(
      IsarService.schemas,
      directory: directory.path,
      name: 'rest_${DateTime.now().microsecondsSinceEpoch}',
    );
    restaurant = RestaurantLocalDataSource(TestIsarService(isar));
    await isar.writeTxn(() async {
      await isar.appSettings.put(
        AppSetting()
          ..key = 'default'
          ..businessName = 'Cafe'
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
          ..storeProfile = 'restaurant'
          ..storeProfileConfigured = true
          ..enableRestaurantFloor = true
          ..enableWebToTable = true
          ..webToTablePin = '1234'
          ..webToTableTokenSecret = 'test-secret',
      );
      await isar.products.put(
        Product()
          ..sku = 'M1'
          ..barcode = 'M1'
          ..name = 'Burger'
          ..category = 'Mains'
          ..sellingPrice = 500
          ..purchasePrice = 200
          ..taxRate = 0
          ..taxInclusive = true
          ..stock = 50
          ..isActive = true,
      );
    });
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
    if (await directory.exists()) {
      await directory.delete(recursive: true);
    }
  });

  test('seeds main floor with tables', () async {
    await RestaurantFloorSeed.ensureSampleFloor(isar);
    final floors = await restaurant.listFloors();
    final tables = await restaurant.listTables();
    expect(floors, isNotEmpty);
    expect(floors.first.name, 'Main');
    expect(tables.length, greaterThanOrEqualTo(8));
    expect(tables.every((t) => t.guestToken.isNotEmpty), isTrue);
  });

  test('open check → set lines → fire kitchen → close', () async {
    await RestaurantFloorSeed.ensureSampleFloor(isar);
    final table = (await restaurant.listTables()).first;
    final check = await restaurant.openOrGetCheck(tableId: table.id, guests: 2);
    expect(check.status, 'open');

    final updated = await restaurant.setCheckLines(
      checkId: check.id,
      lines: [
        {
          'productId': 1,
          'productName': 'Burger',
          'productSku': 'M1',
          'quantity': 2,
          'unitPrice': 500,
          'lineDiscount': 0,
          'lineTotal': 1000,
        },
      ],
    );
    expect(updated.subtotal, 1000);
    expect(updated.status, 'ordered');

    final ticket = await restaurant.fireKitchenTicket(checkId: check.id);
    expect(ticket.status, 'queued');
    expect(ticket.tableCode, table.code);

    await restaurant.bumpKitchenTicket(ticket.id, to: 'ready');
    final openKitchen = await restaurant.listKitchenTickets(openOnly: true);
    expect(openKitchen.where((t) => t.id == ticket.id).first.status, 'ready');

    await restaurant.closeCheck(
      checkId: check.id,
      saleId: 99,
      invoiceNo: 'INV-R1',
    );
    final closed = await restaurant.getCheck(check.id);
    expect(closed?.status, 'closed');
    expect(closed?.closedSaleId, 99);
    final dirty = await restaurant.getTable(table.id);
    expect(dirty?.status, 'dirty');
  });

  test('web order stays pending until staff accept when pin set', () async {
    await RestaurantFloorSeed.ensureSampleFloor(isar);
    final table = (await restaurant.listTables()).first;
    final check = await restaurant.openOrGetCheck(
      tableId: table.id,
      guests: 1,
      source: 'web',
    );
    expect(check.webAcceptStatus, 'pending');
    await restaurant.appendWebLines(
      checkId: check.id,
      newLines: [
        {
          'productId': 1,
          'productName': 'Burger',
          'productSku': 'M1',
          'quantity': 1,
          'unitPrice': 500,
          'lineDiscount': 0,
          'lineTotal': 500,
        },
      ],
    );
    await restaurant.acceptWebOrder(check.id);
    final accepted = await restaurant.getCheck(check.id);
    expect(accepted?.webAcceptStatus, 'accepted');
  });
}
