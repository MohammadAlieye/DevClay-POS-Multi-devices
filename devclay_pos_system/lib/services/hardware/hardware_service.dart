import 'dart:typed_data';

import 'device_status.dart';

/// Hardware abstraction contracts.
///
/// Concrete printer, scanner, and cash-drawer drivers must implement these
/// interfaces. UI never talks to devices directly.
abstract class HardwareService {
  /// Pulses the cash drawer via the receipt printer's DK port (ESC/POS).
  Future<void> openCashDrawer({String? printerName});

  /// Prints a thermal receipt (plain text payload) to the selected OS printer.
  ///
  /// [paperWidthMm] defaults to 80 mm. When [printerName] is null/empty, uses
  /// the OS default printer. If direct print fails and [showDialogFallback]
  /// is true, opens the system print dialog.
  Future<void> printReceipt(
    String payload, {
    String? printerName,
    int paperWidthMm = 80,
    int? contentWidthMm,
    String align = 'center',
    bool showDialogFallback = true,
  });

  /// Prints a pre-built PDF (receipts or labels).
  Future<void> printPdfBytes(
    Uint8List bytes, {
    String? printerName,
    bool showDialogFallback = true,
    String jobName = 'DevClayPOS Print',
  });

  /// Prints a single label payload (ZPL or ESC/POS RAW on Windows).
  Future<void> printLabel(
    String payload, {
    String format = 'escpos',
    String? printerName,
  });

  /// Prints multiple label payloads to the selected OS printer.
  ///
  /// [format] is `zpl` or `escpos`. On Windows these are sent as RAW jobs
  /// (same spooler path used for cash-drawer kick). [printerName] should match
  /// Settings → printer (falls back to OS default when null/empty).
  Future<void> printLabels(
    List<String> payloads, {
    String format = 'escpos',
    String? printerName,
  });

  Future<String?> readBarcode();

  /// Lists printers known to the OS (Windows print spooler, etc.).
  Future<List<DiscoveredPrinter>> listPrinters();

  /// Resolves connection status for configured peripherals.
  Future<HardwareDevicesSnapshot> getDevicesSnapshot({
    String? preferredPrinterName,
  });
}
