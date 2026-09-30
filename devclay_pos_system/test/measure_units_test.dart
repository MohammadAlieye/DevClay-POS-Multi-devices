import 'package:devclay_pos_system/utils/measure_units.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MeasureUnits', () {
    test('converts kg to grams and back', () {
      expect(
        MeasureUnits.toBaseUnits(0.25, 'kg', SellType.weight),
        250,
      );
      expect(
        MeasureUnits.fromBaseUnits(250, 'kg', SellType.weight),
        0.25,
      );
    });

    test('converts L to ml and back', () {
      expect(
        MeasureUnits.toBaseUnits(50, 'L', SellType.volume),
        50000,
      );
      expect(
        MeasureUnits.fromBaseUnits(49750, 'L', SellType.volume),
        49.75,
      );
    });

    test('milk 50L minus 250ml leaves 49.75L', () {
      const stock = 50000;
      const sold = 250;
      final remaining = stock - sold;
      expect(
        MeasureUnits.formatQuantity(remaining, 'L', SellType.volume),
        '49.75 L',
      );
    });

    test('Rs 100 of daal at Rs 480/kg', () {
      final base = MeasureUnits.amountToBaseUnits(
        amountRs: 100,
        pricePerDisplayUnit: 480,
        unit: 'kg',
        sellType: SellType.weight,
      );
      expect(base, 208);
      expect(
        MeasureUnits.formatQuantity(base, 'kg', SellType.weight),
        '0.208 kg',
      );
    });

    test('piece products stay integer', () {
      expect(
        MeasureUnits.toBaseUnits(3, 'pcs', SellType.piece),
        3,
      );
      expect(MeasureUnits.inferSellType('pcs'), SellType.piece);
      expect(MeasureUnits.inferSellType('kg'), SellType.weight);
      expect(MeasureUnits.inferSellType('L'), SellType.volume);
    });

    test('converts half meter to mm and back', () {
      expect(
        MeasureUnits.toBaseUnits(3, 'half m', SellType.length),
        1500,
      );
      expect(
        MeasureUnits.fromBaseUnits(750, 'half m', SellType.length),
        1.5,
      );
    });

    test('parseDecimalInput accepts leading dot and comma', () {
      expect(MeasureUnits.parseDecimalInput('.95'), 0.95);
      expect(MeasureUnits.parseDecimalInput('1.23'), 1.23);
      expect(MeasureUnits.parseDecimalInput('0,5'), 0.5);
    });
  });
}
