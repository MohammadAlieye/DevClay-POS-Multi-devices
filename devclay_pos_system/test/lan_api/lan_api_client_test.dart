import 'package:devclay_pos_system/core/lan_api/dtos/lan_dtos.dart';
import 'package:devclay_pos_system/core/lan_api/lan_api_errors.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/isar_test_bootstrap.dart';
import 'lan_sale_fixtures.dart';
import 'lan_test_harness.dart';

void main() {
  late LanTestHarness h;

  setUpAll(ensureIsarCoreInitialized);

  setUp(() async {
    h = await LanTestHarness.start();
  });

  tearDown(() async {
    await h.dispose();
  });

  group('LanApiClient against live host', () {
    test('health + profile + login + catalog round-trip', () async {
      final health = await h.client.health();
      expect(health.ok, isTrue);
      expect(health.businessName, 'LAN Test Host');

      final profile = await h.client.fetchProfile();
      expect(profile.storeProfileConfigured, isTrue);

      final user = await h.client.login(
        username: LanFixtures.adminUsername,
        password: LanFixtures.adminPassword,
      );
      expect(user.username, LanFixtures.adminUsername);

      final products = await h.client.fetchProducts();
      expect(products.length, greaterThanOrEqualTo(3));

      final accounts = await h.client.fetchPaymentAccounts();
      expect(accounts, isNotEmpty);

      final customers = await h.client.fetchCustomers();
      expect(customers.any((c) => c['name'] == 'Ali Khan'), isTrue);
    });

    test('create customer + create sale + fetch sales', () async {
      final createdCustomer = await h.client.createCustomer({
        'name': 'Client Created',
        'phone': '03211234567',
      });
      expect(createdCustomer['id'], isA<int>());

      final sale = await h.client.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
          customerId: createdCustomer['id'] as int,
        ),
      );
      expect(sale['invoiceNo'], startsWith('INV-'));

      final sales = await h.client.fetchSales();
      expect(sales.any((s) => s['id'] == sale['id']), isTrue);

      final detail = await h.client.fetchSaleById(sale['id'] as int);
      expect(detail['invoiceNo'], sale['invoiceNo']);
    });

    test('login failure maps to LanApiException', () async {
      await expectLater(
        h.client.login(username: 'admin', password: 'nope'),
        throwsA(
          isA<LanApiException>().having(
            (e) => e.statusCode,
            'status',
            401,
          ),
        ),
      );
    });
  });

  group('host offline', () {
    test('client throws host_offline when host stopped', () async {
      await h.server.close(force: true);

      await expectLater(
        h.client.health(),
        throwsA(
          isA<LanApiException>().having(
            (e) => e.code,
            'code',
            'host_offline',
          ),
        ),
      );
    });
  });

  group('DTO parsing', () {
    test('LanHealthDto / LanProfileDto / LanAuthUserDto round-trip', () {
      final health = LanHealthDto.fromJson({
        'ok': true,
        'businessName': 'X',
        'storeProfile': 'pharmacy',
        'apiVersion': '1',
        'serverTime': 't',
      });
      expect(health.toJson()['businessName'], 'X');

      final profile = LanProfileDto.fromJson({
        'storeProfile': 'clothing',
        'storeProfileConfigured': true,
        'enableProductVariants': true,
      });
      expect(profile.enableBatchesExpiry, isTrue);
      expect(profile.enableProductVariants, isTrue);

      final user = LanAuthUserDto.fromJson({
        'id': 7,
        'username': 'a',
        'displayName': 'A',
        'role': 'cashier',
        'permissions': ['pos'],
      });
      expect(user.permissions, ['pos']);
    });
  });
}
