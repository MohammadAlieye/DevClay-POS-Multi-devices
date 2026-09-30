import 'package:audioplayers/audioplayers.dart';

import 'app_sound_prefs.dart';

enum AppSound {
  tap,
  cartAdd,
  cartRemove,
  success,
  error,
  info,
}

/// Short UI sounds bundled under [assets/sounds/].
abstract final class AppSounds {
  static final AppSoundsService instance = AppSoundsService._();

  static void play(AppSound sound) => instance.play(sound);

  static Future<void> init() => instance.init();
}

final class AppSoundsService {
  AppSoundsService._();

  final _players = <AppSound, AudioPlayer>{};
  DateTime? _lastCartSound;
  var _ready = false;

  Future<void> init() async {
    await AppSoundPrefs.instance.load();
    for (final sound in AppSound.values) {
      final player = AudioPlayer();
      await player.setReleaseMode(ReleaseMode.stop);
      _players[sound] = player;
    }
    _ready = true;
  }

  void play(AppSound sound) {
    if (!_ready) return;

    final prefs = AppSoundPrefs.instance;
    if (!prefs.allows(sound)) return;

    if (sound == AppSound.cartAdd || sound == AppSound.cartRemove) {
      final now = DateTime.now();
      final last = _lastCartSound;
      if (last != null && now.difference(last).inMilliseconds < 45) return;
      _lastCartSound = now;
    }

    final player = _players[sound];
    if (player == null) return;

    final volume = prefs.volume * (sound == AppSound.tap ? 0.72 : 1.0);
    player.stop();
    player.setVolume(volume);
    player.play(AssetSource(_assetFor(sound)));
  }

  Future<void> preview(AppSound sound) async {
    await AppSoundPrefs.instance.load();
    if (!_ready) await init();
    final prefs = AppSoundPrefs.instance;
    if (!prefs.enabled) return;

    final player = _players[sound];
    if (player == null) return;

    await player.stop();
    await player.setVolume(prefs.volume * (sound == AppSound.tap ? 0.72 : 1.0));
    await player.play(AssetSource(_assetFor(sound)));
  }

  static String _assetFor(AppSound sound) => switch (sound) {
        AppSound.tap => 'sounds/tap.wav',
        AppSound.cartAdd => 'sounds/cart_add.wav',
        AppSound.cartRemove => 'sounds/cart_remove.wav',
        AppSound.success => 'sounds/success.wav',
        AppSound.error => 'sounds/error.wav',
        AppSound.info => 'sounds/info.wav',
      };
}
