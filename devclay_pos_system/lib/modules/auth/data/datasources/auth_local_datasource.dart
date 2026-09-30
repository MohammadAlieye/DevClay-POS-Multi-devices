import 'package:isar_community/isar.dart';

import '../../../../core/auth/password_hasher.dart';
import '../../../../core/auth/permissions.dart';
import '../../../../core/error/failures.dart';
import '../../../../database/collections/auth_session.dart';
import '../../../../database/collections/store.dart';
import '../../../../database/collections/user_account.dart';
import '../../../../database/isar_service.dart';
import '../../domain/entities/auth_entities.dart';

class AuthLocalDataSource {
  AuthLocalDataSource(this._isarService);

  static const String sessionKey = 'current';

  final IsarService _isarService;

  Future<AuthSessionSnapshot?> restoreSession() async {
    final isar = _isarService.instance;
    final session = await isar.authSessions
        .filter()
        .keyEqualTo(sessionKey)
        .findFirst();

    if (session == null || session.userId == null) return null;
    if (!session.rememberMe) return null;

    final user = await isar.userAccounts.get(session.userId!);
    if (user == null || !user.isActive || user.deletedAt != null) return null;

    StoreInfo? store;
    if (session.storeId != null) {
      final storeRecord = await isar.stores.get(session.storeId!);
      if (storeRecord != null && storeRecord.isActive) {
        store = _mapStore(storeRecord);
      }
    }

    return AuthSessionSnapshot(
      user: _mapUser(user),
      store: store,
      rememberMe: session.rememberMe,
    );
  }

  Future<AuthSessionSnapshot> login({
    required String username,
    required String password,
    required bool rememberMe,
  }) async {
    final isar = _isarService.instance;
    final normalized = username.trim().toLowerCase();
    final user = await isar.userAccounts
        .filter()
        .usernameEqualTo(normalized)
        .findFirst();

    if (user == null || !user.isActive || user.deletedAt != null) {
      throw const AuthFailure('Invalid username or password.');
    }

    final valid = PasswordHasher.verify(
      password: password,
      salt: user.passwordSalt,
      expectedHash: user.passwordHash,
    );
    if (!valid) {
      throw const AuthFailure('Invalid username or password.');
    }

    await isar.writeTxn(() async {
      await isar.authSessions.put(
        AuthSession()
          ..key = sessionKey
          ..userId = user.id
          ..storeId = null
          ..rememberMe = rememberMe
          ..loggedInAt = DateTime.now(),
      );
    });

    return AuthSessionSnapshot(
      user: _mapUser(user),
      store: null,
      rememberMe: rememberMe,
    );
  }

  Future<List<StoreInfo>> getStores() async {
    final stores = await _isarService.instance.stores
        .filter()
        .isActiveEqualTo(true)
        .findAll();
    return stores.map(_mapStore).toList();
  }

  Future<AuthSessionSnapshot> selectStore({required int storeId}) async {
    final isar = _isarService.instance;
    final session = await isar.authSessions
        .filter()
        .keyEqualTo(sessionKey)
        .findFirst();
    if (session == null || session.userId == null) {
      throw const AuthFailure('Please sign in again.');
    }

    final user = await isar.userAccounts.get(session.userId!);
    final store = await isar.stores.get(storeId);
    if (user == null ||
        user.deletedAt != null ||
        !user.isActive ||
        store == null ||
        !store.isActive) {
      throw const AuthFailure('Selected store is unavailable.');
    }

    await isar.writeTxn(() async {
      session.storeId = storeId;
      await isar.authSessions.put(session);
    });

    return AuthSessionSnapshot(
      user: _mapUser(user),
      store: _mapStore(store),
      rememberMe: session.rememberMe,
    );
  }

  Future<AuthSessionSnapshot?> refreshSession() async {
    final isar = _isarService.instance;
    final session = await isar.authSessions
        .filter()
        .keyEqualTo(sessionKey)
        .findFirst();
    if (session == null || session.userId == null) return null;

    final user = await isar.userAccounts.get(session.userId!);
    if (user == null || !user.isActive || user.deletedAt != null) return null;

    StoreInfo? store;
    if (session.storeId != null) {
      final storeRecord = await isar.stores.get(session.storeId!);
      if (storeRecord != null && storeRecord.isActive) {
        store = _mapStore(storeRecord);
      }
    }

    return AuthSessionSnapshot(
      user: _mapUser(user),
      store: store,
      rememberMe: session.rememberMe,
    );
  }

  Future<void> logout({bool clearRemembered = false}) async {
    final isar = _isarService.instance;
    await isar.writeTxn(() async {
      final session = await isar.authSessions
          .filter()
          .keyEqualTo(sessionKey)
          .findFirst();
      if (session == null) return;

      if (clearRemembered || !session.rememberMe) {
        await isar.authSessions.delete(session.id);
      } else {
        session.userId = null;
        session.storeId = null;
        session.loggedInAt = null;
        await isar.authSessions.put(session);
      }
    });
  }

  AuthUser _mapUser(UserAccount user) {
    final raw = user.permissions.isNotEmpty
        ? List<String>.from(user.permissions)
        : AppRoles.permissionsFor(user.role);
    final permissions = AppPermission.sanitizeForRole(user.role, raw);
    return AuthUser(
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      role: user.role,
      permissions: permissions,
    );
  }

  StoreInfo _mapStore(Store store) {
    return StoreInfo(
      id: store.id,
      code: store.code,
      name: store.name,
      city: store.city,
      address: store.address,
    );
  }
}
