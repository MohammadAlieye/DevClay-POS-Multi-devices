import 'package:flutter/material.dart';

/// Customer-selectable accent themes (Settings → Theme).
enum AppAccentPreset {
  ocean(
    id: 'ocean',
    label: 'Ocean blue',
    accent: Color(0xFF2563EB),
  ),
  skyGreen(
    id: 'sky_green',
    label: 'Sky → green',
    accent: Color(0xFF0EA5E9),
    secondary: Color(0xFF10B981),
  ),
  emerald(
    id: 'emerald',
    label: 'Emerald',
    accent: Color(0xFF059669),
  ),
  teal(
    id: 'teal',
    label: 'Teal',
    accent: Color(0xFF0D9488),
  ),
  indigo(
    id: 'indigo',
    label: 'Indigo',
    accent: Color(0xFF4F46E5),
  ),
  violet(
    id: 'violet',
    label: 'Violet',
    accent: Color(0xFF7C3AED),
  ),
  rose(
    id: 'rose',
    label: 'Rose',
    accent: Color(0xFFE11D48),
  ),
  amber(
    id: 'amber',
    label: 'Amber',
    accent: Color(0xFFD97706),
  ),
  slate(
    id: 'slate',
    label: 'Slate',
    accent: Color(0xFF475569),
  );

  const AppAccentPreset({
    required this.id,
    required this.label,
    required this.accent,
    this.secondary,
  });

  final String id;
  final String label;
  final Color accent;

  /// Optional second tone (e.g. sky → green).
  final Color? secondary;

  Color get gradientEnd =>
      secondary ?? Color.lerp(accent, Colors.black, 0.18)!;

  static const AppAccentPreset fallback = AppAccentPreset.ocean;

  static AppAccentPreset fromId(String? id) {
    if (id == null || id.isEmpty) return fallback;
    return AppAccentPreset.values.firstWhere(
      (p) => p.id == id,
      orElse: () => fallback,
    );
  }
}

/// Customer-selectable primary / chrome colors (sidebar, snackbars, ink).
enum AppPrimaryPreset {
  slate(
    id: 'slate',
    label: 'Slate',
    color: Color(0xFF0F172A),
  ),
  midnight(
    id: 'midnight',
    label: 'Midnight',
    color: Color(0xFF020617),
  ),
  navy(
    id: 'navy',
    label: 'Navy',
    color: Color(0xFF0B1D36),
  ),
  charcoal(
    id: 'charcoal',
    label: 'Charcoal',
    color: Color(0xFF171717),
  ),
  graphite(
    id: 'graphite',
    label: 'Graphite',
    color: Color(0xFF1C1917),
  ),
  forest(
    id: 'forest',
    label: 'Forest',
    color: Color(0xFF052E16),
  ),
  wine(
    id: 'wine',
    label: 'Wine',
    color: Color(0xFF3B0A0A),
  ),
  indigo(
    id: 'indigo',
    label: 'Indigo',
    color: Color(0xFF1E1B4B),
  );

  const AppPrimaryPreset({
    required this.id,
    required this.label,
    required this.color,
  });

  final String id;
  final String label;
  final Color color;

  /// Slightly lighter hover tone for sidebar rows.
  Color get hover => Color.lerp(color, Colors.white, 0.08)!;

  static const AppPrimaryPreset fallback = AppPrimaryPreset.slate;

  static AppPrimaryPreset fromId(String? id) {
    if (id == null || id.isEmpty) return fallback;
    return AppPrimaryPreset.values.firstWhere(
      (p) => p.id == id,
      orElse: () => fallback,
    );
  }
}

abstract final class AppThemeModeCodec {
  static const light = 'light';
  static const dark = 'dark';
  static const system = 'system';

  static String encode(ThemeMode mode) => switch (mode) {
        ThemeMode.light => light,
        ThemeMode.dark => dark,
        ThemeMode.system => system,
      };

  static ThemeMode decode(String? value) => switch (value) {
        dark => ThemeMode.dark,
        system => ThemeMode.system,
        _ => ThemeMode.light,
      };
}
