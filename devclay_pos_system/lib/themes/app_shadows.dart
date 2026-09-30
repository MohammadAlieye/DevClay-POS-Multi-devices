import 'package:flutter/material.dart';

/// Soft elevation shadows for cards and overlays.
abstract final class AppShadows {
  static List<BoxShadow> sm(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.35 : 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }

  static List<BoxShadow> md(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.4 : 0.06),
        blurRadius: 16,
        offset: const Offset(0, 4),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
        blurRadius: 4,
        offset: const Offset(0, 1),
      ),
    ];
  }

  static List<BoxShadow> lg(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    return [
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.5 : 0.08),
        blurRadius: 32,
        offset: const Offset(0, 12),
      ),
      BoxShadow(
        color: Colors.black.withValues(alpha: isDark ? 0.25 : 0.04),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ];
  }
}
