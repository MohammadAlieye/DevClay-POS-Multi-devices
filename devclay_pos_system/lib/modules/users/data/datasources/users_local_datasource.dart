import 'package:isar_community/isar.dart';

import '../../../../core/auth/password_hasher.dart';
import '../../../../core/auth/permissions.dart';
import '../../../../database/collections/auth_session.dart';
import '../../../../database/collections/user_account.dart';
import '../../../../database/isar_service.dart';
import '../../domain/entities/user_entities.dart';

class UsersLocalDataSource {
  UsersLocalDataSource(this._isarService);

  final IsarService _isarService;

  Future<List<StaffUserItem>> getUsers() async {
    final users = await _isarService.instance.userAccounts
        .where()
        .sortByDisplayName()
        .findAll();
    final mapped = users
        .where((user) => user.deletedAt == null)
        .map(_mapUser)
        .toList();

    // Keep owner / @admin pinned at the top of the list.
    mapped.sort((a, b) {
      final aPinned = _isPinnedAdmin(a);
      final bPinned = _isPinnedAdmin(b);
      if (aPinned != bPinned) return aPinned ? -1 : 1;
      return a.displayName.toLowerCase().compareTo(b.displayName.toLowerCase());
    });
    return mapped;
  }

  bool _isPinnedAdmin(StaffUserItem user) {
    return user.role == AppRoles.owner ||
        user.username.toLowerCase() == 'admin';
  }

  Future<StaffUserItem> saveUser(
    StaffUserDraft draft, {
    int? id,
    StaffUserSaveContext? context,
  }) async {
    final username = draft.username.trim().toLowerCase();
    final displayName = draft.displayName.trim();
    if (username.length < 3) {
      throw ArgumentError('Username must be at least 3 characters.');
    }
    if (displayName.isEmpty) {
      throw ArgumentError('Display name is required.');
    }
    if (!UserRoleLabels.assignableRoles.contains(draft.role)) {
      throw ArgumentError('Invalid role selected.');
    }

    final normalizedDraft = _normalizeDraft(draft, id: id, context: context);
    if (normalizedDraft.permissions.isEmpty) {
      throw ArgumentError('At least one permission is required.');
    }
    final permissions = AppPermission.all
        .where(normalizedDraft.permissions.contains)
        .toList(growable: false);
    if (permissions.isEmpty) {
      throw ArgumentError('At least one valid permission is required.');
    }

    final isar = _isarService.instance;

    if (id == null) {
      final password = normalizedDraft.password?.trim() ?? '';
      if (password.length < 6) {
        throw ArgumentError('Password must be at least 6 characters.');
      }

      final existing = await isar.userAccounts
          .filter()
          .usernameEqualTo(username)
          .findFirst();
      if (existing != null && existing.deletedAt == null) {
        throw ArgumentError('Username is already taken.');
      }
      if (existing != null && existing.deletedAt != null) {
        throw ArgumentError(
          'Username belongs to a deleted account in Recycle Bin. '
          'Restore or permanently erase it first.',
        );
      }

      final salt = '${DateTime.now().millisecondsSinceEpoch}_$username';
      late int newId;
      await isar.writeTxn(() async {
        newId = await isar.userAccounts.put(
          UserAccount()
            ..username = username
            ..displayName = displayName
            ..role = normalizedDraft.role
            ..permissions = permissions
            ..passwordSalt = salt
            ..passwordHash = PasswordHasher.hash(password, salt)
            ..isActive = normalizedDraft.isActive
            ..createdAt = DateTime.now(),
        );
      });
      return _mapUser((await isar.userAccounts.get(newId))!);
    }

    final existing = await isar.userAccounts.get(id);
    if (existing == null) {
      throw StateError('User not found.');
    }

    if (context != null &&
        !context.editorIsOwner &&
        AppRoles.isOwner(existing.role)) {
      throw ArgumentError('Only the owner can edit owner accounts.');
    }

    final password = normalizedDraft.password?.trim();
    if (password != null && password.isNotEmpty && password.length < 6) {
      throw ArgumentError('Password must be at least 6 characters.');
    }

    await isar.writeTxn(() async {
      existing
        ..displayName = displayName
        ..role = normalizedDraft.role
        ..permissions = permissions
        ..isActive = normalizedDraft.isActive;
      if (password != null && password.isNotEmpty) {
        final salt =
            '${DateTime.now().millisecondsSinceEpoch}_${existing.username}';
        existing
          ..passwordSalt = salt
          ..passwordHash = PasswordHasher.hash(password, salt);
      }
      await isar.userAccounts.put(existing);
    });

    return _mapUser((await isar.userAccounts.get(id))!);
  }

