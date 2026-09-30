import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:window_manager/window_manager.dart';

import 'app.dart';
import 'core/di/injection.dart';
import 'core/platform/native_capabilities.dart';
import 'firebase_options.dart';
import 'services/feedback/app_sound_service.dart';
import 'services/setup/setup_prefs.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firestore's Windows x64 C++ SDK can hard-crash (0xC000001D) on ARM hosts.
  // License cloud calls use the REST datasource instead (see DI).
  if (NativeCapabilities.isFirebaseDesktopSafe) {
    try {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
    } catch (e, st) {
      debugPrint('Firebase init failed (offline trial still works): $e\n$st');
    }
  } else {
    debugPrint(
      'Skipping native Firebase on this host '
      '(Windows ARM). License activation uses Firestore REST.',
    );
  }

  // window_manager + Flutter's merged UI/platform thread can busy-loop on
  // macOS (continuous BeginFrame / Failed to foreground). Skip it on macOS.
  final useWindowManager = !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.windows ||
          defaultTargetPlatform == TargetPlatform.linux);

  if (useWindowManager) {
    await windowManager.ensureInitialized();
    // Avoid a fixed 1440×900 centered frame — on smaller / scaled Windows
    // desktops that places the title bar above the visible work area.
    const options = WindowOptions(
      size: Size(1280, 800),
      minimumSize: Size(1024, 640),
      center: true,
      title: 'DevClayPOS',
      titleBarStyle: TitleBarStyle.normal,
    );
    await windowManager.waitUntilReadyToShow(options, () async {
      await windowManager.show();
      // Maximized keeps the title bar + controls fully on-screen.
      if (defaultTargetPlatform == TargetPlatform.windows) {
        await windowManager.maximize();
      }
      await windowManager.focus();
    });
  }

  await configureDependencies();
  await SetupPrefs.instance.load();
  await AppSounds.init();
  runApp(const DevClayPosApp());
}
