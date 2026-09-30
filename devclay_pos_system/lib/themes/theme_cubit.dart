import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app_colors.dart';
import 'app_theme_presets.dart';

class AppThemeState extends Equatable {
  const AppThemeState({
    this.mode = ThemeMode.light,
    this.accent = AppAccentPreset.fallback,
    this.primary = AppPrimaryPreset.fallback,
  });

  final ThemeMode mode;
  final AppAccentPreset accent;
  final AppPrimaryPreset primary;

  AppThemeState copyWith({
    ThemeMode? mode,
    AppAccentPreset? accent,
    AppPrimaryPreset? primary,
  }) {
    return AppThemeState(
      mode: mode ?? this.mode,
      accent: accent ?? this.accent,
      primary: primary ?? this.primary,
    );
  }

  @override
  List<Object?> get props => [mode, accent, primary];
}

/// Controls light/dark/system mode, accent, and primary chrome presets.
class ThemeCubit extends Cubit<AppThemeState> {
  ThemeCubit({Future<void> Function(AppThemeState state)? onPersist})
      : _onPersist = onPersist,
        super(const AppThemeState()) {
    _apply(state);
  }

  final Future<void> Function(AppThemeState state)? _onPersist;

  void load({
    required ThemeMode mode,
    required AppAccentPreset accent,
    required AppPrimaryPreset primary,
  }) {
    final next = AppThemeState(mode: mode, accent: accent, primary: primary);
    _apply(next);
    emit(next);
  }

  Future<void> setMode(ThemeMode mode) => _update(state.copyWith(mode: mode));

  Future<void> setAccent(AppAccentPreset accent) =>
      _update(state.copyWith(accent: accent));

  Future<void> setPrimary(AppPrimaryPreset primary) =>
      _update(state.copyWith(primary: primary));

  Future<void> toggle() {
    final nextMode =
        state.mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    return setMode(nextMode);
  }

  Future<void> _update(AppThemeState next) async {
    _apply(next);
    emit(next);
    final persist = _onPersist;
    if (persist != null) {
      try {
        await persist(next);
      } catch (_) {
        // Theme still applies locally if persistence fails.
      }
    }
  }

  void _apply(AppThemeState next) {
    AppColors.applyPresets(accent: next.accent, primary: next.primary);
  }
}
