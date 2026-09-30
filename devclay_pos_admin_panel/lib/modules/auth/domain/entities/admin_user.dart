import 'package:equatable/equatable.dart';

enum AdminRole { admin, superAdmin }

class AdminUser extends Equatable {
  const AdminUser({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    this.locked = false,
  });

  final String uid;
  final String email;
  final String displayName;
  final AdminRole role;
  final bool locked;

  bool get isSuperAdmin => role == AdminRole.superAdmin;

  @override
  List<Object?> get props => [uid, email, role, locked];
}
