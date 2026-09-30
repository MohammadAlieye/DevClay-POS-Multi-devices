import 'package:flutter/material.dart';

import 'khata_balance.dart';

export 'khata_balance.dart' show KhataBalanceRules, KhataDirection;

/// Supplier-specific aliases over shared give/take rules.
abstract final class SupplierBalanceRules {
  static const Color payColor = KhataBalanceRules.giveColor;

  static const Color collectColor = KhataBalanceRules.takeColor;

  static const Color settledColor = KhataBalanceRules.settledColor;

  static KhataDirection direction(double balance) =>
      KhataBalanceRules.supplierDirection(balance);

  static Color colorFor(double balance) =>
      KhataBalanceRules.colorForSupplier(balance);

  static bool hasBalance(double balance) =>
      KhataBalanceRules.hasSupplierBalance(balance);

  static String statusLabel(double balance) =>
      KhataBalanceRules.statusLabelForSupplier(balance);

  static String detailLabel(double balance) =>
      KhataBalanceRules.supplierDetailLabel(balance);

  static String netDueLabel(double netDue) =>
      KhataBalanceRules.supplierNetLabel(netDue);
}
