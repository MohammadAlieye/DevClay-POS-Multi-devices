import 'dart:convert';

import 'package:devclay_pos_system/core/lan_api/lan_api_paths.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/isar_test_bootstrap.dart';
import 'lan_sale_fixtures.dart';
import 'lan_test_harness.dart';

/// Production-contract tests — secure/correct LAN behavior after P0 fixes.
void main() {
  late LanTestHarness h;

  setUpAll(ensureIsarCoreInitialized);

  setUp(() async {
    h = await LanTestHarness.start();
  });

  tearDown(() async {
    await h.dispose();
  });

  test('POST /sales without auth returns 401', () async {
    final res = await h.post(
      LanApiPaths.sales,
      cashSaleDto(
        h,
        productId: h.fixtures.productId,
        qty: 1,
        unitPrice: 100,
      ).toJson(),
      authed: false,
    );
    expect(res.statusCode, 401);
  });

  test('GET /products without auth returns 401', () async {
    final res = await h.get(LanApiPaths.products, authed: false);
    expect(res.statusCode, 401);
  });

  test('host recomputes sale total from lines', () async {
    final res = await h.post(
      LanApiPaths.sales,
      cashSaleDto(
        h,
        productId: h.fixtures.productId,
        qty: 1,
        unitPrice: 100,
        totalOverride: 1,
      ).toJson(),
    );
    expect(res.statusCode, 200);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    expect(body['total'], 100);
  });

  test('inactive products cannot be sold', () async {
    final res = await h.post(
      LanApiPaths.sales,
      cashSaleDto(
        h,
        productId: h.fixtures.inactiveProductId,
        qty: 1,
        unitPrice: 10,
      ).toJson(),
    );
    expect(res.statusCode, anyOf(400, 404));
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    expect(body['code'], anyOf('product_inactive', 'product_missing'));
  });

  test('insufficient stock returns insufficient_stock code', () async {
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
    expect(body['code'], 'insufficient_stock');
  });

  test('khata without customerId is rejected', () async {
    final res = await h.post(
      LanApiPaths.sales,
      cashSaleDto(
        h,
        productId: h.fixtures.productId,
        qty: 1,
        unitPrice: 100,
        methodKind: 'khata',
        amountPaid: 0,
      ).toJson(),
    );
    expect(res.statusCode, 400);
    final body = jsonDecode(res.body) as Map<String, dynamic>;
    expect(body['code'], 'khata_customer_required');
  });

  test('LanApiClient exposes next-invoice preview', () async {
    final preview = await h.client.fetchNextInvoicePreview();
    expect(preview, startsWith('INV-'));
  });
}
