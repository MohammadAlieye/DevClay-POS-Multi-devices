import 'package:isar_community/isar.dart';

import '../../../../database/collections/label_print_job.dart';
import '../../../../database/collections/label_template.dart';
import '../../../../database/isar_service.dart';
import '../../domain/entities/label_entities.dart';
import '../../../products/domain/entities/product_item.dart';
import '../../../../services/hardware/hardware_service.dart';
import '../../../../services/labels/barcode_validator.dart';
import '../../../../services/labels/label_print_engine.dart';

class LabelsLocalDataSource {
  LabelsLocalDataSource(
    this._isarService,
    this._hardware,
    this._engine,
  );

  final IsarService _isarService;
  final HardwareService _hardware;
  final LabelPrintEngine _engine;

  Future<List<LabelTemplateItem>> getTemplates() async {
    final records = await _isarService.instance.labelTemplates
        .where()
        .sortByName()
        .findAll();
    return records.map(_mapTemplate).toList();
  }

  Future<LabelTemplateItem?> getDefaultTemplate() async {
    final records = await getTemplates();
    return records.where((t) => t.isDefault).firstOrNull ??
        records.firstOrNull;
  }

  Future<LabelTemplateItem> saveTemplate(
    LabelTemplateDraft draft, {
    int? id,
  }) async {
    final name = draft.name.trim();
    if (name.isEmpty) throw ArgumentError('Template name is required.');

    final isar = _isarService.instance;
    if (id == null) {
      late int newId;
      await isar.writeTxn(() async {
        if (draft.isDefault) await _clearDefaultFlag(isar);
        newId = await isar.labelTemplates.put(_fromDraft(draft));
      });
      return _mapTemplate((await isar.labelTemplates.get(newId))!);
    }

    final existing = await isar.labelTemplates.get(id);
    if (existing == null) throw StateError('Template not found.');

    await isar.writeTxn(() async {
      if (draft.isDefault) await _clearDefaultFlag(isar);
      _applyDraft(existing, draft);
      await isar.labelTemplates.put(existing);
    });
    return _mapTemplate((await isar.labelTemplates.get(id))!);
  }

  Future<void> deleteTemplate(int id) async {
    final isar = _isarService.instance;
    final existing = await isar.labelTemplates.get(id);
    if (existing == null) return;
    if (existing.isBuiltIn) {
      throw StateError('Built-in templates cannot be deleted.');
    }
    await isar.writeTxn(() async {
      await isar.labelTemplates.delete(id);
    });
  }

  Future<List<LabelPrintJobItem>> getPrintHistory({int limit = 50}) async {
    final records = await _isarService.instance.labelPrintJobs
        .where()
        .sortByPrintedAtDesc()
        .limit(limit)
        .findAll();
    return records.map(_mapJob).toList();
  }

  Future<LabelPrintResult> printLabels({
    required LabelTemplateItem template,
    required List<LabelProductLine> lines,
    required String storeName,
    String? printerName,
  }) async {
    if (lines.isEmpty) {
      throw ArgumentError('Select at least one product to print.');
    }

    for (final line in lines) {
      final barcode = line.barcode.trim().isNotEmpty ? line.barcode : line.sku;
      if (!BarcodeValidator.isValid(barcode, template.symbology)) {
        throw ArgumentError(
          'Invalid barcode for ${line.name} (${LabelLabels.symbology(template.symbology)}).',
        );
      }
      if (line.copies <= 0) {
        throw ArgumentError('Copies must be greater than zero for ${line.name}.');
      }
    }

    final totalLabels = _engine.totalLabels(lines);

    try {
      if (template.payloadFormat == LabelPayloadFormat.pdf) {
        final bytes = await _engine.buildPdf(
          template: template,
          lines: lines,
          storeName: storeName,
        );
        await _hardware.printPdfBytes(
          bytes,
          printerName: printerName,
          showDialogFallback: true,
          jobName: 'DevClayPOS Labels',
        );
      } else {
        final payloads = _engine.buildHardwarePayloads(
          template: template,
          lines: lines,
          storeName: storeName,
        );
        if (payloads.isEmpty) {
          throw StateError('No printable label payloads were generated.');
        }
        final format = switch (template.payloadFormat) {
          LabelPayloadFormat.zpl => 'zpl',
          LabelPayloadFormat.escpos => 'escpos',
          LabelPayloadFormat.pdf => 'pdf',
        };
        await _hardware.printLabels(
          payloads,
          format: format,
          printerName: printerName,
        );
      }
    } catch (error) {
      await _recordJob(
        template: template,
        lines: lines,
        totalLabels: totalLabels,
        status: 'failed',
        note: error.toString(),
      );
      rethrow;
    }

    await _recordJob(
      template: template,
      lines: lines,
      totalLabels: totalLabels,
      status: 'completed',
    );

    return LabelPrintResult(
      success: true,
      labelsPrinted: totalLabels,
      productsProcessed: lines.length,
      format: template.payloadFormat,
      message: '$totalLabels labels sent to printer',
    );
  }

