import 'package:isar_community/isar.dart';

import 'collections/app_setting.dart';
import 'collections/product.dart';
import 'collections/product_batch.dart';
import '../utils/measure_units.dart';

/// Converts legacy kg/L integer stock counts to gram/ml base units.
abstract final class StockBaseUnitsMigration {
  static Future<void> runIfNeeded(Isar isar) async {
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null || settings.stockBaseUnitsMigrated) return;

    await isar.writeTxn(() async {
      final products = await isar.products.where().findAll();
      for (final product in products) {
        final sellType = MeasureUnits.inferSellType(product.unit);
        product.sellType = MeasureUnits.sellTypeKey(sellType);
        if (sellType == SellType.piece) {
          await isar.products.put(product);
          continue;
        }

        final unit = product.unit?.trim().toLowerCase() ?? '';
        final needsScale = unit == 'kg' || unit == 'l' || unit == 'm';
        if (needsScale && product.stock > 0) {
          product.stock *= 1000;
        }

        final batches = await isar.productBatchs
            .filter()
            .productIdEqualTo(product.id)
            .findAll();
        for (final batch in batches) {
          if (needsScale && batch.quantity > 0) {
            batch.quantity *= 1000;
            await isar.productBatchs.put(batch);
          }
        }

        await isar.products.put(product);
      }

      settings.stockBaseUnitsMigrated = true;
      await isar.appSettings.put(settings);
    });
  }
}
