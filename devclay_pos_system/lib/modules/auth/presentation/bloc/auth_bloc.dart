import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_entities.dart';
import '../../domain/usecases/auth_usecases.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc({
    required RestoreSession restoreSession,
    required LoginUser loginUser,
    required GetStores getStores,
    required SelectStore selectStore,
    required LogoutUser logoutUser,
    required RefreshSession refreshSession,
  })  : _restoreSession = restoreSession,
        _loginUser = loginUser,
        _getStores = getStores,
        _selectStore = selectStore,
        _logoutUser = logoutUser,
        _refreshSession = refreshSession,
        super(const AuthInitial()) {
    on<AuthStarted>(_onStarted);
    on<AuthLoginSubmitted>(_onLogin);
    on<AuthStoreSelected>(_onStoreSelected);
    on<AuthLogoutRequested>(_onLogout);
    on<AuthStoresRequested>(_onStoresRequested);
    on<AuthSwitchStoreRequested>(_onSwitchStore);
    on<AuthSessionRefreshed>(_onSessionRefreshed);
  }

  final RestoreSession _restoreSession;
  final LoginUser _loginUser;
  final GetStores _getStores;
  final SelectStore _selectStore;
  final LogoutUser _logoutUser;
  final RefreshSession _refreshSession;

  Future<void> _resolveStoreSession(
    AuthSessionSnapshot session,
    Emitter<AuthState> emit,
  ) async {
    final stores = await _getStores();
    if (stores.isEmpty) {
      emit(
        const AuthFailureState(
          'No store configured. Contact your administrator.',
        ),
      );
      return;
    }
    if (stores.length == 1) {
      final updated = await _selectStore(storeId: stores.first.id);
      emit(AuthAuthenticated(updated));
      return;
    }
    emit(AuthNeedsStore(session: session, stores: stores));
  }

  Future<void> _onStarted(
    AuthStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    try {
      final session = await _restoreSession();
      if (session == null) {
        emit(const AuthUnauthenticated());
        return;
      }
      if (!session.hasStore) {
        await _resolveStoreSession(session, emit);
        return;
      }
      emit(AuthAuthenticated(session));
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onLogin(
    AuthLoginSubmitted event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthAuthenticating());
    try {
      final session = await _loginUser(
        username: event.username,
        password: event.password,
        rememberMe: event.rememberMe,
      );
      await _resolveStoreSession(session, emit);
    } on AuthFailure catch (error) {
      emit(AuthFailureState(error.message));
    } catch (_) {
      emit(const AuthFailureState('Unable to sign in. Please try again.'));
    }
  }

  Future<void> _onStoresRequested(
    AuthStoresRequested event,
    Emitter<AuthState> emit,
  ) async {
    final current = state;
    if (current is! AuthNeedsStore) return;
    try {
      final stores = await _getStores();
      emit(AuthNeedsStore(session: current.session, stores: stores));
    } catch (_) {
      emit(AuthNeedsStore(session: current.session, stores: current.stores));
    }
  }

  Future<void> _onStoreSelected(
    AuthStoreSelected event,
    Emitter<AuthState> emit,
  ) async {
    final current = state;
    final session = switch (current) {
      AuthNeedsStore(:final session) => session,
      AuthAuthenticated(:final session) => session,
      _ => null,
    };
    if (session == null) {
      emit(const AuthUnauthenticated());
      return;
    }

    emit(AuthSelectingStore(session: session));
    try {
      final updated = await _selectStore(storeId: event.storeId);
      emit(AuthAuthenticated(updated));
    } on AuthFailure catch (error) {
      final stores = await _getStores();
      emit(
        AuthNeedsStore(
          session: session,
          stores: stores,
          errorMessage: error.message,
        ),
      );
    } catch (_) {
      final stores = await _getStores();
      emit(
        AuthNeedsStore(
          session: session,
          stores: stores,
          errorMessage: 'Could not select store.',
        ),
      );
    }
  }

  Future<void> _onLogout(
    AuthLogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    await _logoutUser(clearRemembered: true);
    emit(const AuthUnauthenticated());
  }

  Future<void> _onSwitchStore(
    AuthSwitchStoreRequested event,
    Emitter<AuthState> emit,
  ) async {
    final session = state.sessionOrNull;
    if (session == null) {
      emit(const AuthUnauthenticated());
      return;
    }
    final stores = await _getStores();
    if (stores.length <= 1) {
      if (stores.length == 1 && !session.hasStore) {
        final updated = await _selectStore(storeId: stores.first.id);
        emit(AuthAuthenticated(updated));
      }
      return;
    }
    emit(
      AuthNeedsStore(
        session: session.copyWith(clearStore: true),
        stores: stores,
      ),
    );
  }

  Future<void> _onSessionRefreshed(
    AuthSessionRefreshed event,
    Emitter<AuthState> emit,
  ) async {
    if (state is! AuthAuthenticated) return;
    try {
      final updated = await _refreshSession();
      if (updated != null && updated.hasStore) {
        emit(AuthAuthenticated(updated));
      }
    } catch (_) {}
  }
}
