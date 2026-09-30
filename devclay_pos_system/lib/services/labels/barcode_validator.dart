import 'package:barcode/barcode.dart';

import '../../../modules/labels/domain/entities/label_entities.dart';

abstract final class BarcodeValidator {
  /// Returns a value safe to render/print for the given symbology.
  static String encode(String value, LabelSymbology symbology) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return trimmed;

    return switch (symbology) {
      LabelSymbology.ean13 => _normalizeEan13(trimmed),
      LabelSymbology.code128 => trimmed,
      LabelSymbology.code39 => trimmed.toUpperCase(),
    };
  }

  static bool isValid(String value, LabelSymbology symbology) {
    final encoded = encode(value, symbology);
    if (encoded.isEmpty) return false;
    try {
      return _barcode(symbology).isValid(encoded);
    } catch (_) {
      return false;
    }
  }

  static bool wasEan13Corrected(String raw, String encoded) {
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    return digits.length >= 12 && raw.trim() != encoded;
  }

  static Barcode barcodeFor(LabelSymbology symbology) => _barcode(symbology);

  static String _normalizeEan13(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    if (digits.length < 12) return value;
    final base = digits.substring(0, 12);
    return '$base${_ean13CheckDigit(base)}';
  }

  static int _ean13CheckDigit(String twelveDigits) {
    if (twelveDigits.length != 12) {
      throw ArgumentError('EAN-13 requires 12 data digits.');
    }
    var sum = 0;
    for (var i = 0; i < 12; i++) {
      final digit = int.parse(twelveDigits[i]);
      sum += digit * (i.isEven ? 1 : 3);
    }
    final mod = sum % 10;
    return mod == 0 ? 0 : 10 - mod;
  }

  static Barcode _barcode(LabelSymbology symbology) {
    return switch (symbology) {
      LabelSymbology.code128 => Barcode.code128(),
      LabelSymbology.ean13 => Barcode.ean13(),
      LabelSymbology.code39 => Barcode.code39(),
    };
  }
}
