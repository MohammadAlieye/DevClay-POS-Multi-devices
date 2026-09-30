import 'dart:convert';

import 'package:devclay_pos_system/core/lan_api/lan_api_paths.dart';
import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:isar_community/isar.dart';

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

  group('GET /health', () {
    test('returns host identity and api version', () async {
      final res = await h.get(LanApiPaths.health);
      final body = await h.decodeOk(res);
      expect(body['ok'], isTrue);
      expect(body['businessName'], 'LAN Test Host');
      expect(body['storeProfile'], 'general_retail');
      expect(body['apiVersion'], LanApiPaths.apiVersion);
      expect(body['serverTime'], isNotEmpty);
    });
  });

  group('POST /auth/login', () {
    test('accepts valid credentials', () async {
      final res = await h.post(LanApiPaths.login, {
        'username': LanFixtures.adminUsername,
        'password': LanFixtures.adminPassword,
      });
      final body = await h.decodeOk(res);
      expect(body['id'], h.fixtures.adminUserId);
      expect(body['username'], LanFixtures.adminUsername);
      expect(body['role'], 'owner');
      expect(body['permissions'], contains('*'));
    });

    test('rejects wrong password with 401', () async {
      final res = await h.post(LanApiPaths.login, {
        'username': LanFixtures.adminUsername,
        'password': 'wrong',
      });
      expect(res.statusCode, 401);
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      expect(body['code'], 'auth_failed');
    });

    test('rejects inactive user with 401', () async {
      final res = await h.post(LanApiPaths.login, {
        'username': LanFixtures.inactiveUsername,
        'password': LanFixtures.inactivePassword,
      });
      expect(res.statusCode, 401);
    });

    test('rejects empty body fields with 400', () async {
      final res = await h.post(LanApiPaths.login, {
        'username': '',
        'password': '',
      });
      expect(res.statusCode, 400);
    });

    test('normalizes username case', () async {
      final res = await h.post(LanApiPaths.login, {
        'username': 'ADMIN',
        'password': LanFixtures.adminPassword,
      });
      expect(res.statusCode, 200);
    });
  });

  group('GET /settings/profile', () {
    test('returns store profile flags', () async {
      final body = await h.decodeOk(await h.get(LanApiPaths.profile));
      expect(body['storeProfile'], 'general_retail');
      expect(body['storeProfileConfigured'], isTrue);
      expect(body['enableProductVariants'], isTrue);
      expect(body['productCategoriesCsv'], contains('Grocery'));
    });
  });

  group('GET /products', () {
    test('lists only active non-deleted products with batches/variants',
        () async {
      final body = await h.decodeOk(await h.get(LanApiPaths.products));
      final items = (body['items'] as List).cast<Map<String, dynamic>>();
      final names = items.map((e) => e['name']).toSet();
      expect(names, containsAll(['Green Tea', 'Low Stock Item', 'T-Shirt']));
      expect(names, isNot(contains('Inactive Product')));
      expect(names, isNot(contains('Deleted Product')));

      final tea = items.firstWhere((e) => e['name'] == 'Green Tea');
      expect(tea['stock'], 10);
      expect((tea['batches'] as List).length, 2);

      final shirt = items.firstWhere((e) => e['name'] == 'T-Shirt');
      expect(shirt['hasVariants'], isTrue);
      expect((shirt['variants'] as List).length, 1);
      expect(shirt['stock'], 4);
    });
  });

  group('GET /products/:id', () {
    test('returns product detail', () async {
      final body = await h.decodeOk(
        await h.get('${LanApiPaths.productById}${h.fixtures.productId}'),
      );
      expect(body['id'], h.fixtures.productId);
      expect(body['sku'], 'SKU-TEA');
    });

    test('returns 404 for deleted product', () async {
      final res = await h.get(
        '${LanApiPaths.productById}${h.fixtures.deletedProductId}',
      );
      expect(res.statusCode, 404);
    });

    test('returns 404 for inactive product by id', () async {
      final res = await h.get(
        '${LanApiPaths.productById}${h.fixtures.inactiveProductId}',
      );
      expect(res.statusCode, 404);
    });
  });

  group('customers', () {
    test('GET lists active customers sorted by name', () async {
      final body = await h.decodeOk(await h.get(LanApiPaths.customers));
      final items = body['items'] as List;
      expect(items, isNotEmpty);
      expect(items.first['name'], 'Ali Khan');
    });

    test('POST creates customer', () async {
      final res = await h.post(LanApiPaths.customers, {
        'name': 'Sara Ahmed',
        'phone': '03111234567',
        'creditLimit': 1000,
      });
      final body = await h.decodeOk(res);
      expect(body['name'], 'Sara Ahmed');
      expect(body['id'], isA<int>());

      final listed = await h.decodeOk(await h.get(LanApiPaths.customers));
      final names =
          (listed['items'] as List).map((e) => e['name']).toList();
      expect(names, contains('Sara Ahmed'));
    });

    test('POST rejects empty name', () async {
      final res = await h.post(LanApiPaths.customers, {'name': '  '});
      expect(res.statusCode, 400);
    });
  });

  group('GET /accounts/payment', () {
    test('returns accounts with default cash first', () async {
      final body = await h.decodeOk(await h.get(LanApiPaths.paymentAccounts));
      final items = (body['items'] as List).cast<Map<String, dynamic>>();
      expect(items.first['isDefault'], isTrue);
      expect(items.map((e) => e['name']), containsAll(['Cash Drawer', 'HBL']));
    });
  });

  group('sales list/detail/preview', () {
    test('preview next invoice starts at INV-000001', () async {
      final body =
          await h.decodeOk(await h.get(LanApiPaths.nextInvoicePreview));
      expect(body['invoiceNo'], 'INV-000001');
    });

    test('list/search/detail after creating a sale', () async {
      final created = await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
        ),
      );

      final list = await h.decodeOk(await h.get(LanApiPaths.sales));
      expect((list['items'] as List), isNotEmpty);

      final search = await h.decodeOk(
        await h.get(LanApiPaths.sales, query: {'q': 'zzz-no-match'}),
      );
      expect((search['items'] as List), isEmpty);

      final byInvoice = await h.decodeOk(
        await h.get(
          LanApiPaths.sales,
          query: {'q': created['invoiceNo'] as String},
        ),
      );
      expect((byInvoice['items'] as List).length, 1);

      final detail = await h.decodeOk(
        await h.get('${LanApiPaths.saleById}${created['id']}'),
      );
      expect(detail['invoiceNo'], created['invoiceNo']);
      expect(detail['linesJson'], isNotEmpty);
      expect(detail['status'], 'completed');
    });

    test('detail 404 for missing sale', () async {
      final res = await h.get('${LanApiPaths.saleById}999999');
      expect(res.statusCode, 404);
    });

    test('limit query is respected', () async {
      for (var i = 0; i < 3; i++) {
        await h.saleWrite.createSale(
          cashSaleDto(
            h,
            productId: h.fixtures.productId,
            qty: 1,
            unitPrice: 100,
          ),
        );
      }
      final body = await h.decodeOk(
        await h.get(LanApiPaths.sales, query: {'limit': '2'}),
      );
      expect((body['items'] as List).length, 2);
    });
  });

  group('POST /sales', () {
    test('creates cash sale and reduces FEFO stock', () async {
      final before = await h.isar.products.get(h.fixtures.productId);
      expect(before!.stock, 10);

      final res = await h.post(
        LanApiPaths.sales,
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 3,
          unitPrice: 100,
        ).toJson(),
      );
      final body = await h.decodeOk(res);
      expect(body['invoiceNo'], 'INV-000001');
      expect(body['total'], 300);

      final after = await h.isar.products.get(h.fixtures.productId);
      expect(after!.stock, 7);
    });

    test('rejects empty lines', () async {
      final res = await h.post(LanApiPaths.sales, {
        'linesJson': '[]',
        'cashierId': h.fixtures.adminUserId,
        'cashierName': 'Admin',
        'subtotal': 0,
        'tax': 0,
        'total': 0,
        'discount': 0,
        'paymentMethod': 'Cash',
        'amountPaid': 0,
        'cardAmount': 0,
        'changeAmount': 0,
        'itemCount': 0,
        'methodKind': 'cash',
      });
      expect(res.statusCode, 400);
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      expect(body['code'], 'invalid_lines');
    });

    test('rejects overselling without mutating stock', () async {
      final res = await h.post(
        LanApiPaths.sales,
        cashSaleDto(
          h,
          productId: h.fixtures.lowStockProductId,
          qty: 99,
          unitPrice: 50,
        ).toJson(),
      );
      expect(res.statusCode, 400);
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      expect('${body['error']}'.toLowerCase(), contains('insufficient'));

      final product = await h.isar.products.get(h.fixtures.lowStockProductId);
      expect(product!.stock, 2);
    });

    test('rejects deleted product', () async {
      final res = await h.post(
        LanApiPaths.sales,
        cashSaleDto(
          h,
          productId: h.fixtures.deletedProductId,
          qty: 1,
          unitPrice: 10,
        ).toJson(),
      );
      expect(res.statusCode, 400);
      final body = jsonDecode(res.body) as Map<String, dynamic>;
      expect(body['code'], 'product_missing');
    });
  });

  group('CORS / OPTIONS', () {
    test('OPTIONS returns CORS headers', () async {
      final request = http.Request('OPTIONS', Uri.parse('${h.baseUrl}${LanApiPaths.health}'));
      final streamed = await request.send();
      final res = await http.Response.fromStream(streamed);
      expect(res.statusCode, 200);
      expect(res.headers['access-control-allow-origin'], '*');
    });
  });
}