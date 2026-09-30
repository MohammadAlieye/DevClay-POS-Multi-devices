import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../../inventory/domain/entities/inventory_entities.dart';
import '../../../products/domain/entities/product_item.dart';
import '../../../settings/domain/repositories/settings_repository.dart';
import '../../domain/entities/label_entities.dart';
import '../../domain/repositories/labels_repository.dart';

part 'labels_event.dart';
part 'labels_state.dart';

class LabelsBloc extends Bloc<LabelsEvent, LabelsState> {
  LabelsBloc(this._repository, this._settingsRepository)
    : super(const LabelsInitial()) {
    on<LabelsStarted>(_onStarted);
    on<LabelsTabChanged>(_onTab);
    on<LabelsSearchChanged>(_onSearch);
    on<LabelsTemplateSelected>(_onTemplateSelected);
    on<LabelsStoreTypeFilterChanged>(_onStoreTypeFilter);
    on<LabelsBulkModeChanged>(_onBulkMode);
    on<LabelsCategoryChanged>(_onCategory);
    on<LabelsProductToggled>(_onProductToggled);
    on<LabelsSelectAllVisible>(_onSelectAll);
    on<LabelsClearSelection>(_onClearSelection);
    on<LabelsDefaultCopiesChanged>(_onDefaultCopies);
    on<LabelsLineCopiesChanged>(_onLineCopies);
    on<LabelsPrintRequested>(_onPrint);
    on<LabelsTemplateSaved>(_onTemplateSaved);
    on<LabelsTemplateDeleted>(_onTemplateDeleted);
    on<LabelsRefreshRequested>(_onRefresh);
    on<LabelsMessageDismissed>(_onDismiss);
  }

  final LabelsRepository _repository;
  final SettingsRepository _settingsRepository;

  Future<void> _onStarted(
    LabelsStarted event,
    Emitter<LabelsState> emit,
  ) async {
    emit(const LabelsLoading());
    await _load(emit);
  }

  Future<void> _onTab(LabelsTabChanged event, Emitter<LabelsState> emit) async {
    final current = state;
    if (current is LabelsLoaded) emit(current.copyWith(tab: event.tab));
  }

