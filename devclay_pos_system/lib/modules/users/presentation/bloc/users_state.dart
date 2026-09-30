part of 'users_bloc.dart';

enum UsersTab { all, active, inactive }

sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

class UsersInitial extends UsersState {
  const UsersInitial();
}

class UsersLoading extends UsersState {
  const UsersLoading();
}

class UsersError extends UsersState {
  const UsersError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

class UsersLoaded extends UsersState {
  const UsersLoaded({
    required this.users,
    required this.query,
    required this.tab,
    required this.currentUserId,
    this.selectedUserId,
    this.message,
  });

  final List<StaffUserItem> users;
  final String query;
  final UsersTab tab;
  final int currentUserId;
  final int? selectedUserId;
  final String? message;

  int get activeCount => users.where((user) => user.isActive).length;

  int get inactiveCount => users.where((user) => !user.isActive).length;

  StaffUserItem? get selectedUser {
    if (selectedUserId == null) return null;
    for (final user in users) {
      if (user.id == selectedUserId) return user;
    }
    return null;
  }

  List<StaffUserItem> get visibleUsers {
    final q = query.trim().toLowerCase();
    Iterable<StaffUserItem> base = switch (tab) {
      UsersTab.all => users,
      UsersTab.active => users.where((user) => user.isActive),
      UsersTab.inactive => users.where((user) => !user.isActive),
    };

    if (q.isEmpty) return base.toList();
    return base.where((user) {
      return user.username.contains(q) ||
          user.displayName.toLowerCase().contains(q) ||
          user.roleLabel.toLowerCase().contains(q);
    }).toList();
  }

  UsersLoaded copyWith({
    List<StaffUserItem>? users,
    String? query,
    UsersTab? tab,
    int? selectedUserId,
    int? currentUserId,
    String? message,
    bool clearMessage = false,
  }) {
    return UsersLoaded(
      users: users ?? this.users,
      query: query ?? this.query,
      tab: tab ?? this.tab,
      selectedUserId: selectedUserId ?? this.selectedUserId,
      currentUserId: currentUserId ?? this.currentUserId,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
    users,
    query,
    tab,
    currentUserId,
    selectedUserId,
    message,
  ];
}