  StaffUserDraft _normalizeDraft(
    StaffUserDraft draft, {
    int? id,
    StaffUserSaveContext? context,
  }) {
    var role = draft.role;
    var permissions = {...draft.permissions};

    if (AppRoles.isOwner(role)) {
      return StaffUserDraft(
        username: draft.username,
        displayName: draft.displayName,
        role: role,
        permissions: List<String>.from(AppPermission.all),
        password: draft.password,
        isActive: draft.isActive,
      );
    }

    if (context != null && !context.editorIsOwner) {
      if (AppRoles.isOwner(role)) {
        throw ArgumentError('Only the owner can assign the Owner role.');
      }
      permissions.removeWhere(AppPermission.isAdminPermission);
    }

    if (context != null &&
        id != null &&
        id == context.editorUserId &&
        context.editorIsOwner) {
      permissions.addAll(AppPermission.all);
    }

    if (!AppRoles.isOwner(role)) {
      permissions = AppPermission.syncStaffPermissions(permissions).toSet();
    }

    final ordered = AppPermission.syncStaffPermissions(permissions);

    return StaffUserDraft(
      username: draft.username,
      displayName: draft.displayName,
      role: role,
      permissions: ordered,
      password: draft.password,
      isActive: draft.isActive,
    );
  }

  Future<StaffUserItem> resetPassword({
    required int userId,
    required String password,
  }) async {
    if (password.trim().length < 6) {
      throw ArgumentError('Password must be at least 6 characters.');
    }

    final isar = _isarService.instance;
    final user = await isar.userAccounts.get(userId);
    if (user == null) {
      throw StateError('User not found.');
    }

    await isar.writeTxn(() async {
      final salt = '${DateTime.now().millisecondsSinceEpoch}_${user.username}';
      user
        ..passwordSalt = salt
        ..passwordHash = PasswordHasher.hash(password.trim(), salt);
      await isar.userAccounts.put(user);
    });

    return _mapUser((await isar.userAccounts.get(userId))!);
  }

  Future<StaffUserItem> setActive({
    required int userId,
    required bool isActive,
  }) async {
    final isar = _isarService.instance;
    final user = await isar.userAccounts.get(userId);
    if (user == null) {
      throw StateError('User not found.');
    }

    await isar.writeTxn(() async {
      user.isActive = isActive;
      await isar.userAccounts.put(user);
    });

    return _mapUser((await isar.userAccounts.get(userId))!);
  }

  Future<void> deleteUser(int userId) async {
    final isar = _isarService.instance;
    final user = await isar.userAccounts.get(userId);
    if (user == null) {
      throw StateError('User not found.');
    }
    if (user.deletedAt != null) return;

    await isar.writeTxn(() async {
      user.deletedAt = DateTime.now();
      user.isActive = false;
      await isar.userAccounts.put(user);

      // End any active sessions for this user.
      final sessions = await isar.authSessions
          .filter()
          .userIdEqualTo(userId)
          .findAll();
      for (final session in sessions) {
        session.userId = null;
        session.storeId = null;
        await isar.authSessions.put(session);
      }
    });
  }

  StaffUserItem _mapUser(UserAccount user) {
    final raw = user.permissions.isNotEmpty
        ? user.permissions
        : AppRoles.permissionsFor(user.role);
    final permissions = AppPermission.sanitizeForRole(user.role, raw);
    return StaffUserItem(
      id: user.id,
      username: user.username,
      displayName: user.displayName,
      role: user.role,
      permissions: permissions,
      isActive: user.isActive,
      createdAt: user.createdAt,
    );
  }
}
