import 'dart:async';

import 'package:flutter/services.dart';

/// Accumulates keyboard-wedge barcode scans (rapid key bursts + Enter/Tab).
///
/// Scanned characters stay in this buffer only — they are never typed into UI
/// text fields when the POS scan focus / hardware handler consumes them.
class BarcodeScanBuffer {
  BarcodeScanBuffer({
    required this.onScan,
    this.minLength = 3,
    this.autoCommitMinLength = 8,
    this.burstGap = const Duration(milliseconds: 40),
    this.idleCommit = const Duration(milliseconds: 100),
    this.dedupeWindow = const Duration(milliseconds: 150),
  });

  final ValueChanged<String> onScan;
  final int minLength;
  final int autoCommitMinLength;
  final Duration burstGap;
  final Duration idleCommit;
  final Duration dedupeWindow;

  final StringBuffer _buffer = StringBuffer();
  Timer? _idleTimer;
  DateTime? _lastCharAt;
  DateTime? _lastScanAt;
  String? _lastScanCode;
  bool _inBurst = false;

  bool get hasPending => _buffer.isNotEmpty;
  bool get inBurst => _inBurst;
  int get length => _buffer.length;

  void addCharacter(String character) {
    if (character.isEmpty) return;
    final now = DateTime.now();
    final gap = _lastCharAt == null
        ? const Duration(days: 1)
        : now.difference(_lastCharAt!);
    _lastCharAt = now;

    if (gap > burstGap * 5) {
      _buffer.clear();
      _inBurst = false;
    }
    if (gap <= burstGap) {
      _inBurst = true;
    }

    _buffer.write(character);
    _idleTimer?.cancel();

    if (_inBurst && _buffer.length >= autoCommitMinLength) {
      _idleTimer = Timer(idleCommit, () => commit(fromTerminator: false));
    }
  }

  /// [fromTerminator] is true for Enter/Tab — allows shorter codes.
  void commit({bool fromTerminator = true}) {
    _idleTimer?.cancel();
    final code = _buffer.toString().trim();
    _buffer.clear();
    _inBurst = false;
    _lastCharAt = null;

    if (code.length < minLength) return;
    if (!fromTerminator && !looksLikeBarcode(code)) return;

    _emit(code);
  }

  void _emit(String code) {
    final now = DateTime.now();
    if (_lastScanAt != null &&
        _lastScanCode == code &&
        now.difference(_lastScanAt!) < dedupeWindow) {
      return;
    }
    _lastScanAt = now;
    _lastScanCode = code;
    onScan(code);
  }

  void clear() {
    _idleTimer?.cancel();
    _buffer.clear();
    _inBurst = false;
    _lastCharAt = null;
  }

  void dispose() {
    _idleTimer?.cancel();
  }

  static bool looksLikeBarcode(String code) {
    if (code.length < 8) return false;
    final digits = code.replaceAll(RegExp(r'[^0-9]'), '').length;
    return digits >= (code.length * 0.7).ceil();
  }

  static bool isTerminator(KeyEvent event) {
    return event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter ||
        event.logicalKey == LogicalKeyboardKey.tab;
  }

  static String? characterFor(KeyEvent event) {
    if (event is! KeyDownEvent) return null;
    if (isTerminator(event)) return null;
    final keyLabel = event.character;
    if (keyLabel == null || keyLabel.isEmpty) return null;
    if (keyLabel.length != 1) return null;
    final unit = keyLabel.codeUnitAt(0);
    if (unit < 32 || unit == 127) return null;
    return keyLabel;
  }
}
