import 'dart:ffi';
import 'dart:io';

import 'package:ffi/ffi.dart';
import 'package:flutter/foundation.dart';
import 'package:win32/win32.dart';

/// Sends RAW bytes to a Windows printer (ESC/POS drawer kick, etc.).
abstract final class WindowsRawPrinter {
  /// ESC/POS pulse: ESC p m t1 t2 — pin 2, ~50 ms on / ~500 ms off.
  static final Uint8List cashDrawerKickPin2 = Uint8List.fromList(const [
    0x1B,
    0x70,
    0x00,
    0x19,
    0xFA,
  ]);

  static Future<void> sendRaw({
    required String printerName,
    required Uint8List data,
    String docName = 'DevClayPOS Print',
  }) async {
    if (!Platform.isWindows) {
      throw UnsupportedError('RAW printing requires Windows.');
    }
    final name = printerName.trim();
    if (name.isEmpty) {
      throw StateError('Printer name is empty.');
    }
    if (data.isEmpty) {
      throw StateError('Nothing to send to the printer.');
    }

    final namePtr = name.toNativeUtf16();
    final phPrinter = calloc<IntPtr>();
    final docInfo = calloc<DOC_INFO_1>();
    final docNamePtr = docName.toNativeUtf16();
    final dataTypePtr = 'RAW'.toNativeUtf16();
    final buffer = calloc<Uint8>(data.length);
    final written = calloc<Uint32>();

    var opened = false;
    var docStarted = false;
    var pageStarted = false;

    try {
      if (OpenPrinter(namePtr, phPrinter, nullptr) == 0) {
        throw StateError(
          'Could not open printer "$name" (Win32 ${GetLastError()}).',
        );
      }
      opened = true;
      final hPrinter = phPrinter.value;

      docInfo.ref
        ..pDocName = docNamePtr
        ..pOutputFile = nullptr
        ..pDatatype = dataTypePtr;

      if (StartDocPrinter(hPrinter, 1, docInfo) == 0) {
        throw StateError(
          'StartDocPrinter failed for "$name" (Win32 ${GetLastError()}).',
        );
      }
      docStarted = true;

      if (StartPagePrinter(hPrinter) == 0) {
        throw StateError(
          'StartPagePrinter failed for "$name" (Win32 ${GetLastError()}).',
        );
      }
      pageStarted = true;

      buffer.asTypedList(data.length).setAll(0, data);
      if (WritePrinter(hPrinter, buffer.cast(), data.length, written) == 0) {
        throw StateError(
          'WritePrinter failed for "$name" (Win32 ${GetLastError()}).',
        );
      }
    } finally {
      if (opened) {
        final hPrinter = phPrinter.value;
        if (pageStarted) {
          EndPagePrinter(hPrinter);
        }
        if (docStarted) {
          EndDocPrinter(hPrinter);
        }
        ClosePrinter(hPrinter);
      }
      calloc.free(written);
      calloc.free(buffer);
      calloc.free(docInfo);
      calloc.free(phPrinter);
      calloc.free(namePtr);
      calloc.free(docNamePtr);
      calloc.free(dataTypePtr);
    }

    debugPrint('RAW job sent to "$name" (${data.length} bytes)');
  }
}
