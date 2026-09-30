import 'package:flutter/material.dart';

import 'app_theme_presets.dart';

/// Brand and semantic color tokens for DevClayPOS.
///
/// [accent] / [sidebarActive] follow the customer accent preset.
/// [primary] / [sidebar] follow the customer primary preset.
/// Both update via [applyPresets].
abstract final class AppColors {
  static const Color _defaultPrimary = Color(0xFF0F172A);
  static const Color _defaultAccent = Color(0xFF2563EB);

  static Color _primary = _defaultPrimary;
  static Color _sidebarHover = const Color(0xFF1E293B);
  static Color _accent = _defaultAccent;
  static Color _accentEnd = const Color(0xFF1D4ED8);

  static Color get primary => _primary;
  static Color get accent => _accent;
  static Color get sidebar => _primary;
  static Color get sidebarHover => _sidebarHover;
  static Color get sidebarActive => _accent;

  static void applyPresets({
    required AppAccentPreset accent,
    required AppPrimaryPreset primary,
  }) {
    _accent = accent.accent;
    _accentEnd = accent.gradientEnd;
    _primary = primary.color;
    _sidebarHover = primary.hover;
  }

  /// Convenience when only accent changes (primary kept).
  static void applyAccent(AppAccentPreset preset) {
    _accent = preset.accent;
    _accentEnd = preset.gradientEnd;
  }

  /// Convenience when only primary changes (accent kept).
  static void applyPrimary(AppPrimaryPreset preset) {
    _primary = preset.color;
    _sidebarHover = preset.hover;
  }

  static const Color success = Color(0xFF10B981);
  static const Color warning = Color(0xFFF59E0B);
  static const Color danger = Color(0xFFEF4444);

  static const Color background = Color(0xFFF8FAFC);
  static const Color darkBackground = Color(0xFF0B1220);

  static const Color card = Color(0xFFFFFFFF);
  static const Color darkCard = Color(0xFF121A2A);

  static const Color surfaceMuted = Color(0xFFF1F5F9);
  static const Color darkSurfaceMuted = Color(0xFF1A2336);

  static const Color border = Color(0xFFE2E8F0);
  static const Color darkBorder = Color(0xFF243049);

  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color darkTextPrimary = Color(0xFFF8FAFC);
  static const Color darkTextSecondary = Color(0xFF94A3B8);

  /// Soft POS stripe accents (product tiles + cart rows).
  static List<Color> get posItemAccents => [
        accent,
        success,
        const Color(0xFF6366F1),
      ];

  static LinearGradient get accentGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [accent, _accentEnd],
      );

  static LinearGradient get shellHeaderGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          background,
          Color.lerp(accent, Colors.white, 0.92)!,
        ],
      );

  static const LinearGradient darkShellHeaderGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B1220), Color(0xFF121A2A)],
  );
}
