import 'dart:convert';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart' as enc;

import '../constants/license_constants.dart';
import '../models/local_license_payload.dart';

/// AES encryption for local license payloads.
///
/// The encryption key is derived from a device-specific secret + app salt.
/// Ciphertext is stored as `base64(iv):base64(ciphertext)`.
abstract final class LicenseCrypto {
  static Uint8List deriveKey(String deviceSecret) {
    final digest = sha256.convert(
      utf8.encode('${LicenseConstants.appSalt}|$deviceSecret'),
    );
    return Uint8List.fromList(digest.bytes);
  }

  static String encryptPayload({
    required LocalLicensePayload payload,
    required String deviceSecret,
  }) {
    final key = enc.Key(deriveKey(deviceSecret));
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final plain = jsonEncode(payload.toJson());
    final encrypted = encrypter.encrypt(plain, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static LocalLicensePayload decryptPayload({
    required String cipherText,
    required String deviceSecret,
  }) {
    final parts = cipherText.split(':');
    if (parts.length != 2) {
      throw const FormatException('Invalid encrypted license format');
    }
    final key = enc.Key(deriveKey(deviceSecret));
    final iv = enc.IV.fromBase64(parts[0]);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final plain = encrypter.decrypt64(parts[1], iv: iv);
    final map = jsonDecode(plain) as Map<String, dynamic>;
    return LocalLicensePayload.fromJson(map);
  }

  /// Encrypt an arbitrary string (e.g. notes) with the same scheme.
  static String encryptString({
    required String plainText,
    required String secret,
  }) {
    final key = enc.Key(deriveKey(secret));
    final iv = enc.IV.fromSecureRandom(16);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    return '${iv.base64}:${encrypted.base64}';
  }

  static String decryptString({
    required String cipherText,
    required String secret,
  }) {
    final parts = cipherText.split(':');
    if (parts.length != 2) {
      throw const FormatException('Invalid cipher text');
    }
    final key = enc.Key(deriveKey(secret));
    final iv = enc.IV.fromBase64(parts[0]);
    final encrypter = enc.Encrypter(enc.AES(key, mode: enc.AESMode.cbc));
    return encrypter.decrypt64(parts[1], iv: iv);
  }
}
