import 'package:equatable/equatable.dart';

class AuthUser extends Equatable {
  const AuthUser({
    required this.id,
    required this.username,
    required this.displayName,
    required this.role,
    required this.permissions,
  });

  final int id;
  final String username;
  final String displayName;
  final String role;
  final List<String> permissions;

  bool hasPermission(String permission) => permissions.contains(permission);

  @override
  List<Object?> get props => [id, username, displayName, role, permissions];
}

class StoreInfo extends Equatable {
  const StoreInfo({
    required this.id,
    required this.code,
    required this.name,
    required this.city,
    required this.address,
  });

  final int id;
  final String code;
  final String name;
  final String city;
  final String address;

  @override
  List<Object?> get props => [id, code, name, city, address];
}

class AuthSessionSnapshot extends Equatable {
  const AuthSessionSnapshot({
    required this.user,
    required this.store,
    required this.rememberMe,
  });

  final AuthUser user;
  final StoreInfo? store;
  final bool rememberMe;

  bool get hasStore => store != null;

  AuthSessionSnapshot copyWith({
    AuthUser? user,
    StoreInfo? store,
    bool? rememberMe,
    bool clearStore = false,
  }) {
    return AuthSessionSnapshot(
      user: user ?? this.user,
      store: clearStore ? null : (store ?? this.store),
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }

  @override
  List<Object?> get props => [user, store, rememberMe];
}
