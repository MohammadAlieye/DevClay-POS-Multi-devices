part of 'settings_bloc.dart';

enum SettingsTab {
  business,
  receiptTax,
  devices,
  units,
  theme,
  backup,
  license,
  about,
}

sealed class SettingsState extends Equatable {
  const SettingsState();

  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {
  const SettingsInitial();
}

class SettingsLoading extends SettingsState {
  const SettingsLoading();
}

class SettingsError extends SettingsState {
  const SettingsError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class SettingsLoaded extends SettingsState {
  const SettingsLoaded({
    required this.settings,
    required this.tab,
    this.message,
  });

  final AppSettingsSnapshot settings;
  final SettingsTab tab;
  final String? message;

  SettingsLoaded copyWith({
    AppSettingsSnapshot? settings,
    SettingsTab? tab,
    String? message,
    bool clearMessage = false,
  }) {
    return SettingsLoaded(
      settings: settings ?? this.settings,
      tab: tab ?? this.tab,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [settings, tab, message];
}
