import '../../modules/labels/domain/entities/label_entities.dart';
import '../../utils/currency_formatter.dart';
import 'barcode_validator.dart';

/// Builds ZPL payloads optimized for Zebra desktop printers on Windows.
abstract final class ZplLabelFormatter {
  static String build({
    required LabelTemplateItem template,
    required LabelProductLine line,
    required String storeName,
  }) {
    final widthDots = (template.widthMm * 8).round();
    final heightDots = (template.heightMm * 8).round();
    final buffer = StringBuffer()
      ..writeln('^XA')
      ..writeln('^PW$widthDots')
      ..writeln('^LL$heightDots')
      ..writeln('^CF0,24');

    var y = 20;
    if (template.showProductName) {
      buffer.writeln('^FO20,$y^FD${_escape(line.name)}^FS');
      y += 30;
    }
    if (template.showBrand && line.brand?.isNotEmpty == true) {
      buffer.writeln('^FO20,$y^FD${_escape(line.brand!)}^FS');
      y += 24;
    }
    if (template.showSku) {
      buffer.writeln('^FO20,$y^FD SKU: ${_escape(line.sku)}^FS');
      y += 24;
    }
    if (template.showUnit && line.unit?.isNotEmpty == true) {
      buffer.writeln('^FO20,$y^FD ${_escape(line.unit!)}^FS');
      y += 24;
    }
    if (template.showCategory) {
      buffer.writeln('^FO20,$y^FD ${_escape(line.category)}^FS');
      y += 24;
    }
    if (template.showPrice) {
      buffer.writeln(
        '^FO20,$y^FD${CurrencyFormatter.format(line.sellingPrice)}^FS',
      );
      y += 28;
    }
    if (template.showBatchSlot && line.batchNo?.isNotEmpty == true) {
      buffer.writeln('^FO20,$y^FDBatch: ${_escape(line.batchNo!)}^FS');
      y += 24;
    }
    if (template.showExpirySlot && line.expiryDate?.isNotEmpty == true) {
      buffer.writeln('^FO20,$y^FDExp: ${_escape(line.expiryDate!)}^FS');
      y += 24;
    }

    final barcodeValue = _barcodeValue(line, template.symbology);
    final barcodeHeight = template.storeType == LabelStoreType.warehouse ? 90 : 60;
    buffer
      ..writeln('^FO20,$y^BY2')
      ..writeln('^BCN,$barcodeHeight,Y,N,N')
      ..writeln('^FD$barcodeValue^FS')
      ..writeln('^FO20,${y + barcodeHeight + 8}^FD$barcodeValue^FS')
      ..writeln('^XZ');

    return buffer.toString();
  }

  static String _barcodeValue(LabelProductLine line, LabelSymbology symbology) {
    final raw = line.barcode.trim().isNotEmpty ? line.barcode : line.sku;
    return BarcodeValidator.encode(raw, symbology)
        .replaceAll('^', '')
        .replaceAll('~', '');
  }

  static String _escape(String value) =>
      value.replaceAll('^', '').replaceAll('~', '');
}

/// ESC/POS text labels for 58/80 mm thermal printers.
abstract final class EscPosLabelFormatter {
  static String build({
    required LabelTemplateItem template,
    required LabelProductLine line,
    required String storeName,
  }) {
    final width = template.widthMm >= 58 ? 32 : 24;
    final buffer = StringBuffer();

    void center(String text) {
      if (text.length >= width) {
        buffer.writeln(text.substring(0, width));
        return;
      }
      final pad = ((width - text.length) / 2).floor();
      buffer.writeln('${' ' * pad}$text');
    }

    buffer.writeln('\x1B\x40'); // init
    buffer.writeln('\x1B\x61\x01'); // center
    if (storeName.isNotEmpty) center(storeName);
    buffer.writeln('\x1B\x61\x00'); // left

    if (template.showProductName) buffer.writeln(_clip(line.name, width));
    if (template.showBrand && line.brand?.isNotEmpty == true) {
      buffer.writeln(_clip(line.brand!, width));
    }
    if (template.showSku) buffer.writeln('SKU: ${_clip(line.sku, width - 5)}');
    if (template.showUnit && line.unit?.isNotEmpty == true) {
      buffer.writeln(_clip(line.unit!, width));
    }
    if (template.showCategory) buffer.writeln(_clip(line.category, width));
    if (template.showPrice) {
      buffer.writeln(CurrencyFormatter.format(line.sellingPrice));
    }
    if (template.showBatchSlot && line.batchNo?.isNotEmpty == true) {
      buffer.writeln('Batch: ${line.batchNo}');
    }
    if (template.showExpirySlot && line.expiryDate?.isNotEmpty == true) {
      buffer.writeln('Exp: ${line.expiryDate}');
    }

    final barcode = line.barcode.trim().isNotEmpty ? line.barcode : line.sku;
    buffer.writeln('*$barcode*');
    buffer.writeln('\n\n\x1D\x56\x00'); // cut
    return buffer.toString();
  }

  static String _clip(String value, int width) {
    if (value.length <= width) return value;
    return '${value.substring(0, width - 1)}…';
  }
}
