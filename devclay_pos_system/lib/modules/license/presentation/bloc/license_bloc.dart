import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/license_gate_state.dart';
import '../../domain/repositories/license_repository.dart';

part 'license_event.dart';
part 'license_state.dart';

class LicenseBloc extends Bloc<LicenseEvent, LicenseState> {
  LicenseBloc(this._repository) : super(const LicenseInitial()) {
    on<LicenseStarted>(_onStarted);
    on<LicenseActivateRequested>(_onActivate);
    on<LicenseRetryRequested>(_onRetry);
  }

  final LicenseRepository _repository;

  Future<void> _onStarted(
    LicenseStarted event,
    Emitter<LicenseState> emit,
  ) async {
    emit(const LicenseChecking());
    try {
      final snapshot = await _repository.verifyOnStartup().timeout(
        const Duration(seconds: 12),
        onTimeout: () => const LicenseGateSnapshot(
          mode: LicenseAccessMode.activationRequired,
          offline: true,
          message:
              'License check timed out. Enter your key or retry when online.',
        ),
      );
      if (snapshot.allowsAppAccess) {
        emit(LicenseAllowed(snapshot));
      } else {
        emit(LicenseBlocked(snapshot));
      }
    } catch (e) {
      emit(
        LicenseBlocked(
          LicenseGateSnapshot(
            mode: LicenseAccessMode.blocked,
            message: 'License check failed: $e',
          ),
        ),
      );
    }
  }

  Future<void> _onActivate(
    LicenseActivateRequested event,
    Emitter<LicenseState> emit,
  ) async {
    final current = state;
    final previous = switch (current) {
      LicenseBlocked(:final snapshot) => snapshot,
      LicenseActivationFailure(:final snapshot) => snapshot,
      LicenseAllowed(:final snapshot) => snapshot,
      _ => const LicenseGateSnapshot(mode: LicenseAccessMode.activationRequired),
    };

    emit(LicenseActivating(previous));
    try {
      final snapshot = await _repository.activateLicense(event.licenseKey);
      if (snapshot.allowsAppAccess) {
        emit(LicenseAllowed(snapshot));
      } else {
        emit(
          LicenseActivationFailure(
            snapshot,
            snapshot.message ?? 'Activation failed',
          ),
        );
      }
    } catch (e) {
      final message = e.toString().replaceFirst(RegExp(r'^[^:]+:\s*'), '');
      emit(
        LicenseActivationFailure(
          previous,
          'Activation failed: $message',
        ),
      );
    }
  }

  Future<void> _onRetry(
    LicenseRetryRequested event,
    Emitter<LicenseState> emit,
  ) async {
    add(const LicenseStarted());
  }
}
