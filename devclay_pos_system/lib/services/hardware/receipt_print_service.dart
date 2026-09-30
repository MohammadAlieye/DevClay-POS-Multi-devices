import '../../core/di/injection.dart';
import '../../modules/sales/domain/entities/sale_entities.dart';
import '../../modules/settings/domain/entities/settings_entities.dart';
import '../../modules/settings/domain/repositories/settings_repository.dart';
import 'hardware_service.dart';
import 'receipt_pdf_builder.dart';

/// Shared entry point for thermal receipt printing (80 mm default).
abstract final class ReceiptPrintService {
  static Future<void> printSaleReceipt({
    required SaleReceiptData receipt,
    ReceiptBranding? branding,
    String? printerName,
    int? paperWidthMm,
    int? contentWidthMm,
    String? align,
    bool showDialogFallback = true,
  }) async {
    final settingsRepo = sl<SettingsRepository>();
    final settings = await settingsRepo.getSettings();
    final resolvedBranding = branding ?? settingsRepo.receiptBranding(settings);
    final width = paperWidthMm ?? settings.paperWidthMm;
    final paper = width >= 80 ? 80 : 58;
    final preferred = printerName ?? settings.printerName;
    final content =
        contentWidthMm ?? settings.receiptContentWidthMm;
    final printAlign = align ?? settings.receiptPrintAlign;

    final bytes = await ReceiptPdfBuilder.buildSaleReceipt(
      receipt: receipt,
      branding: resolvedBranding,
      paperWidthMm: paper,
      contentWidthMm: content,
      align: printAlign,
    );

    await sl<HardwareService>().printPdfBytes(
      bytes,
      printerName: preferred,
      showDialogFallback: showDialogFallback,
      jobName: 'DevClayPOS Receipt',
    );
  }
}
