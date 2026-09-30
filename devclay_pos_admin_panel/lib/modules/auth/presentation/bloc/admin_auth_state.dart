part of 'admin_auth_bloc.dart';

sealed class AdminAuthState extends Equatable {
  const AdminAuthState();

  @override
  List<Object?> get props => [];
}

final class AdminAuthInitial extends AdminAuthState {
  const AdminAuthInitial();
}

final class AdminAuthLoading extends AdminAuthState {
  const AdminAuthLoading();
}

final class AdminAuthAuthenticated extends AdminAuthState {
  const AdminAuthAuthenticated(this.user);

  final AdminUser user;

  @override
  List<Object?> get props => [user];
}

final class AdminAuthUnauthenticated extends AdminAuthState {
  const AdminAuthUnauthenticated();
}

final class AdminAuthFailure extends AdminAuthState {
  const AdminAuthFailure(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

final class AdminAuthPasswordResetSent extends AdminAuthState {
  const AdminAuthPasswordResetSent(this.email);

  final String email;

  @override
  List<Object?> get props => [email];
}
