import 'dart:math';

import 'package:isar_community/isar.dart';

import 'collections/app_setting.dart';
import 'collections/dining_floor.dart';
import 'collections/dining_table.dart';

/// Seeds a sample Main floor with tables when restaurant profile is applied.
abstract final class RestaurantFloorSeed {
  static Future<void> ensureSampleFloor(Isar isar) async {
    final existing =
        await isar.diningFloors.filter().deletedAtIsNull().findFirst();
    if (existing != null) return;

    final now = DateTime.now();
    final secret =
        List.generate(24, (_) => _chars[_rng.nextInt(_chars.length)]).join();

    await isar.writeTxn(() async {
      final settings = await isar.appSettings
          .filter()
          .keyEqualTo('default')
          .findFirst();
      if (settings != null && settings.webToTableTokenSecret.isEmpty) {
        settings.webToTableTokenSecret = secret;
        await isar.appSettings.put(settings);
      }

      final floorId = await isar.diningFloors.put(
        DiningFloor()
          ..name = 'Main'
          ..sortOrder = 0
          ..isActive = true
          ..createdAt = now,
      );

      var n = 1;
      for (var row = 0; row < 3; row++) {
        for (var col = 0; col < 4; col++) {
          final code = 'T$n';
          final tokenSecret = settings?.webToTableTokenSecret.isNotEmpty == true
              ? settings!.webToTableTokenSecret
              : secret;
          await isar.diningTables.put(
            DiningTable()
              ..floorId = floorId
              ..code = code
              ..name = 'Table $n'
              ..capacity = n <= 4 ? 2 : (n <= 8 ? 4 : 6)
              ..status = 'free'
              ..posX = 12.0 + col * 22
              ..posY = 15.0 + row * 28
              ..shape = n % 3 == 0 ? 'round' : 'square'
              ..guestToken = _tokenFor(code, tokenSecret)
              ..createdAt = now,
          );
          n++;
        }
      }
    });
  }

  static String _tokenFor(String code, String secret) {
    final mix = '$secret:$code:${_rng.nextInt(1 << 32)}';
    return mix.hashCode.toRadixString(16).padLeft(8, '0') +
        List.generate(16, (_) => _chars[_rng.nextInt(_chars.length)]).join();
  }

  static final _rng = Random.secure();
  static const _chars =
      'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
}
