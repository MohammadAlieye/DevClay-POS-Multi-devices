import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// In-memory bearer tokens issued by the shop host after login.
class LanAuthTokenStore {
  LanAuthTokenStore();

  final Map<String, LanAuthSession> _byToken = {};

  LanAuthSession issue({
    required int userId,
    required String username,
    required String displayName,
    required String role,
    required List<String> permissions,
  }) {
    final token = _generateToken();
    final session = LanAuthSession(
      token: token,
      userId: userId,
      username: username,
      displayName: displayName,
      role: role,
      permissions: List<String>.from(permissions),
      issuedAt: DateTime.now(),
    );
    _byToken[token] = session;
    return session;
  }

  LanAuthSession? resolve(String? authorizationHeader) {
    if (authorizationHeader == null || authorizationHeader.isEmpty) {
      return null;
    }
    final raw = authorizationHeader.trim();
    final token = raw.toLowerCase().startsWith('bearer ')
        ? raw.substring(7).trim()
        : raw;
    if (token.isEmpty) return null;
    return _byToken[token];
  }

  void revoke(String token) => _byToken.remove(token);

  void clear() => _byToken.clear();

  String _generateToken() {
    final rnd = Random.secure();
    final bytes = List<int>.generate(32, (_) => rnd.nextInt(256));
    final stamp = DateTime.now().microsecondsSinceEpoch.toString();
    return sha256.convert([...bytes, ...utf8.encode(stamp)]).toString();
  }
}

class LanAuthSession {
  const LanAuthSession({
    required this.token,
    required this.userId,
    required this.username,
    required this.displayName,
    required this.role,
    required this.permissions,
    required this.issuedAt,
  });

  final String token;
  final int userId;
  final String username;
  final String displayName;
  final String role;
  final List<String> permissions;
  final DateTime issuedAt;
}

/// Request context keys for Shelf.
abstract final class LanRequestContext {
  static const authSession = 'lan.authSession';
}
