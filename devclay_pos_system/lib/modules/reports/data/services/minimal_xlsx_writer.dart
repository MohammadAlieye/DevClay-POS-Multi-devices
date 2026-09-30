import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';

/// Minimal Office Open XML spreadsheet writer (no external excel package).
abstract final class MinimalXlsxWriter {
  static Uint8List build({
    required String summarySheetName,
    required List<List<String>> summaryRows,
    required String detailSheetName,
    required List<String> headers,
    required List<List<String>> dataRows,
    List<String>? totalsRow,
  }) {
    final shared = <String>[];
    final sharedIndex = <String, int>{};

    int indexOf(String value) {
      return sharedIndex.putIfAbsent(value, () {
        shared.add(value);
        return shared.length - 1;
      });
    }

    void touch(String value) => indexOf(value);

    for (final row in summaryRows) {
      for (final cell in row) {
        touch(cell);
      }
    }
    for (final h in headers) {
      touch(h);
    }
    for (final row in dataRows) {
      for (final cell in row) {
        touch(cell);
      }
    }
    if (totalsRow != null) {
      for (final cell in totalsRow) {
        touch(cell);
      }
    }

    String sheetXml({
      required List<List<String>> rows,
    }) {
      final buffer = StringBuffer();
      buffer.writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>');
      buffer.writeln(
        '<worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">',
      );
      buffer.writeln('<sheetData>');
      for (var r = 0; r < rows.length; r++) {
        buffer.writeln('<row r="${r + 1}">');
        for (var c = 0; c < rows[r].length; c++) {
          final col = _colName(c);
          final ref = '$col${r + 1}';
          final idx = indexOf(rows[r][c]);
          buffer.writeln(
            '<c r="$ref" t="s"><v>$idx</v></c>',
          );
        }
        buffer.writeln('</row>');
      }
      buffer.writeln('</sheetData></worksheet>');
      return buffer.toString();
    }

    final summaryXml = sheetXml(rows: summaryRows);
    final detailRows = [headers, ...dataRows];
    if (totalsRow != null) detailRows.add(totalsRow);
    final detailXml = sheetXml(rows: detailRows);

    final sharedStrings = StringBuffer()
      ..writeln('<?xml version="1.0" encoding="UTF-8" standalone="yes"?>')
      ..writeln(
        '<sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="${shared.length}" uniqueCount="${shared.length}">',
      );
    for (final s in shared) {
      sharedStrings.writeln('<si><t>${_escapeXml(s)}</t></si>');
    }
    sharedStrings.writeln('</sst>');

    final workbook = '''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
  <sheets>
    <sheet name="${_escapeXml(summarySheetName)}" sheetId="1" r:id="rId1"/>
    <sheet name="${_escapeXml(detailSheetName)}" sheetId="2" r:id="rId2"/>
  </sheets>
</workbook>
''';

    final archive = Archive()
      ..addFile(ArchiveFile('[Content_Types].xml', -1, utf8.encode('''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
  <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
  <Default Extension="xml" ContentType="application/xml"/>
  <Override PartName="/xl/workbook.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
  <Override PartName="/xl/worksheets/sheet1.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/worksheets/sheet2.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
  <Override PartName="/xl/sharedStrings.xml" ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>
</Types>
''')))
      ..addFile(ArchiveFile('_rels/.rels', -1, utf8.encode('''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="xl/workbook.xml"/>
</Relationships>
''')))
      ..addFile(ArchiveFile('xl/_rels/workbook.xml.rels', -1, utf8.encode('''
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
  <Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet1.xml"/>
  <Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet" Target="worksheets/sheet2.xml"/>
  <Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings" Target="sharedStrings.xml"/>
</Relationships>
''')))
      ..addFile(ArchiveFile('xl/workbook.xml', -1, utf8.encode(workbook)))
      ..addFile(ArchiveFile('xl/sharedStrings.xml', -1, utf8.encode(sharedStrings.toString())))
      ..addFile(ArchiveFile('xl/worksheets/sheet1.xml', -1, utf8.encode(summaryXml)))
      ..addFile(ArchiveFile('xl/worksheets/sheet2.xml', -1, utf8.encode(detailXml)));

    final encoded = ZipEncoder().encode(archive);
    return Uint8List.fromList(encoded);
  }

  static String _colName(int index) {
    var n = index;
    final buffer = StringBuffer();
    do {
      buffer.writeCharCode(65 + (n % 26));
      n = n ~/ 26 - 1;
    } while (n >= 0);
    return buffer.toString().split('').reversed.join();
  }

  static String _escapeXml(String input) {
    return input
        .replaceAll('&', '&amp;')
        .replaceAll('<', '&lt;')
        .replaceAll('>', '&gt;')
        .replaceAll('"', '&quot;');
  }
}
