import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import 'currency_formatter.dart';

/// Shop perspective: **Take** = collect money (green). **Give** = pay out (red).
enum KhataDirection {
  take,
  give,
  settled,
}

/// Hard-coded give/take colour and label rules — use everywhere.
abstract final class KhataBalanceRules {
  static const Color takeColor = AppColors.success;

  static const Color giveColor = AppColors.danger;

  static const Color settledColor = AppColors.textSecondary;

  /// Missing Isar doubles (new field on old rows) read as NaN and break totals.
  static double money(double value) {
    if (value.isNaN || value.isInfinite) return 0;
    return value;
  }

  /// Customer khata: positive = take, negative = give.
  static KhataDirection direction(double balance) {
    final value = money(balance);
    if (value > 0.001) return KhataDirection.take;
    if (value < -0.001) return KhataDirection.give;
    return KhataDirection.settled;
  }

  /// Supplier khata / payables: positive = give, negative = take.
  static KhataDirection supplierDirection(double balance) {
    final value = money(balance);
    if (value > 0.001) return KhataDirection.give;
    if (value < -0.001) return KhataDirection.take;
    return KhataDirection.settled;
  }

  /// Unpaid purchase invoice: money the shop still needs to give.
  static KhataDirection payableDirection(double unpaid) {
    final value = money(unpaid);
    if (value > 0.001) return KhataDirection.give;
    return KhataDirection.settled;
  }

  static Color colorForDirection(KhataDirection direction) =>
      switch (direction) {
        KhataDirection.take => takeColor,
        KhataDirection.give => giveColor,
        KhataDirection.settled => settledColor,
      };

  static Color colorFor(double balance) => colorForDirection(direction(balance));

  static Color colorForSupplier(double balance) =>
      colorForDirection(supplierDirection(balance));

  static Color colorForPayable(double unpaid) =>
      colorForDirection(payableDirection(unpaid));

  static double absAmount(double balance) => balance.abs();

  static bool hasBalance(double balance) =>
      direction(balance) != KhataDirection.settled;

  static bool hasSupplierBalance(double balance) =>
      supplierDirection(balance) != KhataDirection.settled;

  static String statusLabel(KhataDirection direction) => switch (direction) {
        KhataDirection.take => 'Take',
        KhataDirection.give => 'Give',
        KhataDirection.settled => 'Settled',
      };

  static String statusLabelFor(double balance) => statusLabel(direction(balance));

  static String statusLabelForSupplier(double balance) =>
      statusLabel(supplierDirection(balance));

  static String amountLabelFor(KhataDirection direction, double amount) {
    final value = money(amount).abs();
    return switch (direction) {
      KhataDirection.take => 'Take ${CurrencyFormatter.format(value)}',
      KhataDirection.give => 'Give ${CurrencyFormatter.format(value)}',
      KhataDirection.settled => 'Settled',
    };
  }

  static String amountLabel(double balance) =>
      amountLabelFor(direction(balance), balance);

  static String detailLabel(double balance) => amountLabel(balance);

  static String supplierDetailLabel(double balance) =>
      amountLabelFor(supplierDirection(balance), balance);

  static String supplierNetLabel(double netAmount) =>
      amountLabelFor(supplierDirection(netAmount), netAmount);

  static String payableLabel(double unpaid) =>
      amountLabelFor(payableDirection(unpaid), unpaid);

  static String posSearchSubtitle(String phone, double balance) {
    final contact = phone.trim();
    final khata = amountLabel(balance);
    if (contact.isEmpty) return khata;
    return '$contact · $khata';
  }

  static String ledgerBalanceLabel(double balanceAfter) =>
      amountLabel(balanceAfter);

  static String portfolioTakeLabel(double amount) =>
      'Take ${CurrencyFormatter.format(amount)}';

  static String portfolioGiveLabel(double amount) =>
      'Give ${CurrencyFormatter.format(amount)}';
}

class KhataPortfolioSummary {
  const KhataPortfolioSummary({
    required this.toTake,
    required this.toGive,
    required this.takeCount,
    required this.giveCount,
  });

  final double toTake;
  final double toGive;
  final int takeCount;
  final int giveCount;

  factory KhataPortfolioSummary.fromBalances(Iterable<double> balances) {
    var take = 0.0;
    var give = 0.0;
    var takeCount = 0;
    var giveCount = 0;
    for (final balance in balances) {
      switch (KhataBalanceRules.direction(balance)) {
        case KhataDirection.take:
          take += balance;
          takeCount++;
        case KhataDirection.give:
          give += balance.abs();
          giveCount++;
        case KhataDirection.settled:
          break;
      }
    }
    return KhataPortfolioSummary(
      toTake: take,
      toGive: give,
      takeCount: takeCount,
      giveCount: giveCount,
    );
  }
}
