part of 'labels_bloc.dart';

sealed class LabelsState extends Equatable {
  const LabelsState();
  @override
  List<Object?> get props => [];
}

class LabelsInitial extends LabelsState {
  const LabelsInitial();
}

class LabelsLoading extends LabelsState {
  const LabelsLoading();
}

class LabelsError extends LabelsState {
  const LabelsError(this.message);
  final String message;
  @override
  List<Object?> get props => [message];
}

class LabelsLoaded extends LabelsState {
  const LabelsLoaded({
    required this.templates,
    required this.products,
    required this.categories,
    required this.history,
    required this.query,
    required this.tab,
    required this.bulkMode,
    required this.selectedLines,
    required this.defaultCopies,
    this.categoryFilter,
    this.storeTypeFilter,
    this.selectedTemplateId,
    this.isPrinting = false,
    this.message,
  });

  final List<LabelTemplateItem> templates;
  final List<ProductItem> products;
  final List<String> categories;
  final List<LabelPrintJobItem> history;
  final String query;
  final LabelsTab tab;
  final LabelBulkMode bulkMode;
  final String? categoryFilter;
  final LabelStoreType? storeTypeFilter;
  final int? selectedTemplateId;
  final Map<int, LabelProductLine> selectedLines;
  final int defaultCopies;
  final bool isPrinting;
  final String? message;

  LabelTemplateItem? get selectedTemplate {
    if (selectedTemplateId == null) return null;
    for (final template in templates) {
      if (template.id == selectedTemplateId) return template;
    }
    return null;
  }

  List<ProductItem> get visibleProducts {
    final q = query.trim().toLowerCase();
    Iterable<ProductItem> base = products.where((p) => p.isActive);

    if (categoryFilter != null && categoryFilter!.isNotEmpty) {
      base = base.where((p) => p.category == categoryFilter);
    }

    if (q.isEmpty) return base.toList();
    return base
        .where(
          (p) =>
              p.name.toLowerCase().contains(q) ||
              p.sku.toLowerCase().contains(q) ||
              p.barcode.contains(q),
        )
        .toList();
  }

  static const int previewCap = 24;

  /// Labels shown in the print-tab preview. Selected mode shows every
  /// chosen product; bulk modes cap the list so the panel stays usable.
  List<LabelProductLine> get previewLines {
    return switch (bulkMode) {
      LabelBulkMode.selected => selectedLines.values.toList(),
      LabelBulkMode.category => visibleProducts
          .take(previewCap)
          .map(_lineFromProduct)
          .toList(),
      LabelBulkMode.lowStock => visibleProducts
          .where(
            (p) => isStockAtOrBelowLowThreshold(p.stock, p.lowStockThreshold),
          )
          .take(previewCap)
          .map(_lineFromProduct)
          .toList(),
      LabelBulkMode.allActive => products
          .where((p) => p.isActive)
          .take(previewCap)
          .map(_lineFromProduct)
          .toList(),
    };
  }

  int get previewTotalCount {
    return switch (bulkMode) {
      LabelBulkMode.selected => selectedLines.length,
      LabelBulkMode.category => visibleProducts.length,
      LabelBulkMode.lowStock => visibleProducts
          .where(
            (p) => isStockAtOrBelowLowThreshold(p.stock, p.lowStockThreshold),
          )
          .length,
      LabelBulkMode.allActive => products.where((p) => p.isActive).length,
    };
  }

  bool get previewIsCapped => previewTotalCount > previewLines.length;

  LabelProductLine _lineFromProduct(ProductItem product) {
    return LabelProductLine(
      productId: product.id,
      name: product.name,
      sku: product.sku,
      barcode: product.barcode,
      category: product.category,
      brand: product.brand,
      unit: product.unit,
      sellingPrice: product.sellingPrice,
      copies: defaultCopies,
    );
  }

  int get pendingLabelCount {
    return switch (bulkMode) {
      LabelBulkMode.selected =>
        selectedLines.values.fold(0, (sum, line) => sum + line.copies),
      LabelBulkMode.category => visibleProducts.length * defaultCopies,
      LabelBulkMode.lowStock =>
        visibleProducts
                .where(
                  (p) =>
                      isStockAtOrBelowLowThreshold(p.stock, p.lowStockThreshold),
                )
                .length *
            defaultCopies,
      LabelBulkMode.allActive =>
        products.where((p) => p.isActive).length * defaultCopies,
    };
  }

  LabelsLoaded copyWith({
    List<LabelTemplateItem>? templates,
    List<ProductItem>? products,
    List<String>? categories,
    List<LabelPrintJobItem>? history,
    String? query,
    LabelsTab? tab,
    LabelBulkMode? bulkMode,
    String? categoryFilter,
    bool clearCategoryFilter = false,
    LabelStoreType? storeTypeFilter,
    bool clearStoreTypeFilter = false,
    int? selectedTemplateId,
    Map<int, LabelProductLine>? selectedLines,
    int? defaultCopies,
    bool? isPrinting,
    String? message,
    bool clearMessage = false,
  }) {
    return LabelsLoaded(
      templates: templates ?? this.templates,
      products: products ?? this.products,
      categories: categories ?? this.categories,
      history: history ?? this.history,
      query: query ?? this.query,
      tab: tab ?? this.tab,
      bulkMode: bulkMode ?? this.bulkMode,
      categoryFilter:
          clearCategoryFilter ? null : categoryFilter ?? this.categoryFilter,
      storeTypeFilter:
          clearStoreTypeFilter ? null : storeTypeFilter ?? this.storeTypeFilter,
      selectedTemplateId: selectedTemplateId ?? this.selectedTemplateId,
      selectedLines: selectedLines ?? this.selectedLines,
      defaultCopies: defaultCopies ?? this.defaultCopies,
      isPrinting: isPrinting ?? this.isPrinting,
      message: clearMessage ? null : message ?? this.message,
    );
  }

  @override
  List<Object?> get props => [
        templates,
        products,
        categories,
        history,
        query,
        tab,
        bulkMode,
        categoryFilter,
        storeTypeFilter,
        selectedTemplateId,
        selectedLines,
        defaultCopies,
        isPrinting,
        message,
      ];
}
