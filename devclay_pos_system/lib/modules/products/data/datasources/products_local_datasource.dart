import 'package:isar_community/isar.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/lan_api/lan_mode_service.dart';
import '../../../../database/collections/product.dart';
import '../../../../database/collections/product_variant.dart';
import '../../../../database/collections/app_setting.dart';
import '../../../../database/isar_service.dart';
import '../../../../services/media/product_image_store.dart';
import '../../../../utils/measure_units.dart';
import '../../../../widgets/field_limits.dart';
import '../../domain/entities/product_item.dart';

class ProductsLocalDataSource {
  ProductsLocalDataSource(this._isarService, this._imageStore);

  final IsarService _isarService;
  final ProductImageStore _imageStore;

  void _guardClientWrites() {
    if (sl.isRegistered<LanModeService>() && sl<LanModeService>().isClient) {
      throw StateError('Manage products on the shop host PC.');
    }
  }

  Future<List<ProductItem>> getProducts({String query = ''}) async {
    final isar = _isarService.instance;
    final all = await isar.products
        .filter()
        .deletedAtIsNull()
        .sortByName()
        .findAll();
    final q = query.trim().toLowerCase();
    final filtered = q.isEmpty
        ? all
        : all.where((product) {
            return product.name.toLowerCase().contains(q) ||
                product.sku.toLowerCase().contains(q) ||
                product.barcode.contains(q) ||
                product.category.toLowerCase().contains(q) ||
                (product.manufacturer?.toLowerCase().contains(q) ?? false);
          }).toList();
    final variants = await isar.productVariants
        .filter()
        .deletedAtIsNull()
        .findAll();
    final byProduct = <int, List<ProductVariant>>{};
    for (final v in variants) {
      byProduct.putIfAbsent(v.productId, () => []).add(v);
    }
    return filtered.map((p) => _map(p, byProduct[p.id] ?? const [])).toList();
  }

  Future<List<String>> getCategories() async {
    final products = await getProducts();
    final fromProducts = products
        .map((e) => e.category.trim())
        .where((c) => c.isNotEmpty)
        .toSet();
    final isar = _isarService.instance;
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    final fromSettings = settings == null
        ? DefaultProductCategories.all
        : DefaultProductCategories.fromCsv(settings.productCategoriesCsv);
    final merged = <String>{...fromSettings, ...fromProducts}.toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return merged;
  }

  Future<ProductItem> createProduct(ProductDraft draft) async {
    _guardClientWrites();
    final isar = _isarService.instance;
    _validateDraft(draft);
    await _ensureUniqueCodes(isar, draft);
    String? imagePath;
    if (draft.pendingImageSourcePath != null) {
      imagePath = await _imageStore.saveFromPath(draft.pendingImageSourcePath!);
    }

    late int id;
    await isar.writeTxn(() async {
      id = await isar.products.put(
        Product()
          ..sku = draft.sku.trim()
          ..barcode = draft.barcode.trim()
          ..name = draft.name.trim()
          ..category = draft.category.trim()
          ..brand = _emptyToNull(draft.brand)
          ..manufacturer = _emptyToNull(draft.manufacturer)
          ..strength = _emptyToNull(draft.strength)
          ..hasVariants = draft.hasVariants
          ..unit = _emptyToNull(draft.unit)
          ..sellType = MeasureUnits.sellTypeKey(
            MeasureUnits.inferSellType(draft.unit),
          )
          ..sellingPrice = 0
          ..wholesalePrice = 0
          ..purchasePrice = 0
          ..taxRate = draft.taxRate
          ..taxInclusive = draft.taxInclusive
          ..stock = 0
          ..lowStockThreshold = draft.lowStockThreshold
          ..isActive = draft.isActive
          ..manufactureDate = null
          ..expiryDate = null
          ..imagePath = imagePath,
      );
      await _syncUnitToSettings(isar, draft.unit!);
      await _syncCategoryToSettings(isar, draft.category);
      await _replaceVariants(isar, id, draft);
    });

    final saved = await isar.products.get(id);
    final variants = await isar.productVariants
        .filter()
        .productIdEqualTo(id)
        .deletedAtIsNull()
        .findAll();
    return _map(saved!, variants);
  }

