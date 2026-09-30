import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../constants/developer_contact.dart';
import '../../modules/sales/domain/entities/sale_entities.dart';
import '../../modules/settings/domain/entities/settings_entities.dart';
import '../../modules/settings/utils/sale_receipt_branding.dart';
import '../../utils/currency_formatter.dart';

/// Builds a thermal-sized PDF receipt sized for real 80 mm / 58 mm rolls.
///
/// Uses row layout (not space-padded monospace) so Windows drivers do not wrap
/// label/value pairs when the printable width is tighter than the paper width.
abstract final class ReceiptPdfBuilder {
  static const int defaultWidthMm = 80;

  /// Safe printable content width for a given paper size.
  static int defaultContentWidthMm(int paperWidthMm) =>
      paperWidthMm >= 80 ? 72 : 48;

  static PdfPageFormat pageFormat({
    required int paperWidthMm,
    required double contentHeightMm,
    double marginMm = 2,
  }) {
    final width = paperWidthMm * PdfPageFormat.mm;
    final height = (contentHeightMm.clamp(100, 4000)) * PdfPageFormat.mm;
    return PdfPageFormat(width, height, marginAll: marginMm * PdfPageFormat.mm);
  }

  /// Structured sale receipt matching the on-screen bill layout.
  static Future<Uint8List> buildSaleReceipt({
    required SaleReceiptData receipt,
    required ReceiptBranding branding,
    int paperWidthMm = defaultWidthMm,
    int? contentWidthMm,
    String align = 'center',
  }) async {
    final paper = paperWidthMm >= 80 ? 80 : 58;
    final contentMm = (contentWidthMm ?? defaultContentWidthMm(paper)).clamp(
      40,
      paper - 2,
    );
    final branded = receipt.withBranding(branding);
    final dateFormat = DateFormat('EEE, dd-MMM-yyyy h:mm a');
    final stampFormat = DateFormat('dd-MMM-yyyy HH:mm:ss');
    final fontSize = paper >= 80 ? 8.5 : 7.5;
    final small = fontSize - 0.8;
    final titleSize = fontSize + 2.5;
    final bold = pw.Font.helveticaBold();
    final regular = pw.Font.helvetica();

    pw.Widget gap([double h = 4]) => pw.SizedBox(height: h);

    pw.Widget divider() => pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Divider(thickness: 0.6, color: PdfColors.grey700),
    );

