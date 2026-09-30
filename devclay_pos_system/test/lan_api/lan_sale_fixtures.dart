import 'dart:convert';

import 'package:devclay_pos_system/core/lan_api/dtos/lan_dtos.dart';

import 'lan_test_harness.dart';

LanCreateSaleDto cashSaleDto(
  LanTestHarness h, {
  required int productId,
  required int qty,
  required double unitPrice,
  int? variantId,
  int? batchId,
  double lineDiscount = 0,
  String methodKind = 'cash',
  int? customerId,
  String? customerName,
  double? amountPaid,
  double cardAmount = 0,
  double? totalOverride,
  double? discountOverride,
}) {
  final lineGross = (unitPrice * qty) - lineDiscount;
  final lineTotal = lineGross;
  final total = totalOverride ?? lineTotal;
  final paid = amountPaid ?? total;
  return LanCreateSaleDto(
    linesJson: jsonEncode([
      {
        'productId': productId,
        if (variantId != null) 'variantId': variantId,
        if (batchId != null) 'batchId': batchId,
        'quantity': qty,
        'unitPrice': unitPrice,
        'lineDiscount': lineDiscount,
        'lineTotal': lineTotal,
        'name': 'line',
      },
    ]),
    cashierId: h.fixtures.adminUserId,
    cashierName: 'Admin',
    subtotal: unitPrice * qty,
    tax: 0,
    total: total,
    discount: discountOverride ?? lineDiscount,
    paymentMethod: switch (methodKind) {
      'khata' => 'Khata',
      'card' => 'Card',
      'wallet' => 'JazzCash / Easypaisa',
      'split' => 'Split',
      _ => 'Cash',
    },
    amountPaid: paid,
    cardAmount: cardAmount,
    changeAmount: (paid - total).clamp(0, double.infinity),
    itemCount: qty,
    customerId: customerId,
    customerName: customerName,
    cashAccountId: h.fixtures.cashAccountId,
    bankAccountId: h.fixtures.bankAccountId,
    methodKind: methodKind,
  );
}