  Future<ProductItem> updateProduct(int id, ProductDraft draft) async {
    _guardClientWrites();
    final isar = _isarService.instance;
    _validateDraft(draft);
    final existing = await isar.products.get(id);
    if (existing == null || existing.deletedAt != null) {
      throw StateError(
        'Product not found. Restore it from the Recycle Bin to edit.',
      );
    }
    await _ensureUniqueCodes(isar, draft, excludingId: id);

    var nextImage = existing.imagePath;
    if (draft.clearImage) {
      await _imageStore.deleteIfExists(existing.imagePath);
      nextImage = null;
    } else if (draft.pendingImageSourcePath != null) {
      final saved = await _imageStore.saveFromPath(
        draft.pendingImageSourcePath!,
      );
      await _imageStore.deleteIfExists(existing.imagePath);
      nextImage = saved;
    }

    await isar.writeTxn(() async {
      existing
        ..sku = draft.sku.trim()
        ..barcode = draft.barcode.trim()
        ..name = draft.name.trim()
        ..category = draft.category.trim()
        ..brand = _emptyToNull(draft.brand)
        ..manufacturer = _emptyToNull(draft.manufacturer)
        ..strength = _emptyToNull(draft.strength)
        ..hasVariants = draft.hasVariants
        ..unit = _emptyToNull(draft.unit)
        ..sellType = MeasureUnits.sellTypeKey(
          MeasureUnits.inferSellType(draft.unit),
        )
        ..taxRate = draft.taxRate
        ..taxInclusive = draft.taxInclusive
        ..lowStockThreshold = draft.lowStockThreshold
        ..isActive = draft.isActive
        ..imagePath = nextImage;
      if (draft.hasVariants) {
        existing.stock = draft.variants.fold<int>(0, (sum, v) => sum + v.stock);
      }
      await isar.products.put(existing);
      await _syncUnitToSettings(isar, draft.unit!);
      await _syncCategoryToSettings(isar, draft.category);
      await _replaceVariants(isar, id, draft);
    });

    final saved = await isar.products.get(id);
    final variants = await isar.productVariants
        .filter()
        .productIdEqualTo(id)
        .deletedAtIsNull()
        .findAll();
    return _map(saved!, variants);
  }

  Future<void> deleteProduct(int id) async {
    _guardClientWrites();
    final isar = _isarService.instance;
    final existing = await isar.products.get(id);
    if (existing == null) return;
    // Soft-delete → Recycle Bin (image kept until permanent purge).
    await isar.writeTxn(() async {
      existing.deletedAt = DateTime.now();
      await isar.products.put(existing);
    });
  }

  void _validateDraft(ProductDraft draft) {
    if (draft.name.trim().isEmpty) {
      throw ArgumentError('Product name is required.');
    }
    if (draft.sku.trim().isEmpty) {
      throw ArgumentError('SKU is required.');
    }
    if (draft.barcode.trim().isEmpty) {
      throw ArgumentError('Barcode is required.');
    }
    if (draft.category.trim().isEmpty) {
      throw ArgumentError('Category is required.');
    }
    if ((draft.unit ?? '').trim().isEmpty) {
      throw ArgumentError('Unit is required.');
    }
    if (!draft.taxRate.isFinite || draft.taxRate < 0 || draft.taxRate > 100) {
      throw ArgumentError('Tax must be between 0 and 100.');
    }
    if (draft.lowStockThreshold < 0 || draft.lowStockThreshold > 999999) {
      throw ArgumentError('Low stock alert must be between 0 and 999999.');
    }
  }

  Future<void> _ensureUniqueCodes(
    Isar isar,
    ProductDraft draft, {
    int? excludingId,
  }) async {
    final sku = draft.sku.trim();
    final barcode = draft.barcode.trim();
    final skuMatch = await isar.products
        .filter()
        .skuEqualTo(sku, caseSensitive: false)
        .findFirst();
    if (skuMatch != null && skuMatch.id != excludingId) {
      final location = skuMatch.deletedAt == null
          ? 'another product'
          : 'a product in the Recycle Bin';
      throw ArgumentError('SKU "$sku" is already used by $location.');
    }

    final barcodeMatch = await isar.products
        .filter()
        .barcodeEqualTo(barcode)
        .findFirst();
    if (barcodeMatch != null && barcodeMatch.id != excludingId) {
      final location = barcodeMatch.deletedAt == null
          ? 'another product'
          : 'a product in the Recycle Bin';
      throw ArgumentError('Barcode "$barcode" is already used by $location.');
    }
  }

