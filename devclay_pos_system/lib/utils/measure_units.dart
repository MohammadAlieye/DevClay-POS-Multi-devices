/// Weight/volume/length selling helpers. Stock is stored in integer base units:
/// grams, milliliters, millimeters, or pieces.
enum SellType { piece, weight, volume, length }

abstract final class MeasureUnits {
  static const _weightUnits = {'kg', 'g', 'gram', 'grams'};
  static const _volumeUnits = {'l', 'ml', 'liter', 'litre', 'liters', 'litres'};
  static const _lengthUnits = {
    'm',
    'meter',
    'meters',
    'metre',
    'metres',
    'cm',
    'mm',
    'half m',
    'half meter',
    'half metre',
  };

  static SellType inferSellType(String? unit) {
    final normalized = unit?.trim().toLowerCase() ?? '';
    if (_weightUnits.contains(normalized)) return SellType.weight;
    if (_volumeUnits.contains(normalized)) return SellType.volume;
    if (_lengthUnits.contains(normalized)) return SellType.length;
    return SellType.piece;
  }

  static bool isVariableUnit(String? unit) => inferSellType(unit) != SellType.piece;

  static bool isHalfMeterUnit(String? unit) {
    final normalized = unit?.trim().toLowerCase() ?? '';
    return normalized == 'half m' ||
        normalized == 'half meter' ||
        normalized == 'half metre';
  }

  static String sellTypeKey(SellType type) => switch (type) {
    SellType.piece => 'piece',
    SellType.weight => 'weight',
    SellType.volume => 'volume',
    SellType.length => 'length',
  };

  static SellType fromKey(String? key) => switch (key) {
    'weight' => SellType.weight,
    'volume' => SellType.volume,
    'length' => SellType.length,
    _ => SellType.piece,
  };

  /// Display unit → base-unit multiplier.
  static int unitMultiplier(String? unit) {
    final normalized = unit?.trim().toLowerCase() ?? '';
    if (isHalfMeterUnit(unit)) return 500;
    if (normalized == 'kg' || normalized == 'l' || normalized == 'm') {
      return 1000;
    }
    if (normalized == 'cm') return 10;
    return 1;
  }

  /// +/- step in display units (kg, L, m, half m, etc.).
  static double displayStep(String? unit, SellType sellType) {
    if (sellType == SellType.piece) return 1;
    if (isHalfMeterUnit(unit)) return 1;
    final normalized = unit?.trim().toLowerCase() ?? '';
    if (normalized == 'kg' ||
        normalized == 'l' ||
        normalized == 'm' ||
        normalized == 'meter' ||
        normalized == 'metre') {
      return 0.25;
    }
    return 1;
  }

  static int toBaseUnits(double displayQty, String? unit, SellType sellType) {
    if (displayQty <= 0) return 0;
    if (sellType == SellType.piece) {
      return displayQty.round().clamp(0, 999999999);
    }
    return (displayQty * unitMultiplier(unit)).round().clamp(0, 999999999);
  }

  static double fromBaseUnits(int baseQty, String? unit, SellType sellType) {
    if (sellType == SellType.piece) return baseQty.toDouble();
    return baseQty / unitMultiplier(unit);
  }

  static int amountToBaseUnits({
    required double amountRs,
    required double pricePerDisplayUnit,
    required String? unit,
    required SellType sellType,
  }) {
    if (amountRs <= 0 || pricePerDisplayUnit <= 0) return 0;
    return toBaseUnits(amountRs / pricePerDisplayUnit, unit, sellType);
  }

  static String formatQuantity(int baseQty, String? unit, SellType sellType) {
    if (sellType == SellType.piece) {
      return '$baseQty ${unit?.trim().isNotEmpty == true ? unit!.trim() : 'pcs'}';
    }
    final display = fromBaseUnits(baseQty, unit, sellType);
    final formatted = formatDisplayInput(display);
    final label = unit?.trim() ?? '';
    return label.isEmpty ? formatted : '$formatted $label';
  }

  static String formatStock(int baseQty, String? unit, SellType sellType) {
    if (baseQty <= 0) return 'Out';
    return formatQuantity(baseQty, unit, sellType);
  }

  static String formatRate(double priceRs, String? unit, SellType sellType) {
    if (sellType == SellType.piece) {
      return 'Rs ${priceRs.toStringAsFixed(priceRs == priceRs.roundToDouble() ? 0 : 2)}';
    }
    final label = unit?.trim() ?? '';
    final price = priceRs.toStringAsFixed(
      priceRs == priceRs.roundToDouble() ? 0 : 2,
    );
    return label.isEmpty ? 'Rs $price' : 'Rs $price/$label';
  }

  static String amountWorthLabel(double amountRs) =>
      'Rs ${amountRs.toStringAsFixed(amountRs == amountRs.roundToDouble() ? 0 : 2)} worth';

  /// Parses decimal qty from cart input: `1.23`, `.95`, `0,5`.
  static double? parseDecimalInput(String raw) {
    var text = raw.trim().replaceAll(',', '.');
    if (text.isEmpty || text == '.') return null;
    if (text.startsWith('.')) text = '0$text';
    return double.tryParse(text);
  }

  static String formatDisplayInput(double value) {
    if (value == value.roundToDouble()) {
      return value.toStringAsFixed(0);
    }
    return _trimDecimals(value, 3);
  }

  static String _trimDecimals(double value, int maxDecimals) {
    final text = value.toStringAsFixed(maxDecimals);
    if (!text.contains('.')) return text;
    return text.replaceFirst(RegExp(r'0+$'), '').replaceFirst(RegExp(r'\.$'), '');
  }
}