    pw.Widget pair(String label, String value, {bool emphasize = false}) {
      return pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 2),
        child: pw.Row(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Expanded(
              child: pw.Text(
                label,
                style: pw.TextStyle(
                  font: emphasize ? bold : regular,
                  fontSize: emphasize ? fontSize + 0.5 : fontSize,
                ),
              ),
            ),
            pw.SizedBox(width: 6),
            pw.Text(
              value,
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(
                font: emphasize ? bold : regular,
                fontSize: emphasize ? fontSize + 0.5 : fontSize,
              ),
            ),
          ],
        ),
      );
    }

    pw.Widget centerText(String text, {pw.Font? font, double? size}) {
      return pw.Text(
        text,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(font: font ?? regular, fontSize: size ?? fontSize),
      );
    }

    final children = <pw.Widget>[];

    if (branding.showBusinessInfo) {
      if (branded.businessName?.isNotEmpty ?? false) {
        children.add(
          centerText(branded.businessName!, font: bold, size: titleSize),
        );
      }
      if (branded.businessAddress?.isNotEmpty ?? false) {
        children.add(centerText(branded.businessAddress!, size: small));
      }
      if (branded.taxNumber?.isNotEmpty ?? false) {
        children.add(centerText('NTN ${branded.taxNumber}', size: small));
      }
      if (branded.businessPhone?.isNotEmpty ?? false) {
        children.add(
          centerText('Contact #: ${branded.businessPhone}', size: small),
        );
      }
      children.add(gap(6));
    }

    children.add(centerText(branded.title, font: bold, size: titleSize));
    children.add(centerText(branded.invoiceNo, size: small));
    children.add(gap(6));

    if (branded.operatorName?.isNotEmpty ?? false) {
      children.add(pair('Operator Name', branded.operatorName!));
    }
    children.add(pair('Invoice Date', dateFormat.format(branded.soldAt)));
    children.add(
      pair(
        'Client Name',
        branded.customerName?.isNotEmpty == true
            ? branded.customerName!
            : 'Walk-in Customer',
      ),
    );
    if (branded.counterName?.isNotEmpty ?? false) {
      children.add(pair('Counter', branded.counterName!));
    }
    if (branded.systemName?.isNotEmpty ?? false) {
      children.add(pair('System Name', branded.systemName!));
    }

    children.add(gap(4));
    children.add(
      pw.Row(
        children: [
          pw.Expanded(
            child: pw.Text(
              'Item',
              style: pw.TextStyle(font: bold, fontSize: small),
            ),
          ),
          pw.SizedBox(
            width: 28,
            child: pw.Text(
              'Qty',
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(font: bold, fontSize: small),
            ),
          ),
          pw.SizedBox(
            width: 52,
            child: pw.Text(
              'Amount',
              textAlign: pw.TextAlign.right,
              style: pw.TextStyle(font: bold, fontSize: small),
            ),
          ),
        ],
      ),
    );
    children.add(divider());

    for (final line in branded.lines) {
      children.add(
        pw.Padding(
          padding: const pw.EdgeInsets.only(bottom: 4),
          child: pw.Row(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Expanded(
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      line.productName,
                      style: pw.TextStyle(font: regular, fontSize: fontSize),
                    ),
                    pw.Text(
                      CurrencyFormatter.format(line.unitPrice),
                      style: pw.TextStyle(font: regular, fontSize: small),
                    ),
                    if (line.batchSummary != null)
                      pw.Text(
                        line.batchSummary!,
                        style: pw.TextStyle(font: regular, fontSize: small),
                      ),
                  ],
                ),
              ),
              pw.SizedBox(
                width: 28,
                child: pw.Text(
                  '${line.quantity}',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(font: regular, fontSize: fontSize),
                ),
              ),
              pw.SizedBox(
                width: 52,
                child: pw.Text(
                  CurrencyFormatter.format(line.lineTotal),
                  textAlign: pw.TextAlign.right,
                  style: pw.TextStyle(font: bold, fontSize: fontSize),
                ),
              ),
            ],
          ),
        ),
      );
    }

    children.add(divider());
    children.add(pair('Total Item', '${branded.totalItems}'));
    children.add(pair('Total Qty', '${branded.totalQty}'));
    children.add(
      pair('Gross Amount', CurrencyFormatter.format(branded.grossAmount)),
    );
    if (branded.discount > 0) {
      children.add(
        pair('Discount', '- ${CurrencyFormatter.format(branded.discount)}'),
      );
    }
    if (branded.tax > 0) {
      children.add(pair('G.S.T', CurrencyFormatter.format(branded.tax)));
    }

    if (branded.fbrInvoiceEnabled) {
      children.add(gap(4));
      children.add(
        pw.Text(
          'Other Charges Detail',
          style: pw.TextStyle(font: bold, fontSize: fontSize),
        ),
      );
      children.add(
        pair('FBR POS FEE', CurrencyFormatter.format(branded.fbrPosFee)),
      );
      children.add(
        pair('Total Charges', CurrencyFormatter.format(branded.fbrPosFee)),
      );
    }

    children.add(gap(4));
    children.add(
      pair(
        'Net Amount',
        CurrencyFormatter.format(branded.netAmount),
        emphasize: true,
      ),
    );

    if (branded.fbrInvoiceEnabled) {
      children.add(gap(4));
      children.add(
        pw.Text(
          'FBR Invoice # ${branded.fbrInvoiceNo?.isNotEmpty == true ? branded.fbrInvoiceNo! : 'Pending integration'}',
          style: pw.TextStyle(font: regular, fontSize: small),
        ),
      );
      children.add(
        pw.Text(
          'Verify this invoice through FBR TaxAsaan Mobile App or SMS at 9966.',
          style: pw.TextStyle(font: regular, fontSize: small - 0.5),
        ),
      );
    }

    children.add(gap(6));
    children.add(
      pw.Text(
        'Payment Detail',
        style: pw.TextStyle(font: bold, fontSize: fontSize),
      ),
    );
    children.add(
      pair(branded.paymentMethod, CurrencyFormatter.format(branded.amountPaid)),
    );
    children.add(
      pair('Total Amount', CurrencyFormatter.format(branded.netAmount)),
    );
    if (branded.changeAmount > 0) {
      children.add(
        pair('Change', CurrencyFormatter.format(branded.changeAmount)),
      );
    }

    if (branded.notes != null && branded.notes!.isNotEmpty) {
      children.add(gap(4));
      children.add(
        pw.Text(
          branded.notes!,
          style: pw.TextStyle(font: regular, fontSize: small),
        ),
      );
    }

    if (branded.receiptTerms?.trim().isNotEmpty ?? false) {
      children.add(gap(6));
      children.add(
        pw.Text(
          'Terms And Conditions',
          style: pw.TextStyle(font: bold, fontSize: fontSize),
        ),
      );
      for (final term in branded.receiptTerms!.split('\n')) {
        if (term.trim().isEmpty) continue;
        children.add(
          pw.Text(
            term.trim(),
            style: pw.TextStyle(font: regular, fontSize: small),
          ),
        );
      }
    }

    if (branded.receiptFooter?.isNotEmpty ?? false) {
      children.add(gap(6));
      children.add(centerText(branded.receiptFooter!));
    }

    children.add(gap(6));
    children.add(
      centerText(
        'Data Entry Date: ${stampFormat.format(branded.soldAt)}',
        size: small,
      ),
    );
    children.add(
      centerText(
        'Print Date: ${stampFormat.format(branded.printedAt ?? DateTime.now())}',
        size: small,
      ),
    );

    // Developer credit — always printed at the bottom.
    children.add(gap(8));
    children.add(divider());
    children.add(
      centerText('Software by ${DeveloperContact.developerName}', size: small),
    );
    children.add(gap(4));
    children.add(centerText('Phone: ${DeveloperContact.mobile}', size: small));
    children.add(centerText('Email: ${DeveloperContact.email}', size: small));
    children.add(gap(4));

    // Estimate height generously so the footer is never clipped.
    final estimatedMm = 40.0 + children.length * 5.2;
    final format = pageFormat(
      paperWidthMm: paper,
      contentHeightMm: estimatedMm,
      marginMm: 2,
    );

    final alignCenter = align.toLowerCase() != 'left';
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          final column = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: children,
          );
          final sized = pw.SizedBox(
            width: contentMm * PdfPageFormat.mm,
            child: column,
          );
          if (alignCenter) {
            return pw.Center(child: sized);
          }
          return pw.Align(alignment: pw.Alignment.topLeft, child: sized);
        },
      ),
    );
    return doc.save();
  }

  /// Plain-text fallback (test prints). Uses a safe character width.
  static Future<Uint8List> buildFromText({
    required String payload,
    int paperWidthMm = defaultWidthMm,
    int? contentWidthMm,
    String align = 'center',
  }) async {
    final paper = paperWidthMm >= 80 ? 80 : 58;
    final contentMm = (contentWidthMm ?? defaultContentWidthMm(paper)).clamp(
      40,
      paper - 2,
    );
    final lines = payload
        .replaceAll('\r\n', '\n')
        .replaceAll('\r', '\n')
        .split('\n');
    final fontSize = paper >= 80 ? 8.0 : 7.0;
    // Courier advance ≈ 0.6em; keep chars within content width.
    final maxChars = ((contentMm * PdfPageFormat.mm) / (fontSize * 0.6))
        .floor()
        .clamp(24, 48);

    final wrapped = <String>[];
    for (final line in lines) {
      if (line.isEmpty) {
        wrapped.add(' ');
        continue;
      }
      var rest = line;
      while (rest.length > maxChars) {
        wrapped.add(rest.substring(0, maxChars));
        rest = rest.substring(maxChars);
      }
      wrapped.add(rest);
    }

    final contentHeightMm =
        (wrapped.length * fontSize * 1.35 / PdfPageFormat.mm) + 20;
    final format = pageFormat(
      paperWidthMm: paper,
      contentHeightMm: contentHeightMm,
      marginMm: 2,
    );

    final alignCenter = align.toLowerCase() != 'left';
    final doc = pw.Document();
    doc.addPage(
      pw.Page(
        pageFormat: format,
        build: (context) {
          final column = pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.stretch,
            children: [
              for (final line in wrapped)
                pw.Text(
                  line,
                  style: pw.TextStyle(
                    font: pw.Font.courier(),
                    fontSize: fontSize,
                    lineSpacing: 0.5,
                  ),
                ),
            ],
          );
          final sized = pw.SizedBox(
            width: contentMm * PdfPageFormat.mm,
            child: column,
          );
          if (alignCenter) {
            return pw.Center(child: sized);
          }
          return pw.Align(alignment: pw.Alignment.topLeft, child: sized);
        },
      ),
    );
    return doc.save();
  }
}