  Future<void> restoreProduct(int id) async {
    final isar = _isarService.instance;
    final existing = await isar.products.get(id);
    if (existing == null) return;
    await isar.writeTxn(() async {
      existing.deletedAt = null;
      await isar.products.put(existing);
    });
  }

  Future<ProductItem?> getProductById(int id) async {
    final product = await _isarService.instance.products.get(id);
    if (product == null || product.deletedAt != null) return null;
    return _map(product);
  }

  String? _emptyToNull(String? value) {
    final trimmed = value?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return trimmed;
  }

  Future<void> _syncUnitToSettings(Isar isar, String value) async {
    final unit = value.trim();
    if (unit.isEmpty) return;
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null) return;
    final units = DefaultProductUnits.fromCsv(settings.productUnitsCsv);
    final exists = units.any(
      (saved) => saved.toLowerCase() == unit.toLowerCase(),
    );
    if (exists) return;
    settings.productUnitsCsv = DefaultProductUnits.toCsv([...units, unit]);
    await isar.appSettings.put(settings);
  }

  Future<void> _syncCategoryToSettings(Isar isar, String value) async {
    final category = value.trim();
    if (category.isEmpty) return;
    final settings = await isar.appSettings
        .filter()
        .keyEqualTo('default')
        .findFirst();
    if (settings == null) return;
    final categories =
        DefaultProductCategories.fromCsv(settings.productCategoriesCsv);
    final exists = categories.any(
      (saved) => saved.toLowerCase() == category.toLowerCase(),
    );
    if (exists) return;
    settings.productCategoriesCsv = DefaultProductCategories.toCsv([
      ...categories,
      category,
    ]);
    await isar.appSettings.put(settings);
  }

  Future<void> _replaceVariants(
    Isar isar,
    int productId,
    ProductDraft draft,
  ) async {
    final existing = await isar.productVariants
        .filter()
        .productIdEqualTo(productId)
        .findAll();
    for (final row in existing) {
      row.deletedAt = DateTime.now();
      row.isActive = false;
    }
    await isar.productVariants.putAll(existing);
    if (!draft.hasVariants) return;

    var stockSum = 0;
    for (final v in draft.variants) {
      final size = v.size.trim();
      final color = v.color.trim();
      if (size.isEmpty || color.isEmpty) continue;
      stockSum += v.stock;
      await isar.productVariants.put(
        ProductVariant()
          ..productId = productId
          ..size = size
          ..color = color
          ..barcode = _emptyToNull(v.barcode)
          ..sku = _emptyToNull(v.sku)
          ..stock = v.stock
          ..priceOverride = v.priceOverride
          ..isActive = v.isActive
          ..deletedAt = null,
      );
    }
    final product = await isar.products.get(productId);
    if (product != null) {
      product.stock = stockSum;
      await isar.products.put(product);
    }
  }

  ProductItem _map(Product product, [List<ProductVariant> variants = const []]) {
    final variantItems = variants
        .where((v) => v.isActive && v.deletedAt == null)
        .map(
          (v) => ProductVariantItem(
            id: v.id,
            productId: v.productId,
            size: v.size,
            color: v.color,
            barcode: v.barcode,
            sku: v.sku,
            stock: v.stock,
            priceOverride: v.priceOverride,
            isActive: v.isActive,
          ),
        )
        .toList(growable: false);
    final stock = product.hasVariants
        ? variantItems.fold<int>(0, (sum, v) => sum + v.stock)
        : product.stock;
    return ProductItem(
      id: product.id,
      sku: product.sku,
      barcode: product.barcode,
      name: product.name,
      category: product.category,
      brand: product.brand,
      manufacturer: product.manufacturer,
      strength: product.strength,
      hasVariants: product.hasVariants,
      unit: product.unit,
      sellingPrice: product.sellingPrice,
      wholesalePrice: product.wholesalePrice,
      purchasePrice: product.purchasePrice,
      taxRate: product.taxRate,
      taxInclusive: product.taxInclusive,
      stock: stock,
      isActive: product.isActive,
      lowStockThreshold: product.lowStockThreshold,
      manufactureDate: product.manufactureDate,
      expiryDate: product.expiryDate,
      imagePath: product.imagePath,
      variants: variantItems,
    );
  }
}
