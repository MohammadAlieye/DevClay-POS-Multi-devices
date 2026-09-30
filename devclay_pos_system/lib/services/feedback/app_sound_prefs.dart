import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'app_sound_service.dart';

/// Persisted sound feedback preferences.
class AppSoundPrefs {
  AppSoundPrefs._();
  static final AppSoundPrefs instance = AppSoundPrefs._();

  static const _fileName = 'app_sound_prefs.json';

  bool enabled = true;
  double volume = 0.65;
  bool cartSounds = true;
  bool notificationSounds = true;
  bool tapSounds = false;

  bool allows(AppSound sound) {
    if (!enabled) return false;
    return switch (sound) {
      AppSound.tap => tapSounds,
      AppSound.cartAdd || AppSound.cartRemove => cartSounds,
      AppSound.success || AppSound.error || AppSound.info => notificationSounds,
    };
  }

  Future<void> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) return;
      final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      enabled = map['enabled'] != false;
      volume = ((map['volume'] as num?) ?? 0.65).clamp(0.0, 1.0).toDouble();
      cartSounds = map['cartSounds'] != false;
      notificationSounds = map['notificationSounds'] != false;
      tapSounds = map['tapSounds'] == true;
    } catch (_) {
      // Keep defaults.
    }
  }

  Future<void> save() async {
    try {
      final file = await _file();
      await file.writeAsString(
        jsonEncode({
          'enabled': enabled,
          'volume': volume,
          'cartSounds': cartSounds,
          'notificationSounds': notificationSounds,
          'tapSounds': tapSounds,
        }),
      );
    } catch (_) {
      // Best-effort.
    }
  }

  Future<void> update({
    bool? enabled,
    double? volume,
    bool? cartSounds,
    bool? notificationSounds,
    bool? tapSounds,
  }) async {
    if (enabled != null) this.enabled = enabled;
    if (volume != null) this.volume = volume.clamp(0.0, 1.0);
    if (cartSounds != null) this.cartSounds = cartSounds;
    if (notificationSounds != null) this.notificationSounds = notificationSounds;
    if (tapSounds != null) this.tapSounds = tapSounds;
    await save();
  }

  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }
}
