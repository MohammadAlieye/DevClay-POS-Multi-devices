import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:devclay_license_core/devclay_license_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../domain/entities/admin_user.dart';
import '../domain/repositories/admin_auth_repository.dart';

class AdminAuthRepositoryImpl implements AdminAuthRepository {
  AdminAuthRepositoryImpl({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;

  @override
  Stream<AdminUser?> authStateChanges() {
    return _auth.authStateChanges().asyncMap((user) async {
      if (user == null) return null;
      return _resolveUser(user);
    });
  }

  @override
  Future<AdminUser?> currentUser() async {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _resolveUser(user);
  }

  Future<AdminUser> _resolveUser(User user) async {
    if (SuperAdminConfig.isSuperAdminEmail(user.email)) {
      return AdminUser(
        uid: user.uid,
        email: user.email ?? SuperAdminConfig.email,
        displayName: SuperAdminConfig.displayName,
        role: AdminRole.superAdmin,
      );
    }

    final doc =
        await _db.collection(FirestorePaths.admins).doc(user.uid).get();
    if (!doc.exists || doc.data() == null) {
      await _auth.signOut();
      throw StateError('Not an authorized admin account.');
    }

    final data = doc.data()!;
    if (data['locked'] == true) {
      await _auth.signOut();
      throw StateError('This admin account is locked.');
    }

    return AdminUser(
      uid: user.uid,
      email: user.email ?? (data['email'] as String? ?? ''),
      displayName: (data['displayName'] as String?) ??
          user.displayName ??
          'Admin',
      role: AdminRole.admin,
      locked: data['locked'] as bool? ?? false,
    );
  }

  @override
  Future<AdminUser> signIn({
    required String email,
    required String password,
  }) async {
    final cred = await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    final user = cred.user;
    if (user == null) {
      throw StateError('Sign-in failed.');
    }

    final admin = await _resolveUser(user);

    await _db.collection(FirestorePaths.auditLogs).add({
      'action': AuditActions.adminLogin,
      'actorUid': admin.uid,
      'actorEmail': admin.email,
      'targetId': admin.uid,
      'targetType': 'admin',
      'details': admin.isSuperAdmin
          ? 'Super Admin login'
          : 'Admin login',
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'isSuperAdmin': admin.isSuperAdmin,
    });

    return admin;
  }

  @override
  Future<void> signOut() => _auth.signOut();

  @override
  Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  @override
  Future<void> unlockAdmin(String uid) async {
    final current = await currentUser();
    if (current == null || !current.isSuperAdmin) {
      throw StateError('Only Super Admin can unlock accounts.');
    }
    await _db.collection(FirestorePaths.admins).doc(uid).update({
      'locked': false,
      'updatedAt': DateTime.now().toUtc().toIso8601String(),
    });
    await _db.collection(FirestorePaths.auditLogs).add({
      'action': AuditActions.accountUnlocked,
      'actorUid': current.uid,
      'actorEmail': current.email,
      'targetId': uid,
      'targetType': 'admin',
      'details': 'Unlocked admin account',
      'createdAt': DateTime.now().toUtc().toIso8601String(),
      'isSuperAdmin': true,
    });
  }

  @override
  Future<List<AdminUser>> listAdmins() async {
    // Super Admin is intentionally excluded — never stored in `admins`.
    final snap = await _db.collection(FirestorePaths.admins).get();
    return snap.docs.map((doc) {
      final data = doc.data();
      return AdminUser(
        uid: doc.id,
        email: (data['email'] as String?) ?? '',
        displayName: (data['displayName'] as String?) ?? 'Admin',
        role: AdminRole.admin,
        locked: data['locked'] as bool? ?? false,
      );
    }).toList();
  }
}
