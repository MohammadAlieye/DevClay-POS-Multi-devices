import 'dart:typed_data';

import 'device_status.dart';
import 'hardware_service.dart';

/// Offline-safe stub until real device drivers are wired.
class NoopHardwareService implements HardwareService {
  @override
  Future<void> openCashDrawer({String? printerName}) async {}

  @override
  Future<void> printReceipt(
    String payload, {
    String? printerName,
    int paperWidthMm = 80,
    int? contentWidthMm,
    String align = 'center',
    bool showDialogFallback = true,
  }) async {}

  @override
  Future<void> printPdfBytes(
    Uint8List bytes, {
    String? printerName,
    bool showDialogFallback = true,
    String jobName = 'DevClayPOS Print',
  }) async {}

  @override
  Future<void> printLabel(
    String payload, {
    String format = 'escpos',
    String? printerName,
  }) async {}

  @override
  Future<void> printLabels(
    List<String> payloads, {
    String format = 'escpos',
    String? printerName,
  }) async {}

  @override
  Future<String?> readBarcode() async => null;

  @override
  Future<List<DiscoveredPrinter>> listPrinters() async => const [];

  @override
  Future<HardwareDevicesSnapshot> getDevicesSnapshot({
    String? preferredPrinterName,
  }) async {
    return HardwareDevicesSnapshot(
      printers: const [],
      preferredPrinterName: preferredPrinterName,
      cashDrawer: HardwareDevicesSnapshot.cashDrawerFor(
        printer: null,
        supportedOnPlatform: false,
      ),
    );
  }
}
