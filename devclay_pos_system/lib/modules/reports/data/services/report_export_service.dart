import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../utils/currency_formatter.dart';
import 'minimal_xlsx_writer.dart';

enum ReportExportFormat { pdf, xlsx, csv }

class ReportExportColumn {
  const ReportExportColumn(this.header, this.valueForRow);

  final String header;
  final String Function(Map<String, dynamic> row) valueForRow;
}

class ReportExportPayload {
  const ReportExportPayload({
    required this.businessName,
    required this.reportTitle,
    required this.dateRangeLabel,
    required this.filterLabels,
    required this.summaryRows,
    required this.columns,
    required this.rows,
    this.totalsRow,
  });

  final String businessName;
  final String reportTitle;
  final String dateRangeLabel;
  final List<String> filterLabels;
  final List<(String label, String value)> summaryRows;
  final List<ReportExportColumn> columns;
  final List<Map<String, dynamic>> rows;
  final Map<String, dynamic>? totalsRow;
}

abstract final class ReportExportService {
  /// Saves the report to a user-chosen path. Returns the written path, or
  /// `null` when the user cancels the dialog.
  static Future<String?> export({
    required ReportExportPayload payload,
    required ReportExportFormat format,
  }) async {
    final stamp = DateFormat('dd-MMM-yyyy_HH-mm').format(DateTime.now());
    final safeTitle = payload.reportTitle
        .replaceAll(RegExp(r'[^\w\s-]'), '')
        .trim()
        .replaceAll(' ', '_');
    final ext = switch (format) {
      ReportExportFormat.pdf => 'pdf',
      ReportExportFormat.xlsx => 'xlsx',
      ReportExportFormat.csv => 'csv',
    };
    final defaultName = '${safeTitle}_$stamp.$ext';

    final bytes = switch (format) {
      ReportExportFormat.pdf => await _buildPdf(payload),
      ReportExportFormat.xlsx => _buildExcel(payload),
      ReportExportFormat.csv => _buildCsv(payload),
    };

    // macOS (and some Windows setups) do not support saveFile(bytes: …).
    // Pick a path first, then write the file ourselves — same as backup export.
    final pickedPath = await FilePicker.platform.saveFile(
      dialogTitle: 'Export ${payload.reportTitle}',
      fileName: defaultName,
      type: FileType.custom,
      allowedExtensions: [ext],
    );
    if (pickedPath == null || pickedPath.trim().isEmpty) {
      return null;
    }

    final destPath = _ensureExtension(pickedPath.trim(), ext);
    final file = File(destPath);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(bytes, flush: true);
    return destPath;
  }

  static String _ensureExtension(String path, String ext) {
    final lower = path.toLowerCase();
    if (lower.endsWith('.$ext')) return path;
    return '$path.$ext';
  }

  static Future<Uint8List> _buildPdf(ReportExportPayload payload) async {
    final generated = DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.now());
    final bold = pw.Font.helveticaBold();
    final regular = pw.Font.helvetica();
    final doc = pw.Document();

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              payload.businessName,
              style: pw.TextStyle(font: bold, fontSize: 16),
            ),
            pw.SizedBox(height: 4),
            pw.Text(
              payload.reportTitle,
              style: pw.TextStyle(font: bold, fontSize: 13),
            ),
            pw.Text(
              '${payload.dateRangeLabel} · Generated $generated',
              style: pw.TextStyle(font: regular, fontSize: 9),
            ),
            if (payload.filterLabels.isNotEmpty)
              pw.Text(
                'Filters: ${payload.filterLabels.join(' · ')}',
                style: pw.TextStyle(font: regular, fontSize: 9),
              ),
            pw.SizedBox(height: 8),
            pw.Divider(),
          ],
        ),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              payload.businessName,
              style: pw.TextStyle(font: regular, fontSize: 8),
            ),
            pw.Text(
              'Page ${context.pageNumber} of ${context.pagesCount}',
              style: pw.TextStyle(font: regular, fontSize: 8),
            ),
          ],
        ),
        build: (context) {
          final widgets = <pw.Widget>[];

          if (payload.summaryRows.isNotEmpty) {
            widgets.add(
              pw.Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final (label, value) in payload.summaryRows)
                    pw.Container(
                      width: 150,
                      padding: const pw.EdgeInsets.all(8),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey400),
                        borderRadius: pw.BorderRadius.circular(4),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            label,
                            style: pw.TextStyle(font: regular, fontSize: 8),
                          ),
                          pw.Text(
                            value,
                            style: pw.TextStyle(font: bold, fontSize: 11),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
            widgets.add(pw.SizedBox(height: 16));
          }

          if (payload.columns.isNotEmpty) {
            widgets.add(
              pw.TableHelper.fromTextArray(
                headers: payload.columns.map((c) => c.header).toList(),
                data: [
                  for (final row in payload.rows)
                    payload.columns.map((c) => c.valueForRow(row)).toList(),
                  if (payload.totalsRow != null)
                    payload.columns
                        .map((c) => c.valueForRow(payload.totalsRow!))
                        .toList(),
                ],
                headerStyle: pw.TextStyle(font: bold, fontSize: 9),
                cellStyle: pw.TextStyle(font: regular, fontSize: 8),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
                cellAlignment: pw.Alignment.centerLeft,
                cellPadding: const pw.EdgeInsets.all(4),
              ),
            );
          }

          return widgets;
        },
      ),
    );

    return doc.save();
  }

  static Uint8List _buildCsv(ReportExportPayload payload) {
    final generated = DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.now());
    final lines = <List<dynamic>>[
      [payload.businessName],
      [payload.reportTitle],
      [payload.dateRangeLabel],
      if (payload.filterLabels.isNotEmpty)
        ['Filters: ${payload.filterLabels.join(' · ')}'],
      ['Generated: $generated'],
      [],
      if (payload.summaryRows.isNotEmpty) ...[
        ['Summary'],
        for (final (label, value) in payload.summaryRows) [label, value],
        [],
      ],
      if (payload.columns.isNotEmpty) ...[
        payload.columns.map((c) => c.header).toList(),
        for (final row in payload.rows)
          payload.columns.map((c) => c.valueForRow(row)).toList(),
        if (payload.totalsRow != null)
          payload.columns.map((c) => c.valueForRow(payload.totalsRow!)).toList(),
      ],
    ];
    return Uint8List.fromList(
      utf8.encode(const ListToCsvConverter().convert(lines)),
    );
  }

  static Uint8List _buildExcel(ReportExportPayload payload) {
    final generated = DateFormat('dd-MMM-yyyy HH:mm').format(DateTime.now());
    final summaryRows = <List<String>>[
      [payload.businessName],
      [payload.reportTitle],
      [payload.dateRangeLabel],
      if (payload.filterLabels.isNotEmpty)
        ['Filters: ${payload.filterLabels.join(' · ')}'],
      ['Generated: $generated'],
      [],
      ['Summary', 'Value'],
      for (final (label, value) in payload.summaryRows) [label, value],
    ];

    final headers = payload.columns.map((c) => c.header).toList();
    final dataRows = payload.rows
        .map(
          (row) => payload.columns.map((c) => c.valueForRow(row)).toList(),
        )
        .toList();
    final totals = payload.totalsRow == null
        ? null
        : payload.columns.map((c) => c.valueForRow(payload.totalsRow!)).toList();

    return MinimalXlsxWriter.build(
      summarySheetName: 'Summary',
      summaryRows: summaryRows,
      detailSheetName: 'Details',
      headers: headers,
      dataRows: dataRows,
      totalsRow: totals,
    );
  }

  static String formatCurrency(num value) => CurrencyFormatter.format(value);
}
