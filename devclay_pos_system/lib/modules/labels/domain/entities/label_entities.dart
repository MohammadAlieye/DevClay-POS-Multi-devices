import 'package:equatable/equatable.dart';

/// Built-in retail vertical presets.
enum LabelStoreType {
  retail,
  grocery,
  pharmacy,
  clothing,
  electronics,
  warehouse,
}

/// Barcode symbologies supported by label templates.
enum LabelSymbology {
  code128,
  ean13,
  code39,
}

/// Printer payload format — Windows Zebra/ZPL first, ESC/POS thermal, PDF fallback.
enum LabelPayloadFormat {
  zpl,
  escpos,
  pdf,
}

enum LabelsTab { print, templates, history }

enum LabelBulkMode {
  selected,
  category,
  lowStock,
  allActive,
}

class LabelTemplateItem extends Equatable {
  const LabelTemplateItem({
    required this.id,
    required this.key,
    required this.name,
    required this.storeType,
    required this.description,
    required this.widthMm,
    required this.heightMm,
    required this.symbology,
    required this.payloadFormat,
    required this.showProductName,
    required this.showSku,
    required this.showPrice,
    required this.showBrand,
    required this.showUnit,
    required this.showCategory,
    required this.showExpirySlot,
    required this.showBatchSlot,
    required this.defaultCopies,
    required this.isDefault,
    required this.isBuiltIn,
    required this.updatedAt,
  });

  final int id;
  final String key;
  final String name;
  final LabelStoreType storeType;
  final String description;
  final double widthMm;
  final double heightMm;
  final LabelSymbology symbology;
  final LabelPayloadFormat payloadFormat;
  final bool showProductName;
  final bool showSku;
  final bool showPrice;
  final bool showBrand;
  final bool showUnit;
  final bool showCategory;
  final bool showExpirySlot;
  final bool showBatchSlot;
  final int defaultCopies;
  final bool isDefault;
  final bool isBuiltIn;
  final DateTime updatedAt;

  String get storeTypeLabel => LabelLabels.storeType(storeType);

  String get sizeLabel =>
      '${widthMm.toStringAsFixed(0)}×${heightMm.toStringAsFixed(0)} mm';

  @override
  List<Object?> get props => [
        id,
        key,
        name,
        storeType,
        description,
        widthMm,
        heightMm,
        symbology,
        payloadFormat,
        showProductName,
        showSku,
        showPrice,
        showBrand,
        showUnit,
        showCategory,
        showExpirySlot,
        showBatchSlot,
        defaultCopies,
        isDefault,
        isBuiltIn,
        updatedAt,
      ];
}

class LabelTemplateDraft extends Equatable {
  const LabelTemplateDraft({
    required this.name,
    required this.storeType,
    required this.description,
    required this.widthMm,
    required this.heightMm,
    required this.symbology,
    required this.payloadFormat,
    required this.showProductName,
    required this.showSku,
    required this.showPrice,
    required this.showBrand,
    required this.showUnit,
    required this.showCategory,
    required this.showExpirySlot,
    required this.showBatchSlot,
    required this.defaultCopies,
    required this.isDefault,
  });

  final String name;
  final LabelStoreType storeType;
  final String description;
  final double widthMm;
  final double heightMm;
  final LabelSymbology symbology;
  final LabelPayloadFormat payloadFormat;
  final bool showProductName;
  final bool showSku;
  final bool showPrice;
  final bool showBrand;
  final bool showUnit;
  final bool showCategory;
  final bool showExpirySlot;
  final bool showBatchSlot;
  final int defaultCopies;
  final bool isDefault;

  @override
  List<Object?> get props => [
        name,
        storeType,
        description,
        widthMm,
        heightMm,
        symbology,
        payloadFormat,
        showProductName,
        showSku,
        showPrice,
        showBrand,
        showUnit,
        showCategory,
        showExpirySlot,
        showBatchSlot,
        defaultCopies,
        isDefault,
      ];
}

class LabelProductLine extends Equatable {
  const LabelProductLine({
    required this.productId,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    this.brand,
    this.unit,
    required this.sellingPrice,
    required this.copies,
    this.expiryDate,
    this.batchNo,
    this.sizeLabel,
  });

  final int productId;
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final String? brand;
  final String? unit;
  final double sellingPrice;
  final int copies;
  final String? expiryDate;
  final String? batchNo;
  final String? sizeLabel;

  int get totalLabels => copies;

  LabelProductLine copyWith({int? copies, String? expiryDate, String? batchNo}) {
    return LabelProductLine(
      productId: productId,
      name: name,
      sku: sku,
      barcode: barcode,
      category: category,
      brand: brand,
      unit: unit,
      sellingPrice: sellingPrice,
      copies: copies ?? this.copies,
      expiryDate: expiryDate ?? this.expiryDate,
      batchNo: batchNo ?? this.batchNo,
      sizeLabel: sizeLabel,
    );
  }

  @override
  List<Object?> get props => [
        productId,
        name,
        sku,
        barcode,
        category,
        brand,
        unit,
        sellingPrice,
        copies,
        expiryDate,
        batchNo,
        sizeLabel,
      ];
}

class LabelPrintJobItem extends Equatable {
  const LabelPrintJobItem({
    required this.id,
    required this.printedAt,
    required this.templateName,
    required this.storeType,
    required this.payloadFormat,
    required this.productCount,
    required this.labelCount,
    required this.status,
    required this.itemsSummary,
    this.note,
  });

  final int id;
  final DateTime printedAt;
  final String templateName;
  final String storeType;
  final String payloadFormat;
  final int productCount;
  final int labelCount;
  final String status;
  final String itemsSummary;
  final String? note;

  @override
  List<Object?> get props => [
        id,
        printedAt,
        templateName,
        storeType,
        payloadFormat,
        productCount,
        labelCount,
        status,
        itemsSummary,
        note,
      ];
}

class LabelPrintResult extends Equatable {
  const LabelPrintResult({
    required this.success,
    required this.labelsPrinted,
    required this.productsProcessed,
    required this.format,
    this.message,
  });

  final bool success;
  final int labelsPrinted;
  final int productsProcessed;
  final LabelPayloadFormat format;
  final String? message;

  @override
  List<Object?> get props =>
      [success, labelsPrinted, productsProcessed, format, message];
}

abstract final class LabelLabels {
  static String storeType(LabelStoreType type) {
    return switch (type) {
      LabelStoreType.retail => 'Retail',
      LabelStoreType.grocery => 'Grocery',
      LabelStoreType.pharmacy => 'Pharmacy',
      LabelStoreType.clothing => 'Clothing',
      LabelStoreType.electronics => 'Electronics',
      LabelStoreType.warehouse => 'Warehouse',
    };
  }

  static String symbology(LabelSymbology symbology) {
    return switch (symbology) {
      LabelSymbology.code128 => 'Code 128',
      LabelSymbology.ean13 => 'EAN-13',
      LabelSymbology.code39 => 'Code 39',
    };
  }

  static String payloadFormat(LabelPayloadFormat format) {
    return switch (format) {
      LabelPayloadFormat.zpl => 'ZPL (Zebra)',
      LabelPayloadFormat.escpos => 'ESC/POS thermal',
      LabelPayloadFormat.pdf => 'PDF',
    };
  }
}
