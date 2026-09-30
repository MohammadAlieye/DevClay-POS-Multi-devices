import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';
import 'app_radii.dart';
import 'app_typography.dart';

/// Builds Material 3 light and dark themes from design tokens.
abstract final class AppTheme {
  static ThemeData light() => _build(Brightness.light);

  static ThemeData dark() => _build(Brightness.dark);

  static ThemeData _build(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final accent = AppColors.accent;
    final colorScheme = ColorScheme(
      brightness: brightness,
      primary: accent,
      onPrimary: Colors.white,
      secondary: AppColors.primary,
      onSecondary: Colors.white,
      error: AppColors.danger,
      onError: Colors.white,
      surface: isDark ? AppColors.darkCard : AppColors.card,
      onSurface: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
      surfaceContainerHighest:
          isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted,
      outline: isDark ? AppColors.darkBorder : AppColors.border,
      tertiary: AppColors.success,
      onTertiary: Colors.white,
    );

    final textTheme = AppTypography.textTheme(brightness);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: colorScheme,
      scaffoldBackgroundColor:
          isDark ? AppColors.darkBackground : AppColors.background,
      textTheme: textTheme,
      primaryTextTheme: textTheme,
      fontFamily: textTheme.bodyLarge?.fontFamily,
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor:
            isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
        systemOverlayStyle:
            isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
        titleTextStyle: textTheme.titleLarge,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? AppColors.darkCard : AppColors.card,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
        margin: EdgeInsets.zero,
      ),
      dividerTheme: DividerThemeData(
        color: isDark ? AppColors.darkBorder : AppColors.border,
        thickness: 1,
        space: 1,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: const OutlineInputBorder(
          borderRadius: AppRadii.smAll,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadii.smAll,
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadii.smAll,
          borderSide: BorderSide(color: accent, width: 1.5),
        ),
        hintStyle: textTheme.bodyMedium,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          elevation: 0,
          backgroundColor: accent,
          foregroundColor: Colors.white,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor:
              isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
          minimumSize: const Size(48, 48),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          side: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.border,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadii.smAll),
          textStyle: textTheme.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: accent,
          minimumSize: const Size(44, 44),
          textStyle: textTheme.labelLarge,
        ),
      ),
      iconTheme: IconThemeData(
        color: isDark ? AppColors.darkTextSecondary : AppColors.textSecondary,
        size: 20,
      ),
      tooltipTheme: TooltipThemeData(
        waitDuration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: AppRadii.xsAll,
        ),
        textStyle: textTheme.bodySmall?.copyWith(color: Colors.white),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentTextStyle: textTheme.bodySmall,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.mdAll),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: accent,
      ),
      chipTheme: ChipThemeData(
        backgroundColor:
            isDark ? AppColors.darkSurfaceMuted : AppColors.surfaceMuted,
        selectedColor: accent.withValues(alpha: 0.15),
        labelStyle: textTheme.labelMedium!,
        side: BorderSide.none,
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.xsAll),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          // Keep the white thumb visible on hover/focus/pressed.
          if (states.contains(WidgetState.disabled)) {
            return isDark ? const Color(0xFF94A3B8) : const Color(0xFFE2E8F0);
          }
          return Colors.white;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          final selected = states.contains(WidgetState.selected);
          if (states.contains(WidgetState.disabled)) {
            return selected
                ? accent.withValues(alpha: 0.28)
                : (isDark ? AppColors.darkBorder : AppColors.border);
          }
          if (selected) return accent;
          return isDark ? AppColors.darkBorder : const Color(0xFFCBD5E1);
        }),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
        overlayColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.pressed)) {
            return accent.withValues(alpha: 0.16);
          }
          if (states.contains(WidgetState.hovered) ||
              states.contains(WidgetState.focused)) {
            return accent.withValues(alpha: 0.10);
          }
          return Colors.transparent;
        }),
      ),
    );
  }
}