  Future<void> _onSearch(
    LabelsSearchChanged event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is LabelsLoaded) emit(current.copyWith(query: event.query));
  }

  Future<void> _onTemplateSelected(
    LabelsTemplateSelected event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is LabelsLoaded) {
      emit(
        current.copyWith(
          selectedTemplateId: event.templateId,
          defaultCopies:
              event.defaultCopies ??
              current.templates
                  .firstWhere((t) => t.id == event.templateId)
                  .defaultCopies,
        ),
      );
    }
  }

  Future<void> _onStoreTypeFilter(
    LabelsStoreTypeFilterChanged event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is! LabelsLoaded) return;

    emit(
      current.copyWith(
        storeTypeFilter: event.storeType,
        clearStoreTypeFilter: event.storeType == null,
      ),
    );
  }

  Future<void> _onBulkMode(
    LabelsBulkModeChanged event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is LabelsLoaded) {
      emit(current.copyWith(bulkMode: event.mode));
    }
  }

  Future<void> _onCategory(
    LabelsCategoryChanged event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is LabelsLoaded) {
      emit(
        current.copyWith(
          categoryFilter: event.category,
          clearCategoryFilter: event.category == null,
        ),
      );
    }
  }

  Future<void> _onProductToggled(
    LabelsProductToggled event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is! LabelsLoaded) return;

    final selected = Map<int, LabelProductLine>.from(current.selectedLines);
    if (selected.containsKey(event.productId)) {
      selected.remove(event.productId);
    } else {
      final product = current.products.firstWhere(
        (p) => p.id == event.productId,
      );
      selected[event.productId] = _repository.productToLine(
        product,
        copies: current.defaultCopies,
      );
    }
    emit(current.copyWith(selectedLines: selected));
  }

  Future<void> _onSelectAll(
    LabelsSelectAllVisible event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is! LabelsLoaded) return;

    final selected = Map<int, LabelProductLine>.from(current.selectedLines);
    for (final product in current.visibleProducts) {
      selected[product.id] = _repository.productToLine(
        product,
        copies: current.defaultCopies,
      );
    }
    emit(current.copyWith(selectedLines: selected));
  }

  Future<void> _onClearSelection(
    LabelsClearSelection event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is LabelsLoaded) {
      emit(current.copyWith(selectedLines: const {}));
    }
  }

  Future<void> _onDefaultCopies(
    LabelsDefaultCopiesChanged event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is LabelsLoaded) {
      emit(current.copyWith(defaultCopies: _clampCopies(event.copies)));
    }
  }

  Future<void> _onLineCopies(
    LabelsLineCopiesChanged event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is! LabelsLoaded) return;
    final line = current.selectedLines[event.productId];
    if (line == null) return;

    final selected = Map<int, LabelProductLine>.from(current.selectedLines);
    selected[event.productId] = line.copyWith(copies: _clampCopies(event.copies));
    emit(current.copyWith(selectedLines: selected));
  }

  int _clampCopies(int copies) {
    if (copies < 1) return 1;
    if (copies > 999) return 999;
    return copies;
  }

  Future<void> _onPrint(
    LabelsPrintRequested event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is! LabelsLoaded) return;

    final template = current.selectedTemplate;
    if (template == null) {
      emit(current.copyWith(message: 'Select a label template'));
      return;
    }

    final lines = _resolvePrintLines(current);
    if (lines.isEmpty) {
      emit(current.copyWith(message: 'Select products to print'));
      return;
    }

    emit(current.copyWith(isPrinting: true, clearMessage: true));
    try {
      final settings = await _settingsRepository.getSettings();
      final result = await _repository.printLabels(
        template: template,
        lines: lines,
        storeName: settings.businessName,
        printerName: settings.printerName,
      );
      final history = await _repository.getPrintHistory();
      emit(
        (state as LabelsLoaded).copyWith(
          isPrinting: false,
          history: history,
          message: result.message ?? 'Labels printed',
        ),
      );
    } catch (error) {
      emit(
        (state as LabelsLoaded).copyWith(
          isPrinting: false,
          message: userFacingError(error),
        ),
      );
    }
  }

  Future<void> _onTemplateSaved(
    LabelsTemplateSaved event,
    Emitter<LabelsState> emit,
  ) async {
    try {
      await _repository.saveTemplate(event.draft, id: event.id);
      await _load(
        emit,
        message: event.id == null ? 'Template created' : 'Template updated',
      );
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onTemplateDeleted(
    LabelsTemplateDeleted event,
    Emitter<LabelsState> emit,
  ) async {
    try {
      await _repository.deleteTemplate(event.id);
      await _load(emit, message: 'Template deleted');
    } catch (error) {
      _emitActionError(emit, error);
    }
  }

  Future<void> _onRefresh(
    LabelsRefreshRequested event,
    Emitter<LabelsState> emit,
  ) async {
    await _load(emit);
  }

  void _emitActionError(Emitter<LabelsState> emit, Object error) {
    final current = state;
    final message = userFacingError(error);
    if (current is LabelsLoaded) {
      emit(current.copyWith(message: message, isPrinting: false));
    } else {
      emit(LabelsError(message));
    }
  }

  Future<void> _onDismiss(
    LabelsMessageDismissed event,
    Emitter<LabelsState> emit,
  ) async {
    final current = state;
    if (current is LabelsLoaded) emit(current.copyWith(clearMessage: true));
  }

  List<LabelProductLine> _resolvePrintLines(LabelsLoaded state) {
    return switch (state.bulkMode) {
      LabelBulkMode.selected => state.selectedLines.values.toList(),
      LabelBulkMode.category =>
        state.visibleProducts
            .map(
              (p) => _repository.productToLine(p, copies: state.defaultCopies),
            )
            .toList(),
      LabelBulkMode.lowStock =>
        state.visibleProducts
            .where(
              (p) => isStockAtOrBelowLowThreshold(p.stock, p.lowStockThreshold),
            )
            .map(
              (p) => _repository.productToLine(p, copies: state.defaultCopies),
            )
            .toList(),
      LabelBulkMode.allActive =>
        state.products
            .where((p) => p.isActive)
            .map(
              (p) => _repository.productToLine(p, copies: state.defaultCopies),
            )
            .toList(),
    };
  }

  Future<void> _load(Emitter<LabelsState> emit, {String? message}) async {
    try {
      final current = state;
      final query = current is LabelsLoaded ? current.query : '';
      final tab = current is LabelsLoaded ? current.tab : LabelsTab.print;
      final bulkMode = LabelBulkMode.selected;
      final categoryFilter = null;
      final storeTypeFilter = current is LabelsLoaded
          ? current.storeTypeFilter
          : null;
      final selectedLines = current is LabelsLoaded
          ? current.selectedLines
          : const {};
      final defaultCopies = current is LabelsLoaded ? current.defaultCopies : 1;

      final templates = await _repository.getTemplates();
      final products = await _repository.getProducts();
      final categories = await _repository.getCategories();
      final history = await _repository.getPrintHistory();

      final defaultTemplate =
          templates.where((t) => t.isDefault).firstOrNull ??
          templates.firstOrNull;

      emit(
        LabelsLoaded(
          templates: templates,
          products: products,
          categories: categories,
          history: history,
          query: query,
          tab: tab,
          bulkMode: bulkMode,
          categoryFilter: categoryFilter,
          storeTypeFilter: storeTypeFilter,
          selectedTemplateId: current is LabelsLoaded
              ? current.selectedTemplateId ?? defaultTemplate?.id
              : defaultTemplate?.id,
          selectedLines: Map<int, LabelProductLine>.from(selectedLines),
          defaultCopies: defaultCopies,
          message: message,
        ),
      );
    } catch (error) {
      final current = state;
      if (current is LabelsLoaded) {
        emit(current.copyWith(message: userFacingError(error)));
      } else {
        emit(LabelsError(userFacingError(error)));
      }
    }
  }
}
