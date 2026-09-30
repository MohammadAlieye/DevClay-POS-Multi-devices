import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../domain/entities/settings_entities.dart';
import '../../domain/repositories/settings_repository.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc(this._repository) : super(const SettingsInitial()) {
    on<SettingsStarted>(_onStarted);
    on<SettingsTabChanged>(_onTab);
    on<SettingsSaved>(_onSaved);
    on<SettingsBackupRequested>(_onBackup);
    on<SettingsImportBackupRequested>(_onImportBackup);
    on<SettingsClearDatabaseRequested>(_onClearDatabase);
    on<SettingsMessageDismissed>(_onDismiss);
  }

  final SettingsRepository _repository;

  Future<void> _onStarted(
    SettingsStarted event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    await _load(emit);
  }

  Future<void> _onTab(
    SettingsTabChanged event,
    Emitter<SettingsState> emit,
  ) async {
    final current = state;
    if (current is SettingsLoaded) {
      emit(current.copyWith(tab: event.tab));
    }
  }

  Future<void> _onSaved(
    SettingsSaved event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _repository.saveSettings(event.draft);
      await _load(emit, message: 'Settings saved');
    } catch (error) {
      final current = state;
      final message = userFacingError(error);
      if (current is SettingsLoaded) {
        emit(current.copyWith(message: message));
      } else {
        emit(SettingsError(message));
      }
    }
  }

  Future<void> _onBackup(
    SettingsBackupRequested event,
    Emitter<SettingsState> emit,
  ) async {
    try {
      await _repository.exportBackup();
      await _load(emit, message: 'Backup saved successfully');
    } catch (error) {
      final message = userFacingError(error);
      if (message.contains('Backup cancelled')) {
        final current = state;
        if (current is SettingsLoaded) {
          emit(current.copyWith(message: 'Backup cancelled'));
        }
        return;
      }
      final current = state;
      if (current is SettingsLoaded) {
        emit(current.copyWith(message: message));
      } else {
        emit(SettingsError(message));
      }
    }
  }

  Future<void> _onImportBackup(
    SettingsImportBackupRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      await _repository.importBackup();
      await _load(emit, message: 'Backup imported. Please sign in again.');
    } catch (error) {
      final message = userFacingError(error);
      if (message.contains('Import cancelled')) {
        await _load(emit, message: 'Import cancelled');
        return;
      }
      try {
        await _load(emit, message: 'Import failed: $message');
      } catch (_) {
        emit(SettingsError(message));
      }
    }
  }

  Future<void> _onClearDatabase(
    SettingsClearDatabaseRequested event,
    Emitter<SettingsState> emit,
  ) async {
    emit(const SettingsLoading());
    try {
      await _repository.clearDatabaseWithBackup();
      await _load(
        emit,
        message: 'Data backed up and cleared. Please sign in again.',
      );
    } catch (error) {
      final message = userFacingError(error);
      if (message.contains('Backup cancelled')) {
        await _load(emit, message: 'Backup cancelled. No data was removed.');
        return;
      }
      try {
        await _load(emit, message: 'Clear failed: $message');
      } catch (_) {
        emit(SettingsError(message));
      }
    }
  }

  Future<void> _onDismiss(
    SettingsMessageDismissed event,
    Emitter<SettingsState> emit,
  ) async {
    final current = state;
    if (current is SettingsLoaded) {
      emit(current.copyWith(clearMessage: true));
    }
  }

  Future<void> _load(Emitter<SettingsState> emit, {String? message}) async {
    try {
      final current = state;
      final tab = current is SettingsLoaded
          ? current.tab
          : SettingsTab.business;
      final settings = await _repository.getSettings();
      emit(SettingsLoaded(settings: settings, tab: tab, message: message));
    } catch (error) {
      emit(SettingsError(userFacingError(error)));
    }
  }
}
