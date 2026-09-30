import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:devclay_pos_system/database/collections/sale.dart';
import 'package:flutter_test/flutter_test.dart';
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

  test('concurrent sales never oversell and keep unique invoices', () async {
    // Low-stock product has qty 2 — fire 5 parallel attempts for qty 1.
    final futures = List.generate(
      5,
      (_) => h.saleWrite
          .createSale(
            cashSaleDto(
              h,
              productId: h.fixtures.lowStockProductId,
              qty: 1,
              unitPrice: 50,
            ),
          )
          .then<Object?>((v) => v)
          .catchError((Object e) => e),
    );

    final results = await Future.wait(futures);
    final successes = results.whereType<Map<String, dynamic>>().toList();
    final failures = results.where((r) => r is! Map).toList();

    expect(successes.length, 2);
    expect(failures.length, 3);

    final invoices = successes.map((s) => s['invoiceNo']).toSet();
    expect(invoices.length, 2);

    final product =
        await h.isar.products.get(h.fixtures.lowStockProductId);
    expect(product!.stock, 0);

    final sales = await h.isar.sales.where().findAll();
    expect(sales.length, 2);
  });

  test('parallel HTTP POSTs serialize via host lock', () async {
    final futures = List.generate(4, (i) {
      return h.post(
        '/api/v1/sales',
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
        ).toJson(),
      );
    });
    final responses = await Future.wait(futures);
    final ok = responses.where((r) => r.statusCode == 200).length;
    expect(ok, 4);

    final product = await h.isar.products.get(h.fixtures.productId);
    expect(product!.stock, 6);

    final sales = await h.isar.sales.where().findAll();
    final invoices = sales.map((s) => s.invoiceNo).toSet();
    expect(invoices.length, sales.length);
  });
}
