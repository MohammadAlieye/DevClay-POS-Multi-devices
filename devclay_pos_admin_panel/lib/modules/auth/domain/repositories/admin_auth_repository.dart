import '../entities/admin_user.dart';

abstract class AdminAuthRepository {
  Stream<AdminUser?> authStateChanges();

  Future<AdminUser?> currentUser();

  Future<AdminUser> signIn({
    required String email,
    required String password,
  });

  Future<void> signOut();

  Future<void> sendPasswordReset(String email);

  /// Super Admin only — unlocks a locked admin account in Firestore.
  Future<void> unlockAdmin(String uid);

  Future<List<AdminUser>> listAdmins();
}