  Future<void> _recordJob({
    required LabelTemplateItem template,
    required List<LabelProductLine> lines,
    required int totalLabels,
    required String status,
    String? note,
  }) async {
    final summary = lines
        .take(5)
        .map((line) => '${line.name}×${line.copies}')
        .join(', ');
    final suffix = lines.length > 5 ? '… +${lines.length - 5} more' : '';

    await _isarService.instance.writeTxn(() async {
      await _isarService.instance.labelPrintJobs.put(
        LabelPrintJob()
          ..printedAt = DateTime.now()
          ..templateName = template.name
          ..storeType = template.storeTypeLabel
          ..payloadFormat = LabelLabels.payloadFormat(template.payloadFormat)
          ..productCount = lines.length
          ..labelCount = totalLabels
          ..status = status
          ..itemsSummary = '$summary$suffix'
          ..note = note,
      );
    });
  }

  LabelProductLine productToLine(ProductItem product, {int copies = 1}) {
    return LabelProductLine(
      productId: product.id,
      name: product.name,
      sku: product.sku,
      barcode: product.barcode,
      category: product.category,
      brand: product.brand,
      unit: product.unit,
      sellingPrice: product.sellingPrice,
      copies: copies,
      sizeLabel: product.unit,
    );
  }

  Future<void> _clearDefaultFlag(Isar isar) async {
    final defaults = await isar.labelTemplates.filter().isDefaultEqualTo(true).findAll();
    for (final item in defaults) {
      item.isDefault = false;
      await isar.labelTemplates.put(item);
    }
  }

  LabelTemplate _fromDraft(LabelTemplateDraft draft) {
    return LabelTemplate()
      ..key = 'custom_${DateTime.now().millisecondsSinceEpoch}'
      ..name = draft.name.trim()
      ..storeType = draft.storeType.name
      ..description = draft.description.trim()
      ..widthMm = draft.widthMm
      ..heightMm = draft.heightMm
      ..symbology = draft.symbology.name
      ..payloadFormat = draft.payloadFormat.name
      ..showProductName = draft.showProductName
      ..showSku = draft.showSku
      ..showPrice = draft.showPrice
      ..showBrand = draft.showBrand
      ..showUnit = draft.showUnit
      ..showCategory = draft.showCategory
      ..showExpirySlot = draft.showExpirySlot
      ..showBatchSlot = draft.showBatchSlot
      ..defaultCopies = draft.defaultCopies
      ..isDefault = draft.isDefault
      ..isBuiltIn = false
      ..updatedAt = DateTime.now();
  }

  void _applyDraft(LabelTemplate record, LabelTemplateDraft draft) {
    record
      ..name = draft.name.trim()
      ..storeType = draft.storeType.name
      ..description = draft.description.trim()
      ..widthMm = draft.widthMm
      ..heightMm = draft.heightMm
      ..symbology = draft.symbology.name
      ..payloadFormat = draft.payloadFormat.name
      ..showProductName = draft.showProductName
      ..showSku = draft.showSku
      ..showPrice = draft.showPrice
      ..showBrand = draft.showBrand
      ..showUnit = draft.showUnit
      ..showCategory = draft.showCategory
      ..showExpirySlot = draft.showExpirySlot
      ..showBatchSlot = draft.showBatchSlot
      ..defaultCopies = draft.defaultCopies
      ..isDefault = draft.isDefault
      ..updatedAt = DateTime.now();
  }

  LabelTemplateItem _mapTemplate(LabelTemplate record) {
    return LabelTemplateItem(
      id: record.id,
      key: record.key,
      name: record.name,
      storeType: LabelStoreType.values.byName(record.storeType),
      description: record.description,
      widthMm: record.widthMm,
      heightMm: record.heightMm,
      symbology: LabelSymbology.values.byName(record.symbology),
      payloadFormat: LabelPayloadFormat.values.byName(record.payloadFormat),
      showProductName: record.showProductName,
      showSku: record.showSku,
      showPrice: record.showPrice,
      showBrand: record.showBrand,
      showUnit: record.showUnit,
      showCategory: record.showCategory,
      showExpirySlot: record.showExpirySlot,
      showBatchSlot: record.showBatchSlot,
      defaultCopies: record.defaultCopies,
      isDefault: record.isDefault,
      isBuiltIn: record.isBuiltIn,
      updatedAt: record.updatedAt,
    );
  }

  LabelPrintJobItem _mapJob(LabelPrintJob record) {
    return LabelPrintJobItem(
      id: record.id,
      printedAt: record.printedAt,
      templateName: record.templateName,
      storeType: record.storeType,
      payloadFormat: record.payloadFormat,
      productCount: record.productCount,
      labelCount: record.labelCount,
      status: record.status,
      itemsSummary: record.itemsSummary,
      note: record.note,
    );
  }
}
