import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../modules/labels/domain/entities/label_entities.dart';
import '../../utils/currency_formatter.dart';
import 'barcode_validator.dart';
import 'label_payload_formatter.dart';

abstract final class LabelPdfBuilder {
  static Future<Uint8List> buildSheet({
    required LabelTemplateItem template,
    required List<LabelProductLine> lines,
    required String storeName,
  }) async {
    final doc = pw.Document();
    final pageFormat = PdfPageFormat(
      template.widthMm * PdfPageFormat.mm,
      template.heightMm * PdfPageFormat.mm,
      marginAll: 2 * PdfPageFormat.mm,
    );

    for (final line in lines) {
      for (var copy = 0; copy < line.copies; copy++) {
        doc.addPage(
          pw.Page(
            pageFormat: pageFormat,
            build: (context) => _labelPage(
              template: template,
              line: line,
              storeName: storeName,
            ),
          ),
        );
      }
    }

    return doc.save();
  }

  static pw.Widget _labelPage({
    required LabelTemplateItem template,
    required LabelProductLine line,
    required String storeName,
  }) {
    final rawBarcode =
        line.barcode.trim().isNotEmpty ? line.barcode : line.sku;
    final barcodeValue = BarcodeValidator.encode(rawBarcode, template.symbology);
    final symbology = BarcodeValidator.barcodeFor(template.symbology);

    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (storeName.isNotEmpty)
          pw.Text(storeName, style: const pw.TextStyle(fontSize: 7)),
        if (template.showProductName)
          pw.Text(
            line.name,
            style: const pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
            maxLines: 2,
          ),
        if (template.showBrand && line.brand?.isNotEmpty == true)
          pw.Text(line.brand!, style: const pw.TextStyle(fontSize: 8)),
        if (template.showSku)
          pw.Text('SKU: ${line.sku}', style: const pw.TextStyle(fontSize: 8)),
        if (template.showUnit && line.unit?.isNotEmpty == true)
          pw.Text(line.unit!, style: const pw.TextStyle(fontSize: 8)),
        if (template.showCategory)
          pw.Text(line.category, style: const pw.TextStyle(fontSize: 7)),
        if (template.showPrice)
          pw.Text(
            CurrencyFormatter.format(line.sellingPrice),
            style: const pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold),
          ),
        if (template.showBatchSlot && line.batchNo?.isNotEmpty == true)
          pw.Text('Batch: ${line.batchNo}', style: const pw.TextStyle(fontSize: 7)),
        if (template.showExpirySlot && line.expiryDate?.isNotEmpty == true)
          pw.Text('Exp: ${line.expiryDate}', style: const pw.TextStyle(fontSize: 7)),
        pw.Spacer(),
        pw.BarcodeWidget(
          barcode: symbology,
          data: barcodeValue,
          width: template.widthMm * 2,
          height: template.heightMm * 0.35,
          drawText: true,
        ),
      ],
    );
  }
}

/// Orchestrates payload generation for all supported printer formats.
class LabelPrintEngine {
  const LabelPrintEngine();

  List<String> buildHardwarePayloads({
    required LabelTemplateItem template,
    required List<LabelProductLine> lines,
    required String storeName,
  }) {
    final payloads = <String>[];
    for (final line in lines) {
      for (var i = 0; i < line.copies; i++) {
        payloads.add(
          switch (template.payloadFormat) {
            LabelPayloadFormat.zpl => ZplLabelFormatter.build(
                template: template,
                line: line,
                storeName: storeName,
              ),
            LabelPayloadFormat.escpos => EscPosLabelFormatter.build(
                template: template,
                line: line,
                storeName: storeName,
              ),
            LabelPayloadFormat.pdf => '',
          },
        );
      }
    }
    return payloads.where((payload) => payload.isNotEmpty).toList();
  }

  Future<Uint8List> buildPdf({
    required LabelTemplateItem template,
    required List<LabelProductLine> lines,
    required String storeName,
  }) {
    return LabelPdfBuilder.buildSheet(
      template: template,
      lines: lines,
      storeName: storeName,
    );
  }

  int totalLabels(List<LabelProductLine> lines) {
    return lines.fold(0, (sum, line) => sum + line.copies);
  }
}
