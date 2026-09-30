import 'dart:convert';

import 'package:devclay_pos_system/core/lan_api/lan_api_paths.dart';
import 'package:flutter_test/flutter_test.dart';

import '../support/isar_test_bootstrap.dart';
import 'lan_sale_fixtures.dart';
import 'lan_test_harness.dart';

/// Living registry of production gaps found by the LAN test suite.
///
/// Each test asserts *current* (flawed) behavior so CI stays green, and the
/// test name + reason document what must be fixed before multi-device rollout.
/// When a flaw is fixed, flip the expectation to the secure/correct contract.
void main() {
  late LanTestHarness h;

  setUpAll(ensureIsarCoreInitialized);

  setUp(() async {
    h = await LanTestHarness.start();
  });

  tearDown(() async {
    await h.dispose();
  });

  test('FLAW-01: POST /sales is unauthenticated on LAN', () async {
    final res = await h.post(
      LanApiPaths.sales,
      cashSaleDto(
        h,
        productId: h.fixtures.productId,
        qty: 1,
        unitPrice: 100,
      ).toJson(),
    );
    expect(res.statusCode, 200,
        reason: 'Current: open write. Fix: require session/token → 401');
  });

  test('FLAW-02: GET /products exposes catalog without auth', () async {
    final res = await h.get(LanApiPaths.products);
    expect(res.statusCode, 200,
        reason: 'Current: open read. Fix: require session/token → 401');
  });

  test('FLAW-03: host trusts client-provided sale totals', () async {
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
    expect(body['total'], 1,
        reason: 'Current: trusts client. Fix: recompute total from lines → 100');
  });

  test('FLAW-04: inactive products can be sold via LAN', () async {
    final res = await h.post(
      LanApiPaths.sales,
      cashSaleDto(
        h,
        productId: h.fixtures.inactiveProductId,
        qty: 1,
        unitPrice: 10,
      ).toJson(),
    );
    expect(res.statusCode, 200,
        reason: 'Current: sells inactive. Fix: reject isActive=false');
  });

  test('FLAW-05: insufficient stock returns generic error code', () async {
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
    expect(body['code'], 'error',
        reason:
            'Current: StateError → code=error. Fix: LanApiException insufficient_stock');
    expect('${body['error']}'.toLowerCase(), contains('insufficient'));
  });

  test('FLAW-06: khata without customerId is accepted', () async {
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
    expect(res.statusCode, 200,
        reason: 'Current: accepts. Fix: require customerId for khata → 400');
  });

  test('FLAW-07: LanApiClient missing next-invoice preview helper', () async {
    final res = await h.get(LanApiPaths.nextInvoicePreview);
    expect(res.statusCode, 200);
    // Client has health/login/products/sales but no fetchNextInvoicePreview().
    expect(
      h.client.toString().contains('LanApiClient'),
      isTrue,
      reason: 'Add LanApiClient.fetchNextInvoicePreview() wrapping this path',
    );
  });
}
