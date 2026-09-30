part of 'users_bloc.dart';

sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

class UsersStarted extends UsersEvent {
  const UsersStarted();
}

class UsersSearchChanged extends UsersEvent {
  const UsersSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

class UsersTabChanged extends UsersEvent {
  const UsersTabChanged(this.tab);

  final UsersTab tab;

  @override
  List<Object?> get props => [tab];
}

class UserSaved extends UsersEvent {
  const UserSaved({required this.draft, this.id});

  final StaffUserDraft draft;
  final int? id;

  @override
  List<Object?> get props => [draft, id];
}

class UserPasswordReset extends UsersEvent {
  const UserPasswordReset({required this.userId, required this.password});

  final int userId;
  final String password;

  @override
  List<Object?> get props => [userId, password];
}

class UserActiveToggled extends UsersEvent {
  const UserActiveToggled({required this.userId, required this.isActive});

  final int userId;
  final bool isActive;

  @override
  List<Object?> get props => [userId, isActive];
}

class UserDeleted extends UsersEvent {
  const UserDeleted(this.userId);

  final int userId;

  @override
  List<Object?> get props => [userId];
}

class UserSelected extends UsersEvent {
  const UserSelected(this.userId);

  final int userId;

  @override
  List<Object?> get props => [userId];
}

class UsersMessageDismissed extends UsersEvent {
  const UsersMessageDismissed();
}
