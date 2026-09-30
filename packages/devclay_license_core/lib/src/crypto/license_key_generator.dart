import 'dart:math';

import 'package:crypto/crypto.dart';
import 'dart:convert';

import '../constants/license_constants.dart';

abstract final class LicenseKeyGenerator {
  static final _random = Random.secure();
  static const _alphabet = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';

  /// Generates a key like `DCP-XXXX-XXXX-XXXX`.
  static String generate() {
    String segment() => List.generate(
          4,
          (_) => _alphabet[_random.nextInt(_alphabet.length)],
        ).join();
    return '${LicenseConstants.licenseKeyPrefix}-${segment()}-${segment()}-${segment()}';
  }

  static String normalize(String key) {
    return key.trim().toUpperCase().replaceAll(RegExp(r'\s+'), '');
  }

  /// One-way hash used for integrity checks (not reversible).
  static String hashKey(String licenseKey) {
    final normalized = normalize(licenseKey);
    final bytes = utf8.encode('${LicenseConstants.appSalt}:$normalized');
    return sha256.convert(bytes).toString();
  }

  /// Document ID safe for Firestore (same as normalized key).
  static String toDocumentId(String licenseKey) => normalize(licenseKey);
}
