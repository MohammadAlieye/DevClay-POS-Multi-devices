part of 'admin_auth_bloc.dart';

sealed class AdminAuthEvent extends Equatable {
  const AdminAuthEvent();

  @override
  List<Object?> get props => [];
}

final class AdminAuthStarted extends AdminAuthEvent {
  const AdminAuthStarted();
}

final class AdminAuthLoginRequested extends AdminAuthEvent {
  const AdminAuthLoginRequested({
    required this.email,
    required this.password,
  });

  final String email;
  final String password;

  @override
  List<Object?> get props => [email];
}

final class AdminAuthLogoutRequested extends AdminAuthEvent {
  const AdminAuthLogoutRequested();
}

final class AdminAuthPasswordResetRequested extends AdminAuthEvent {
  const AdminAuthPasswordResetRequested(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}
