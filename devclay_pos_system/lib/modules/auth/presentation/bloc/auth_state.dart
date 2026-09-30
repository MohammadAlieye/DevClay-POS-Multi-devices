part of 'auth_bloc.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];

  bool get isAuthenticated => this is AuthAuthenticated;

  AuthSessionSnapshot? get sessionOrNull => switch (this) {
        AuthAuthenticated(:final session) => session,
        AuthNeedsStore(:final session) => session,
        AuthSelectingStore(:final session) => session,
        _ => null,
      };
}

final class AuthInitial extends AuthState {
  const AuthInitial();
}

final class AuthLoading extends AuthState {
  const AuthLoading();
}

final class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

final class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

final class AuthFailureState extends AuthState {
  const AuthFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AuthNeedsStore extends AuthState {
  const AuthNeedsStore({
    required this.session,
    required this.stores,
    this.errorMessage,
  });

  final AuthSessionSnapshot session;
  final List<StoreInfo> stores;
  final String? errorMessage;

  @override
  List<Object?> get props => [session, stores, errorMessage];
}

final class AuthSelectingStore extends AuthState {
  const AuthSelectingStore({required this.session});

  final AuthSessionSnapshot session;

  @override
  List<Object?> get props => [session];
}

final class AuthAuthenticated extends AuthState {
  const AuthAuthenticated(this.session);

  final AuthSessionSnapshot session;

  @override
  List<Object?> get props => [session];
}
