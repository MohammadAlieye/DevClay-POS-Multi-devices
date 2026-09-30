import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Shared input limits for product / catalog fields.
abstract final class FieldLimits {
  static const int name = 80;
  static const int sku = 40;
  static const int barcode = 32;
  static const int category = 40;
  static const int brand = 40;
  static const int unit = 24;
  static const int priceDigits = 9;
  static const int tax = 5;
  static const int stock = 7;

  static final List<TextInputFormatter> money = [
    TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;
      if (text.isEmpty) return newValue;
      if (RegExp(r'^\d{0,9}(\.\d{0,2})?$').hasMatch(text)) {
        return newValue;
      }
      return oldValue;
    }),
  ];

  static final List<TextInputFormatter> taxPercent = [
    TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text;
      if (text.isEmpty) return newValue;
      if (RegExp(r'^\d{0,3}(\.\d{0,2})?$').hasMatch(text)) {
        return newValue;
      }
      return oldValue;
    }),
  ];

  static final List<TextInputFormatter> stockQty = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(stock),
  ];

  /// Decimal quantity for weight/volume/length (e.g. 1.23, .95, 0.250).
  static final List<TextInputFormatter> decimalQty = [
    TextInputFormatter.withFunction((oldValue, newValue) {
      final text = newValue.text.replaceAll(',', '.');
      if (text.isEmpty) return newValue;
      if (RegExp(r'^(\d{0,9}(\.\d{0,3})?|\.\d{0,3})$').hasMatch(text)) {
        return newValue.copyWith(
          text: text,
          selection: newValue.selection,
          composing: newValue.composing,
        );
      }
      return oldValue;
    }),
  ];

  static final List<TextInputFormatter> barcodeChars = [
    FilteringTextInputFormatter.allow(RegExp(r'[A-Za-z0-9\-]')),
    LengthLimitingTextInputFormatter(barcode),
  ];
}

/// Default sellable units (Pakistan retail / restaurant friendly).
abstract final class DefaultProductUnits {
  /// Measure-critical units used for stock math (g/ml/mm/pcs).
  /// These stay locked in Settings so shop stock does not break.
  static const List<String> base = [
    'pcs',
    'kg',
    'g',
    'L',
    'ml',
    'm',
    'half m',
    'cm',
    'mm',
  ];

  /// Optional shop shortcuts (piece-style). Safe to add/remove.
  static const List<String> customDefaults = [
    'half',
    'full',
    'karahi',
    'plate',
    'dozen',
    'pack',
    'box',
  ];

  static const List<String> all = [...base, ...customDefaults];

  static bool isBase(String unit) {
    final key = unit.trim().toLowerCase();
    return base.any((b) => b.toLowerCase() == key);
  }

  static String toCsv(List<String> units) =>
      units.map((u) => u.trim()).where((u) => u.isNotEmpty).join(',');

  /// Always keeps [base] units first, then unique custom units.
  static List<String> fromCsv(String? csv) {
    final parsed = (csv == null || csv.trim().isEmpty)
        ? List<String>.from(all)
        : csv
            .split(',')
            .map((u) => u.trim())
            .where((u) => u.isNotEmpty)
            .toList();
    return mergeWithBase(parsed);
  }

  static List<String> mergeWithBase(Iterable<String> units) {
    final custom = <String>[];
    final seen = <String>{};
    for (final baseUnit in base) {
      seen.add(baseUnit.toLowerCase());
    }
    for (final unit in units) {
      final trimmed = unit.trim();
      if (trimmed.isEmpty) continue;
      final key = trimmed.toLowerCase();
      if (seen.contains(key)) continue;
      seen.add(key);
      custom.add(trimmed);
    }
    return [...base, ...custom];
  }
}

/// Suggested product categories for chips (shop can add more).
abstract final class DefaultProductCategories {
  static const List<String> all = [
    'Grocery',
    'Beverages',
    'Dairy',
    'Snacks',
    'Personal Care',
    'Household',
    'Electronics',
    'Other',
  ];

  static String toCsv(List<String> categories) => categories
      .map((c) => c.trim())
      .where((c) => c.isNotEmpty)
      .join(',');

  static List<String> fromCsv(String? csv) {
    if (csv == null || csv.trim().isEmpty) {
      return List<String>.from(all);
    }
    final parsed = csv
        .split(',')
        .map((c) => c.trim())
        .where((c) => c.isNotEmpty)
        .toList();
    return parsed.isEmpty ? List<String>.from(all) : _uniquePreserveOrder(parsed);
  }

  static List<String> _uniquePreserveOrder(List<String> values) {
    final seen = <String>{};
    final out = <String>[];
    for (final value in values) {
      final key = value.toLowerCase();
      if (seen.contains(key)) continue;
      seen.add(key);
      out.add(value);
    }
    return out;
  }
}

/// Chip wrap that scrolls after roughly [maxLines] rows.
class ScrollableChipWrap extends StatelessWidget {
  const ScrollableChipWrap({
    super.key,
    required this.children,
    this.maxLines = 3,
    this.spacing = 6,
    this.runSpacing = 6,
  });

  final List<Widget> children;
  final int maxLines;
  final double spacing;
  final double runSpacing;

  @override
  Widget build(BuildContext context) {
    final maxHeight = (32.0 * maxLines) + (runSpacing * (maxLines - 1)) + 12;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            children: children,
          ),
        ),
      ),
    );
  }
}
