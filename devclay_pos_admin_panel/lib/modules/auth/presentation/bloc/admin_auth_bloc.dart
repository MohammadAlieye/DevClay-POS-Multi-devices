import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/admin_auth_repository.dart';

part 'admin_auth_event.dart';
part 'admin_auth_state.dart';

class AdminAuthBloc extends Bloc<AdminAuthEvent, AdminAuthState> {
  AdminAuthBloc(this._repository) : super(const AdminAuthInitial()) {
    on<AdminAuthStarted>(_onStarted);
    on<AdminAuthLoginRequested>(_onLogin);
    on<AdminAuthLogoutRequested>(_onLogout);
    on<AdminAuthPasswordResetRequested>(_onReset);
  }

  final AdminAuthRepository _repository;

  Future<void> _onStarted(
    AdminAuthStarted event,
    Emitter<AdminAuthState> emit,
  ) async {
    emit(const AdminAuthLoading());
    try {
      final user = await _repository.currentUser();
      if (user == null) {
        emit(const AdminAuthUnauthenticated());
      } else {
        emit(AdminAuthAuthenticated(user));
      }
    } catch (e) {
      emit(AdminAuthFailure(e.toString()));
    }
  }

  Future<void> _onLogin(
    AdminAuthLoginRequested event,
    Emitter<AdminAuthState> emit,
  ) async {
    emit(const AdminAuthLoading());
    try {
      final user = await _repository.signIn(
        email: event.email,
        password: event.password,
      );
      emit(AdminAuthAuthenticated(user));
    } catch (e) {
      emit(AdminAuthFailure(e.toString()));
    }
  }

  Future<void> _onLogout(
    AdminAuthLogoutRequested event,
    Emitter<AdminAuthState> emit,
  ) async {
    await _repository.signOut();
    emit(const AdminAuthUnauthenticated());
  }

  Future<void> _onReset(
    AdminAuthPasswordResetRequested event,
    Emitter<AdminAuthState> emit,
  ) async {
    try {
      await _repository.sendPasswordReset(event.email);
      emit(AdminAuthPasswordResetSent(event.email));
      emit(const AdminAuthUnauthenticated());
    } catch (e) {
      emit(AdminAuthFailure(e.toString()));
    }
  }
}
