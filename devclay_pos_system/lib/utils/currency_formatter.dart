import 'package:intl/intl.dart';

/// Pakistan Rupee formatting helpers.
abstract final class CurrencyFormatter {
  static final NumberFormat _pkr = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ',
    decimalDigits: 0,
  );

  static final NumberFormat _pkrPrecise = NumberFormat.currency(
    locale: 'en_PK',
    symbol: 'Rs ',
    decimalDigits: 2,
  );

  static String format(num amount, {bool precise = false}) {
    final value = amount.isNaN || amount.isInfinite ? 0 : amount;
    return (precise ? _pkrPrecise : _pkr).format(value);
  }

  static String compact(num amount) {
    if (amount.abs() >= 1000000) {
      return 'Rs ${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount.abs() >= 1000) {
      return 'Rs ${(amount / 1000).toStringAsFixed(1)}K';
    }
    return format(amount);
  }

  /// Short labels for chart Y-axis (no currency prefix, no wrap).
  static String axisCompact(num amount) {
    if (amount.abs() >= 1000000) {
      return '${(amount / 1000000).toStringAsFixed(1)}M';
    }
    if (amount.abs() >= 1000) {
      return '${(amount / 1000).toStringAsFixed(0)}K';
    }
    return amount.round().toString();
  }
}
