import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';

import 'device_status.dart';
import 'hardware_service.dart';
import 'receipt_pdf_builder.dart';
import 'windows_raw_printer.dart';

/// Desktop hardware façade for Windows / macOS printers.
///
/// Receipts are rendered as an 80 mm (or 58 mm) PDF and sent through the OS
/// print spooler via [Printing.directPrintPdf]. Cash drawers are kicked with
/// an ESC/POS RAW job to the same printer.
class DesktopHardwareService implements HardwareService {
  @override
  Future<void> openCashDrawer({String? printerName}) async {
    final printer = await _resolvePrinter(printerName);
    if (printer == null) {
      throw StateError(
        printerName == null || printerName.trim().isEmpty
            ? 'Select a receipt printer first — cash drawers kick through the printer.'
            : 'Printer "$printerName" was not found.',
      );
    }
    if (!Platform.isWindows) {
      throw UnsupportedError(
        'Cash drawer kick is currently supported on Windows.',
      );
    }
    await WindowsRawPrinter.sendRaw(
      printerName: printer.name,
      data: WindowsRawPrinter.cashDrawerKickPin2,
      docName: 'DevClayPOS Cash Drawer',
    );
  }

  @override
  Future<void> printReceipt(
    String payload, {
    String? printerName,
    int paperWidthMm = 80,
    int? contentWidthMm,
    String align = 'center',
    bool showDialogFallback = true,
  }) async {
    final text = payload.trim();
    if (text.isEmpty) {
      throw StateError('Receipt is empty — nothing to print.');
    }

    final width = paperWidthMm >= 80 ? 80 : 58;
    final bytes = await ReceiptPdfBuilder.buildFromText(
      payload: text,
      paperWidthMm: width,
      contentWidthMm: contentWidthMm,
      align: align,
    );
    await printPdfBytes(
      bytes,
      printerName: printerName,
      showDialogFallback: showDialogFallback,
    );
  }

  @override
  Future<void> printPdfBytes(
    Uint8List bytes, {
    String? printerName,
    bool showDialogFallback = true,
    String jobName = 'DevClayPOS Print',
  }) async {
    if (bytes.isEmpty) {
      throw StateError('PDF is empty — nothing to print.');
    }

    final printer = await _resolvePrinter(printerName);
    if (printer != null) {
      try {
        final ok = await Printing.directPrintPdf(
          printer: printer,
          name: jobName,
          onLayout: (_) async => bytes,
        );
        if (ok) return;
      } catch (error, stack) {
        debugPrint('Direct PDF print failed: $error\n$stack');
        if (!showDialogFallback) rethrow;
      }
    } else if (!showDialogFallback) {
      throw StateError(
        printerName == null || printerName.trim().isEmpty
            ? 'No printer available. Install a printer in Windows Settings.'
            : 'Printer "$printerName" was not found.',
      );
    }

    if (showDialogFallback) {
      await Printing.layoutPdf(
        name: jobName,
        onLayout: (_) async => bytes,
      );
    }
  }

  @override
  Future<void> printLabel(
    String payload, {
    String format = 'escpos',
    String? printerName,
  }) {
    return printLabels([payload], format: format, printerName: printerName);
  }

  @override
  Future<void> printLabels(
    List<String> payloads, {
    String format = 'escpos',
    String? printerName,
  }) async {
    final jobs = payloads.map((p) => p.trimRight()).where((p) => p.isNotEmpty);
    if (jobs.isEmpty) {
      throw StateError('No label payloads to print.');
    }

    final printer = await _resolvePrinter(printerName);
    if (printer == null) {
      throw StateError(
        printerName == null || printerName.trim().isEmpty
            ? 'Select a printer in Settings first.'
            : 'Printer "$printerName" was not found.',
      );
    }

    final normalized = format.toLowerCase().trim();
    if (normalized != 'zpl' && normalized != 'escpos') {
      throw ArgumentError('Unsupported label format: $format');
    }

    if (!Platform.isWindows) {
      throw UnsupportedError(
        'ZPL / ESC-POS label printing requires Windows. '
        'Use a PDF label template, or print from Windows.',
      );
    }

    // One RAW job for the batch — Zebra and ESC/POS printers handle sequential labels.
    final combined = jobs.join('\n');
    final bytes = Uint8List.fromList(
      combined.codeUnits.map((c) => c & 0xFF).toList(growable: false),
    );

    await WindowsRawPrinter.sendRaw(
      printerName: printer.name,
      data: bytes,
      docName: normalized == 'zpl'
          ? 'DevClayPOS ZPL Labels'
          : 'DevClayPOS ESC/POS Labels',
    );
  }

  @override
  Future<String?> readBarcode() async => null;

  @override
  Future<List<DiscoveredPrinter>> listPrinters() async {
    final printers = await Printing.listPrinters();
    return printers
        .map(
          (printer) => DiscoveredPrinter(
            name: printer.name,
            url: printer.url,
            model: printer.model,
            location: printer.location,
            isDefault: printer.isDefault,
            isAvailable: printer.isAvailable,
          ),
        )
        .toList(growable: false);
  }

  @override
  Future<HardwareDevicesSnapshot> getDevicesSnapshot({
    String? preferredPrinterName,
  }) async {
    try {
      final printers = await listPrinters();
      final snapshot = HardwareDevicesSnapshot(
        printers: printers,
        preferredPrinterName: preferredPrinterName,
      );
      return HardwareDevicesSnapshot(
        printers: printers,
        preferredPrinterName: preferredPrinterName,
        cashDrawer: HardwareDevicesSnapshot.cashDrawerFor(
          printer: snapshot.matchedPrinter,
          supportedOnPlatform: Platform.isWindows,
        ),
      );
    } catch (e) {
      return HardwareDevicesSnapshot(
        printers: const [],
        preferredPrinterName: preferredPrinterName,
        cashDrawer: HardwareDevicesSnapshot.cashDrawerFor(
          printer: null,
          supportedOnPlatform: Platform.isWindows,
        ),
        error: e.toString().replaceFirst(RegExp(r'^[^:]+:\s*'), ''),
      );
    }
  }

  Future<Printer?> _resolvePrinter(String? preferredName) async {
    final printers = await Printing.listPrinters();
    if (printers.isEmpty) return null;

    final preferred = preferredName?.trim() ?? '';
    if (preferred.isNotEmpty) {
      for (final printer in printers) {
        final name = printer.name.toLowerCase();
        final url = printer.url.toLowerCase();
        final needle = preferred.toLowerCase();
        if (name == needle ||
            url == needle ||
            name.contains(needle) ||
            url.contains(needle)) {
          return printer;
        }
      }
    }

    for (final printer in printers) {
      if (printer.isDefault) return printer;
    }
    return printers.first;
  }
}
