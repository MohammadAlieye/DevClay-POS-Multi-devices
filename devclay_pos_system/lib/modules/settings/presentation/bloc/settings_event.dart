part of 'settings_bloc.dart';

sealed class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class SettingsStarted extends SettingsEvent {
  const SettingsStarted();
}

class SettingsTabChanged extends SettingsEvent {
  const SettingsTabChanged(this.tab);

  final SettingsTab tab;

  @override
  List<Object?> get props => [tab];
}

class SettingsSaved extends SettingsEvent {
  const SettingsSaved(this.draft);

  final AppSettingsDraft draft;

  @override
  List<Object?> get props => [draft];
}

class SettingsBackupRequested extends SettingsEvent {
  const SettingsBackupRequested();
}

class SettingsImportBackupRequested extends SettingsEvent {
  const SettingsImportBackupRequested();
}

class SettingsClearDatabaseRequested extends SettingsEvent {
  const SettingsClearDatabaseRequested();
}

class SettingsMessageDismissed extends SettingsEvent {
  const SettingsMessageDismissed();
}
