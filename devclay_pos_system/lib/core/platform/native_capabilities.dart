import 'dart:ffi';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:ffi/ffi.dart';

/// Host/runtime capability checks for native plugins that can hard-crash.
abstract final class NativeCapabilities {
  static bool? _windowsArmHost;
  static bool? _firebaseDesktopSafe;

  /// True when the Windows *host* CPU is ARM (including x64 apps under Prism).
  static bool get isWindowsArmHost {
    if (!Platform.isWindows) return false;
    return _windowsArmHost ??= _detectWindowsArmHost();
  }

  /// Firebase C++ / Firestore Windows binaries are x64 and can SIGILL
  /// (`0xC000001D`) on ARM hosts. Never call Firestore there.
  static bool get isFirebaseDesktopSafe {
    if (kIsWeb) return true;
    return _firebaseDesktopSafe ??= !isWindowsArmHost;
  }

  static bool _detectWindowsArmHost() {
    final identifier =
        (Platform.environment['PROCESSOR_IDENTIFIER'] ?? '').toUpperCase();
    if (identifier.contains('ARM')) return true;

    final arch =
        (Platform.environment['PROCESSOR_ARCHITECTURE'] ?? '').toUpperCase();
    if (arch.contains('ARM')) return true;

    try {
      final arch = _nativeProcessorArchitecture();
      return arch == _processorArchitectureArm64 ||
          arch == _processorArchitectureArm;
    } catch (_) {
      return false;
    }
  }

  static const int _processorArchitectureArm = 5;
  static const int _processorArchitectureArm64 = 12;

  static int _nativeProcessorArchitecture() {
    final kernel32 = DynamicLibrary.open('kernel32.dll');
    final getNativeSystemInfo = kernel32.lookupFunction<
        Void Function(Pointer<_SystemInfo>),
        void Function(Pointer<_SystemInfo>)>('GetNativeSystemInfo');
    final info = calloc<_SystemInfo>();
    try {
      getNativeSystemInfo(info);
      return info.ref.wProcessorArchitecture;
    } finally {
      calloc.free(info);
    }
  }
}

/// Subset of Windows SYSTEM_INFO — only architecture is required.
final class _SystemInfo extends Struct {
  @Uint16()
  external int wProcessorArchitecture;

  @Uint16()
  external int wReserved;

  @Uint32()
  external int dwPageSize;

  external Pointer<Void> lpMinimumApplicationAddress;
  external Pointer<Void> lpMaximumApplicationAddress;

  @IntPtr()
  external int dwActiveProcessorMask;

  @Uint32()
  external int dwNumberOfProcessors;

  @Uint32()
  external int dwProcessorType;

  @Uint32()
  external int dwAllocationGranularity;

  @Uint16()
  external int wProcessorLevel;

  @Uint16()
  external int wProcessorRevision;
}
