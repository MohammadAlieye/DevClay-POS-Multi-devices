import 'dart:convert';

import 'package:crypto/crypto.dart';

/// Offline password hashing helper (salted SHA-256).
abstract final class PasswordHasher {
  static const String _pepper = 'devclay_pos_v1';

  static String hash(String password, String salt) {
    final bytes = utf8.encode('$salt:$_pepper:$password');
    return sha256.convert(bytes).toString();
  }

  static bool verify({
    required String password,
    required String salt,
    required String expectedHash,
  }) {
    return hash(password, salt) == expectedHash;
  }
}
