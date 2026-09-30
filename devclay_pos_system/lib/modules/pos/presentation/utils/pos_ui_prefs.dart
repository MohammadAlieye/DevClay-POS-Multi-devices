import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// Remembers POS catalog UI choices across launches.
class PosUiPrefs {
  PosUiPrefs._();
  static final PosUiPrefs instance = PosUiPrefs._();

  static const _fileName = 'pos_ui_prefs.json';

  /// Default cart share of the POS split (catalog | cart).
  static const double defaultCartWidthFraction = 0.40;

  /// Floating tools menu open state. Default closed for max product space.
  bool toolsOpen = false;

  /// Customer / notes / discount strip under the grid.
  bool metaExpanded = false;

  /// Cart discount input mode — percent vs fixed rupee amount.
  bool cartDiscountIsPercent = true;

  /// Cart panel width as a fraction of the POS content row (0.28–0.55).
  double cartWidthFraction = defaultCartWidthFraction;

  Future<void> load() async {
    try {
      final file = await _file();
      if (!await file.exists()) return;
      final map = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      toolsOpen = map['toolsOpen'] == true;
      metaExpanded = map['metaExpanded'] == true;
      cartDiscountIsPercent = map['cartDiscountIsPercent'] != false;
      final rawFraction = map['cartWidthFraction'];
      if (rawFraction is num) {
        cartWidthFraction = rawFraction.toDouble().clamp(0.28, 0.55);
      }
      // Legacy keys from earlier builds.
      if (!map.containsKey('toolsOpen') && map['searchExpanded'] == true) {
        toolsOpen = true;
      }
    } catch (_) {
      // Keep defaults.
    }
  }

  Future<void> save() async {
    try {
      final file = await _file();
      await file.writeAsString(
        jsonEncode({
          'toolsOpen': toolsOpen,
          'metaExpanded': metaExpanded,
          'cartDiscountIsPercent': cartDiscountIsPercent,
          'cartWidthFraction': cartWidthFraction,
        }),
      );
    } catch (_) {
      // Preference is best-effort.
    }
  }

  Future<void> setToolsOpen(bool value) async {
    toolsOpen = value;
    await save();
  }

  Future<void> setMetaExpanded(bool value) async {
    metaExpanded = value;
    await save();
  }

  Future<void> setCartDiscountIsPercent(bool value) async {
    cartDiscountIsPercent = value;
    await save();
  }

  Future<void> setCartWidthFraction(double value) async {
    cartWidthFraction = value.clamp(0.28, 0.55);
    await save();
  }

  Future<File> _file() async {
    final dir = await getApplicationSupportDirectory();
    return File('${dir.path}/$_fileName');
  }
}
