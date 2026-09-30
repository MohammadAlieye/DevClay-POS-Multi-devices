part of 'auth_bloc.dart';

sealed class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

final class AuthStarted extends AuthEvent {
  const AuthStarted();
}

final class AuthLoginSubmitted extends AuthEvent {
  const AuthLoginSubmitted({
    required this.username,
    required this.password,
    required this.rememberMe,
  });

  final String username;
  final String password;
  final bool rememberMe;

  @override
  List<Object?> get props => [username, password, rememberMe];
}

final class AuthStoreSelected extends AuthEvent {
  const AuthStoreSelected(this.storeId);

  final int storeId;

  @override
  List<Object?> get props => [storeId];
}

final class AuthStoresRequested extends AuthEvent {
  const AuthStoresRequested();
}

final class AuthLogoutRequested extends AuthEvent {
  const AuthLogoutRequested();
}

final class AuthSwitchStoreRequested extends AuthEvent {
  const AuthSwitchStoreRequested();
}

final class AuthSessionRefreshed extends AuthEvent {
  const AuthSessionRefreshed();
}
