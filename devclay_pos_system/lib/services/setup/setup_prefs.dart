import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// App setup flags stored outside the Isar database.
class SetupPrefs {
  SetupPrefs._();
  static final SetupPrefs instance = SetupPrefs._();

  static const _fileName = 'setup_prefs.json';

  /// After demo data is cleared once, hide the dangerous fresh-start control.
  bool demoDataCleared = false;

  Future<void> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) return;
      final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      demoDataCleared = map['demoDataCleared'] == true;
    } catch (_) {
      // Keep defaults.
    }
  }

  Future<void> markDemoDataCleared() async {
    demoDataCleared = true;
    await save();
  }

  Future<void> save() async {
    try {
      final file = await _file();
      await file.writeAsString(
        jsonEncode({'demoDataCleared': demoDataCleared}),
      );
    } catch (_) {
      // Best-effort.
    }
  }

  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }
}
