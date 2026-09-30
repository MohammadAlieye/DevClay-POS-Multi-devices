import 'package:flutter/material.dart';

import 'app_colors.dart';

/// Typography tokens. Uses bundled Source Sans 3 from assets (no CDN fetch).
abstract final class AppTypography {
  static const String fontFamily = 'SourceSans3';

  static TextTheme textTheme(Brightness brightness) {
    final primary = brightness == Brightness.dark
        ? AppColors.darkTextPrimary
        : AppColors.textPrimary;
    final secondary = brightness == Brightness.dark
        ? AppColors.darkTextSecondary
        : AppColors.textSecondary;

    TextStyle style({
      required double size,
      required FontWeight weight,
      double height = 1.35,
      Color? color,
      double? letterSpacing,
    }) {
      return TextStyle(
        fontFamily: fontFamily,
        fontFamilyFallback: const [
          'Segoe UI',
          'Helvetica Neue',
          'Arial',
        ],
        fontSize: size,
        fontWeight: weight,
        height: height,
        color: color ?? primary,
        letterSpacing: letterSpacing,
      );
    }

    return TextTheme(
      displayLarge: style(size: 40, weight: FontWeight.w700, height: 1.15),
      displayMedium: style(size: 32, weight: FontWeight.w700, height: 1.2),
      displaySmall: style(size: 28, weight: FontWeight.w700, height: 1.2),
      headlineLarge: style(size: 24, weight: FontWeight.w700, height: 1.25),
      headlineMedium: style(size: 20, weight: FontWeight.w600, height: 1.3),
      headlineSmall: style(size: 18, weight: FontWeight.w600, height: 1.3),
      titleLarge: style(size: 16, weight: FontWeight.w600),
      titleMedium: style(size: 14, weight: FontWeight.w600),
      titleSmall: style(size: 13, weight: FontWeight.w600, color: secondary),
      bodyLarge: style(size: 15, weight: FontWeight.w400),
      bodyMedium: style(size: 14, weight: FontWeight.w400, color: secondary),
      bodySmall: style(size: 12, weight: FontWeight.w400, color: secondary),
      labelLarge: style(size: 14, weight: FontWeight.w600, letterSpacing: 0.1),
      labelMedium: style(size: 12, weight: FontWeight.w600, color: secondary),
      labelSmall: style(size: 11, weight: FontWeight.w500, color: secondary),
    );
  }
}
