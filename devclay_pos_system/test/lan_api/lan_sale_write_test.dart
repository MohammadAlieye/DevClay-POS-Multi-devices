import 'dart:convert';

import 'package:devclay_pos_system/core/lan_api/dtos/lan_dtos.dart';
import 'package:devclay_pos_system/core/lan_api/lan_api_errors.dart';
import 'package:devclay_pos_system/database/collections/account.dart';
import 'package:devclay_pos_system/database/collections/audit_entry.dart';
import 'package:devclay_pos_system/database/collections/customer.dart';
import 'package:devclay_pos_system/database/collections/customer_ledger_entry.dart';
import 'package:devclay_pos_system/database/collections/ledger_entry.dart';
import 'package:devclay_pos_system/database/collections/product.dart';
import 'package:devclay_pos_system/database/collections/product_batch.dart';
import 'package:devclay_pos_system/database/collections/product_variant.dart';
import 'package:devclay_pos_system/database/collections/sale.dart';
import 'package:devclay_pos_system/database/collections/stock_movement.dart';
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

  group('FEFO / batch allocation', () {
    test('deducts earliest-expiry batch first', () async {
      await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 3,
          unitPrice: 100,
        ),
      );

      final early =
          await h.isar.productBatchs.get(h.fixtures.batchEarlyId);
      final late = await h.isar.productBatchs.get(h.fixtures.batchLateId);
      expect(early!.quantity, 2);
      expect(late!.quantity, 5);
    });

    test('honors explicit batchId selection', () async {
      await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 2,
          unitPrice: 100,
          batchId: h.fixtures.batchLateId,
        ),
      );

      final early =
          await h.isar.productBatchs.get(h.fixtures.batchEarlyId);
      final late = await h.isar.productBatchs.get(h.fixtures.batchLateId);
      expect(early!.quantity, 5);
      expect(late!.quantity, 3);
    });

    test('stores batch allocations on sale lines', () async {
      final result = await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 6,
          unitPrice: 100,
        ),
      );
      final sale = await h.isar.sales.get(result['id'] as int);
      final lines = jsonDecode(sale!.linesJson) as List;
      final allocations = lines.first['batchAllocations'] as List;
      expect(allocations.length, 2);
      expect(allocations.first['batchCode'], 'B-EARLY');
      expect(allocations.first['quantity'], 5);
      expect(allocations.last['batchCode'], 'B-LATE');
      expect(allocations.last['quantity'], 1);
    });
  });

  group('payments / ledger', () {
    test('cash sale deposits into cash account', () async {
      final before =
          (await h.isar.accounts.get(h.fixtures.cashAccountId))!.balance;
      await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
        ),
      );
      final after =
          (await h.isar.accounts.get(h.fixtures.cashAccountId))!.balance;
      expect(after, before + 100);

      final ledger = await h.isar.ledgerEntrys.where().findAll();
      expect(ledger.any((e) => e.amount == 100 && e.type == 'income'), isTrue);
    });

    test('card sale deposits into bank account', () async {
      final before =
          (await h.isar.accounts.get(h.fixtures.bankAccountId))!.balance;
      await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
          methodKind: 'card',
        ),
      );
      final after =
          (await h.isar.accounts.get(h.fixtures.bankAccountId))!.balance;
      expect(after, before + 100);
    });

    test('split sale deposits cash + card portions', () async {
      final cashBefore =
          (await h.isar.accounts.get(h.fixtures.cashAccountId))!.balance;
      final bankBefore =
          (await h.isar.accounts.get(h.fixtures.bankAccountId))!.balance;

      await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
          methodKind: 'split',
          amountPaid: 40,
          cardAmount: 60,
        ),
      );

      final cashAfter =
          (await h.isar.accounts.get(h.fixtures.cashAccountId))!.balance;
      final bankAfter =
          (await h.isar.accounts.get(h.fixtures.bankAccountId))!.balance;
      expect(cashAfter, cashBefore + 40);
      expect(bankAfter, bankBefore + 60);
    });

    test('khata sale updates customer balance and ledger', () async {
      await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 2,
          unitPrice: 100,
          methodKind: 'khata',
          customerId: h.fixtures.customerId,
          amountPaid: 50,
        ),
      );

      final customer =
          await h.isar.customers.get(h.fixtures.customerId);
      expect(customer!.balance, 150);

      final entries = await h.isar.customerLedgerEntrys
          .filter()
          .customerIdEqualTo(h.fixtures.customerId)
          .findAll();
      expect(entries.length, 2);
      expect(entries.first.type, 'debit');
      expect(entries.first.amount, 200);
      expect(entries.last.type, 'credit');
      expect(entries.last.amount, 50);
    });

    test('documented gap: khata without customer skips ledger silently',
        () async {
      final result = await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
          methodKind: 'khata',
          amountPaid: 0,
        ),
      );
      expect(result['id'], isA<int>());
      final entries = await h.isar.customerLedgerEntrys.where().findAll();
      expect(entries, isEmpty);
    });
  });

  group('variants / stock movements / audit', () {
    test('variant sale decrements variant and parent stock', () async {
      await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.variantProductId,
          qty: 1,
          unitPrice: 800,
          variantId: h.fixtures.variantId,
        ),
      );

      final variant =
          await h.isar.productVariants.get(h.fixtures.variantId);
      final parent =
          await h.isar.products.get(h.fixtures.variantProductId);
      expect(variant!.stock, 3);
      expect(parent!.stock, 3);
    });

    test('writes stock movement and audit entry', () async {
      final result = await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
        ),
      );

      final movements = await h.isar.stockMovements.where().findAll();
      expect(movements.any((m) => m.type == 'sale' && m.quantityChange == -1),
          isTrue);

      final audits = await h.isar.auditEntrys.where().findAll();
      expect(
        audits.any(
          (a) =>
              a.action == 'sale.completed' && a.entityId == result['id'],
        ),
        isTrue,
      );
    });
  });

  group('invoice sequencing', () {
    test('preview does not reserve; create allocates unique invoices',
        () async {
      final preview1 = await h.saleWrite.previewNextInvoiceNo();
      final preview2 = await h.saleWrite.previewNextInvoiceNo();
      expect(preview1, preview2);

      final a = await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
        ),
      );
      final b = await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
        ),
      );
      expect(a['invoiceNo'], isNot(equals(b['invoiceNo'])));
      expect(a['invoiceNo'], 'INV-000001');
      expect(b['invoiceNo'], 'INV-000002');
    });
  });

  group('integrity / trust boundaries', () {
    test('documented gap: host trusts client-provided totals', () async {
      final result = await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.productId,
          qty: 1,
          unitPrice: 100,
          totalOverride: 1,
        ),
      );
      final sale = await h.isar.sales.get(result['id'] as int);
      expect(sale!.total, 1);
      expect(result['total'], 1);
    });

    test('documented gap: inactive product can still be sold by id', () async {
      // Seed stock lot for inactive product so deduct can succeed.
      final inactive =
          await h.isar.products.get(h.fixtures.inactiveProductId);
      await h.isar.writeTxn(() async {
        await h.isar.productBatchs.put(
          ProductBatch()
            ..productId = inactive!.id
            ..quantity = 5
            ..receivedAt = DateTime.now()
            ..batchCode = 'B-OFF',
        );
        inactive.stock = 5;
        await h.isar.products.put(inactive);
      });

      final result = await h.saleWrite.createSale(
        cashSaleDto(
          h,
          productId: h.fixtures.inactiveProductId,
          qty: 1,
          unitPrice: 10,
        ),
      );
      expect(result['id'], isA<int>());
    });

    test('invalid quantity throws LanApiException', () async {
      await expectLater(
        h.saleWrite.createSale(
          LanCreateSaleDto(
            linesJson: jsonEncode([
              {'productId': h.fixtures.productId, 'quantity': 0},
            ]),
            cashierId: 1,
            cashierName: 'x',
            subtotal: 0,
            tax: 0,
            total: 0,
            discount: 0,
            paymentMethod: 'Cash',
            amountPaid: 0,
            cardAmount: 0,
            changeAmount: 0,
            itemCount: 0,
          ),
        ),
        throwsA(
          isA<LanApiException>().having(
            (e) => e.code,
            'code',
            'invalid_line',
          ),
        ),
      );
    });
  });
}
