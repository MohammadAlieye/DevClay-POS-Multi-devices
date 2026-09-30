import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../utils/user_facing_error.dart';
import '../../../../utils/measure_units.dart';

import '../../../../core/di/injection.dart';
import '../../../../services/feedback/app_sound_service.dart';
import '../../../notifications/presentation/cubit/notifications_cubit.dart';
import '../../domain/entities/pos_entities.dart';
import '../../domain/repositories/pos_repository.dart';
import '../utils/pos_ui_prefs.dart';

part 'pos_event.dart';
part 'pos_state.dart';

class PosBloc extends Bloc<PosEvent, PosState> {
  PosBloc(this._repository) : super(const PosInitial()) {
    on<PosStarted>(_onStarted);
    on<PosSearchChanged>(_onSearch);
    on<PosScanSubmitted>(_onScanSubmitted);
    on<PosCategorySelected>(_onCategory);
    on<PosStockFilterSelected>(_onStockFilter);
    on<PosProductAdded>(_onProductAdded);
    on<PosVariableLineAdded>(_onVariableLineAdded);
    on<PosDisplayQuantityChanged>(_onDisplayQuantityChanged);
    on<PosQuantityChanged>(_onQuantity);
    on<PosLineChargeChanged>(_onLineChargeChanged);
    on<PosLineDiscountChanged>(_onLineDiscountChanged);
    on<PosLineRemoved>(_onLineRemoved);
    on<PosCartDiscountChanged>(_onCartDiscount);
    on<PosCartDiscountModeChanged>(_onCartDiscountMode);
    on<PosCustomerChanged>(_onCustomer);
    on<PosCustomerSelected>(_onCustomerSelected);
    on<PosCustomerCreated>(_onCustomerCreated);
    on<PosNotesChanged>(_onNotes);
    on<PosHoldRequested>(_onHold);
    on<PosResumeRequested>(_onResume);
    on<PosHeldSaleDeleted>(_onHeldDeleted);
    on<PosHeldSalesRequested>(_onHeldList);
    on<PosCheckoutRequested>(_onCheckout);
    on<PosCheckoutClosed>(_onCheckoutClosed);
    on<PosPaymentCompleted>(_onPaymentCompleted);
    on<PosClearCart>(_onClear);
    on<PosDismissMessage>(_onDismiss);
    on<PosCatalogRefreshRequested>(_onCatalogRefresh);
  }

  final PosRepository _repository;

  Future<void> _onStarted(PosStarted event, Emitter<PosState> emit) async {
    emit(const PosLoading());
    try {
      await PosUiPrefs.instance.load();
      final products = await _repository.getProducts();
      final categories = await _repository.getCategories();
      final held = await _repository.getHeldSales();
      final customers = await _repository.getCustomers();
      emit(
        PosReady(
          allProducts: products,
          categories: categories,
          selectedCategory: 'All',
          query: '',
          lines: const [],
          cartDiscount: 0,
          cartDiscountMode: PosUiPrefs.instance.cartDiscountIsPercent
              ? CartDiscountMode.percent
              : CartDiscountMode.fixed,
          heldSales: held,
          customers: customers,
        ),
      );
    } catch (error) {
      emit(PosError(userFacingError(error)));
    }
  }

  void _onSearch(PosSearchChanged event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(current.copyWith(query: event.query));
  }

  void _onScanSubmitted(PosScanSubmitted event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;

    final code = event.code.trim();
    if (code.isEmpty) {
      emit(current.copyWith(query: ''));
      return;
    }

    final match = _matchScannedProduct(current.allProducts, code);
    if (match == null) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(query: '', message: 'No product found for "$code".'),
      );
      return;
    }

    _addProductToCart(current, match, emit, clearQuery: true);
  }

  void _onCategory(PosCategorySelected event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(current.copyWith(selectedCategory: event.category));
  }

  void _onStockFilter(PosStockFilterSelected event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(current.copyWith(stockFilter: event.filter));
  }

  void _onProductAdded(PosProductAdded event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    _addProductToCart(current, event.product, emit, batch: event.batch);
  }

  void _addProductToCart(
    PosReady current,
    PosProduct product,
    Emitter<PosState> emit, {
    bool clearQuery = false,
    PosBatchLot? batch,
  }) {
    if (product.sellingPrice <= 0) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(
          query: clearQuery ? '' : current.query,
          message:
              '${product.name} has no selling price. Set it in Purchases first.',
        ),
      );
      return;
    }
    if (product.stock <= 0) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(
          query: clearQuery ? '' : current.query,
          message: '${product.name} is out of stock. Please refill.',
        ),
      );
      return;
    }

    final isVariable = product.isVariable;
    final baseAdd = isVariable
        ? MeasureUnits.toBaseUnits(
            1,
            product.unit,
            product.sellTypeEnum,
          )
        : 1;

    final productQtyInCart = current.lines
        .where((line) => line.product.id == product.id)
        .fold<int>(0, (sum, line) => sum + line.quantity);
    if (productQtyInCart + baseAdd > product.stock) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(
          query: clearQuery ? '' : current.query,
          message:
              'Only ${product.formattedStock} left for ${product.name}. Please refill.',
        ),
      );
      return;
    }
    if (batch != null) {
      final batchQtyInCart = current.lines
          .where(
            (line) =>
                line.product.id == product.id &&
                line.selectedBatch?.id == batch.id,
          )
          .fold<int>(0, (sum, line) => sum + line.quantity);
      if (batchQtyInCart + baseAdd > batch.quantity) {
        AppSounds.play(AppSound.error);
        emit(
          current.copyWith(
            query: clearQuery ? '' : current.query,
            message:
                'Only ${MeasureUnits.formatQuantity(batch.quantity, product.unit, product.sellTypeEnum)} remain in batch ${batch.displayCode}.',
          ),
        );
        return;
      }
    }

    final existingIndex = current.lines.indexWhere(
      (line) =>
          line.product.id == product.id && line.selectedBatch?.id == batch?.id,
    );
    final lines = [...current.lines];
    if (existingIndex >= 0) {
      final existing = lines[existingIndex];
      final nextQty = existing.quantity + baseAdd;
      lines[existingIndex] = existing.copyWith(
        quantity: nextQty,
        isVariableSale: isVariable || existing.isVariableSale,
        quantityLabel: isVariable || existing.isVariableSale
            ? MeasureUnits.formatQuantity(
                nextQty,
                product.unit,
                product.sellTypeEnum,
              )
            : existing.quantityLabel,
      );
    } else {
      lines.add(
        CartLine(
          product: product,
          quantity: baseAdd,
          isVariableSale: isVariable,
          quantityLabel: isVariable
              ? MeasureUnits.formatQuantity(
                  baseAdd,
                  product.unit,
                  product.sellTypeEnum,
                )
              : null,
          selectedBatch: batch,
        ),
      );
    }

    final expired = batch?.isExpired ?? product.isExpired;
    final expiredNotice = expired
        ? '${product.name} is expired · please check before selling.'
        : null;
    if (expiredNotice != null) {
      AppSounds.play(AppSound.error);
    } else {
      AppSounds.play(AppSound.cartAdd);
    }
    emit(
      current.copyWith(
        lines: lines,
        query: clearQuery ? '' : current.query,
        message: expiredNotice,
        clearMessage: expiredNotice == null,
      ),
    );
  }

  void _onVariableLineAdded(
    PosVariableLineAdded event,
    Emitter<PosState> emit,
  ) {
    final current = state;
    if (current is! PosReady) return;
    final product = event.product;
    if (product.sellingPrice <= 0) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(
          message:
              '${product.name} has no selling price. Set it in Purchases first.',
        ),
      );
      return;
    }
    if (event.quantityBaseUnits <= 0) {
      AppSounds.play(AppSound.error);
      emit(current.copyWith(message: 'Enter a valid quantity or amount.'));
      return;
    }

    final lines = [...current.lines];
    final replaceIndex = event.replaceIndex;
    final otherQty = lines
        .asMap()
        .entries
        .where(
          (entry) =>
              entry.key != replaceIndex && entry.value.product.id == product.id,
        )
        .fold<int>(0, (sum, entry) => sum + entry.value.quantity);
    if (otherQty + event.quantityBaseUnits > product.stock) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(
          message:
              'Only ${product.formattedStock} left for ${product.name}.',
        ),
      );
      return;
    }

    final line = CartLine(
      product: product,
      quantity: event.quantityBaseUnits,
      quantityLabel: event.quantityLabel,
      overrideLineTotal: event.overrideLineTotal,
      isVariableSale: true,
      selectedBatch: event.selectedBatch,
    );

    if (replaceIndex != null &&
        replaceIndex >= 0 &&
        replaceIndex < lines.length) {
      lines[replaceIndex] = line;
    } else {
      lines.add(line);
    }

    AppSounds.play(AppSound.cartAdd);
    emit(current.copyWith(lines: lines, clearMessage: true));
  }

  PosProduct? _matchScannedProduct(List<PosProduct> products, String code) {
    final q = code.toLowerCase();

    final byBarcode = products
        .where((p) => p.barcode.trim().toLowerCase() == q)
        .toList(growable: false);
    if (byBarcode.isNotEmpty) return byBarcode.first;

    final bySku = products
        .where((p) => p.sku.trim().toLowerCase() == q)
        .toList(growable: false);
    if (bySku.isNotEmpty) return bySku.first;

    final byName = products
        .where((p) => p.name.trim().toLowerCase() == q)
        .toList(growable: false);
    if (byName.length == 1) return byName.first;

    return null;
  }

  void _onDisplayQuantityChanged(
    PosDisplayQuantityChanged event,
    Emitter<PosState> emit,
  ) {
    final current = state;
    if (current is! PosReady) return;
    if (event.index < 0 || event.index >= current.lines.length) return;

    final lines = [...current.lines];
    final line = lines[event.index];
    if (!line.isVariableSale && !line.product.isVariable) return;

    if (event.displayQuantity <= 0) {
      lines.removeAt(event.index);
      emit(current.copyWith(lines: lines, clearMessage: true));
      AppSounds.play(AppSound.cartRemove);
      return;
    }

    final product = line.product;
    final baseQty = MeasureUnits.toBaseUnits(
      event.displayQuantity,
      product.unit,
      product.sellTypeEnum,
    );
    if (baseQty <= 0) {
      emit(current.copyWith(message: 'Enter a valid quantity.'));
      return;
    }

    final otherProductQty = lines
        .asMap()
        .entries
        .where(
          (entry) =>
              entry.key != event.index &&
              entry.value.product.id == product.id,
        )
        .fold<int>(0, (sum, entry) => sum + entry.value.quantity);
    if (otherProductQty + baseQty > product.stock) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(
          message:
              'Only ${product.formattedStock} left for ${product.name}. Please refill.',
        ),
      );
      return;
    }

    final oldFactor = line.qtyFactor;
    var next = line.copyWith(
      quantity: baseQty,
      isVariableSale: true,
      quantityLabel: MeasureUnits.formatQuantity(
        baseQty,
        product.unit,
        product.sellTypeEnum,
      ),
      clearOverrideLineTotal: true,
    );
    next = _scaleFixedDiscountForQty(line: next, oldFactor: oldFactor);
    lines[event.index] = next.withClampedDiscount();
    emit(current.copyWith(lines: lines, clearMessage: true));
  }

  void _onQuantity(PosQuantityChanged event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    final lines = [...current.lines];
    if (event.quantity <= 0) {
      lines.removeAt(event.index);
      emit(current.copyWith(lines: lines, clearMessage: true));
      AppSounds.play(AppSound.cartRemove);
      return;
    }

    final line = lines[event.index];
    if (line.isVariableSale || line.product.isVariable) {
      final step = MeasureUnits.displayStep(
        line.product.unit,
        line.product.sellTypeEnum,
      );
      final isPlus = event.quantity > line.quantity;
      final nextDisplay = isPlus
          ? line.displayQuantity + step
          : line.displayQuantity - step;
      _onDisplayQuantityChanged(
        PosDisplayQuantityChanged(
          index: event.index,
          displayQuantity: nextDisplay,
        ),
        emit,
      );
      return;
    }
    final otherProductQty = lines
        .asMap()
        .entries
        .where(
          (entry) =>
              entry.key != event.index &&
              entry.value.product.id == line.product.id,
        )
        .fold<int>(0, (sum, entry) => sum + entry.value.quantity);
    if (otherProductQty + event.quantity > line.product.stock) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(
          message:
              'Only ${line.product.stock} left in stock for ${line.product.name}. Please refill.',
        ),
      );
      return;
    }
    final selectedBatch = line.selectedBatch;
    if (selectedBatch != null) {
      final otherBatchQty = lines
          .asMap()
          .entries
          .where(
            (entry) =>
                entry.key != event.index &&
                entry.value.selectedBatch?.id == selectedBatch.id,
          )
          .fold<int>(0, (sum, entry) => sum + entry.value.quantity);
      if (otherBatchQty + event.quantity > selectedBatch.quantity) {
        AppSounds.play(AppSound.error);
        emit(
          current.copyWith(
            message:
                'Only ${selectedBatch.quantity} units remain in batch ${selectedBatch.displayCode}.',
          ),
        );
        return;
      }
    }

    final oldFactor = line.qtyFactor;
    var next = line.copyWith(
      quantity: event.quantity,
      clearOverrideLineTotal: true,
    );
    next = _scaleFixedDiscountForQty(line: next, oldFactor: oldFactor);
    lines[event.index] = next.withClampedDiscount();
    emit(current.copyWith(lines: lines, clearMessage: true));
  }

  /// Fixed Rs discounts scale with quantity (Rs 20 on 1L → Rs 10 on 0.5L).
  /// Percent discounts already scale via originalSubtotal.
  CartLine _scaleFixedDiscountForQty({
    required CartLine line,
    required double oldFactor,
  }) {
    if (line.lineDiscountMode != LineDiscountMode.fixed) return line;
    if (line.lineDiscount <= 0 || oldFactor <= 0) return line;
    final ratio = line.qtyFactor / oldFactor;
    if ((ratio - 1).abs() < 0.0001) return line;
    final scaled = (line.lineDiscount * ratio * 100).roundToDouble() / 100;
    return line.copyWith(lineDiscount: scaled < 0 ? 0 : scaled);
  }

  void _onLineChargeChanged(PosLineChargeChanged event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    if (event.index < 0 || event.index >= current.lines.length) return;
    if (event.charge <= 0) {
      emit(current.copyWith(message: 'Enter a valid charge amount.'));
      return;
    }

    final lines = [...current.lines];
    final line = lines[event.index];
    final product = line.product;
    if (product.sellingPrice <= 0) {
      emit(current.copyWith(message: '${product.name} has no selling price.'));
      return;
    }

    final original = originalSubtotalFromFinalCharge(
      finalCharge: event.charge,
      discountValue: line.effectiveLineDiscount,
      mode: line.lineDiscountMode,
    );
    final displayQty = original / product.sellingPrice;
    if (displayQty <= 0) {
      emit(current.copyWith(message: 'Enter a valid charge amount.'));
      return;
    }

    final minCharge = product.purchasePrice * displayQty;
    if (event.charge < minCharge - 0.009) {
      AppSounds.play(AppSound.error);
      emit(
        current.copyWith(
          message:
              'Charge cannot go below purchase cost '
              '(Rs ${minCharge.toStringAsFixed(minCharge == minCharge.roundToDouble() ? 0 : 2)}).',
        ),
      );
      return;
    }

    if (line.isVariableSale || product.isVariable) {
      final baseQty = MeasureUnits.toBaseUnits(
        displayQty,
        product.unit,
        product.sellTypeEnum,
      );
      if (baseQty <= 0) {
        emit(current.copyWith(message: 'Enter a valid charge amount.'));
        return;
      }
      final otherProductQty = lines
          .asMap()
          .entries
          .where(
            (entry) =>
                entry.key != event.index &&
                entry.value.product.id == product.id,
          )
          .fold<int>(0, (sum, entry) => sum + entry.value.quantity);
      if (otherProductQty + baseQty > product.stock) {
        AppSounds.play(AppSound.error);
        emit(
          current.copyWith(
            message:
                'Only ${product.formattedStock} left for ${product.name}. Please refill.',
          ),
        );
        return;
      }
      lines[event.index] = line.copyWith(
        quantity: baseQty,
        isVariableSale: true,
        quantityLabel: MeasureUnits.formatQuantity(
          baseQty,
          product.unit,
          product.sellTypeEnum,
        ),
        clearOverrideLineTotal: true,
      ).withClampedDiscount();
    } else {
      final nextQty = displayQty.round().clamp(1, 999999999);
      final otherProductQty = lines
          .asMap()
          .entries
          .where(
            (entry) =>
                entry.key != event.index &&
                entry.value.product.id == product.id,
          )
          .fold<int>(0, (sum, entry) => sum + entry.value.quantity);
      if (otherProductQty + nextQty > product.stock) {
        AppSounds.play(AppSound.error);
        emit(
          current.copyWith(
            message:
                'Only ${product.stock} left in stock for ${product.name}. Please refill.',
          ),
        );
        return;
      }
      lines[event.index] = line.copyWith(
        quantity: nextQty,
        clearOverrideLineTotal: true,
      ).withClampedDiscount();
    }

    emit(current.copyWith(lines: lines, clearMessage: true));
  }

  void _onLineDiscountChanged(
    PosLineDiscountChanged event,
    Emitter<PosState> emit,
  ) {
    final current = state;
    if (current is! PosReady) return;
    if (event.index < 0 || event.index >= current.lines.length) return;

    final lines = [...current.lines];
    final line = lines[event.index];
    final mode = event.mode ?? line.lineDiscountMode;
    final value = mode == LineDiscountMode.percent
        ? event.value.clamp(0.0, 100.0).toDouble()
        : (event.value < 0 ? 0.0 : event.value);
    final clamped = clampLineDiscountInput(
      originalSubtotal: line.originalSubtotal,
      minSubtotalBeforeTax: line.minSubtotalBeforeTax,
      discountValue: value,
      mode: mode,
    );
    final wasClamped = (value - clamped).abs() > 0.009 && value > 0;

    lines[event.index] = line.copyWith(
      lineDiscount: clamped,
      lineDiscountMode: mode,
      clearOverrideLineTotal: true,
    );
    if (wasClamped) {
      AppSounds.play(AppSound.error);
    }
    emit(
      current.copyWith(
        lines: lines,
        message: wasClamped
            ? 'Discount limited to Rs ${line.maxDiscountAmount.toStringAsFixed(line.maxDiscountAmount == line.maxDiscountAmount.roundToDouble() ? 0 : 2)} '
                '(cannot sell below purchase cost).'
            : null,
        clearMessage: !wasClamped,
      ),
    );
  }

  void _onLineRemoved(PosLineRemoved event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    final lines = [...current.lines]..removeAt(event.index);
    emit(current.copyWith(lines: lines));
    AppSounds.play(AppSound.cartRemove);
  }

  void _onCartDiscount(PosCartDiscountChanged event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    final value = current.cartDiscountMode == CartDiscountMode.percent
        ? event.value.clamp(0.0, 100.0).toDouble()
        : (event.value < 0 ? 0.0 : event.value);
    emit(current.copyWith(cartDiscount: value));
  }

  Future<void> _onCartDiscountMode(
    PosCartDiscountModeChanged event,
    Emitter<PosState> emit,
  ) async {
    final current = state;
    if (current is! PosReady) return;
    if (current.cartDiscountMode == event.mode) return;

    await PosUiPrefs.instance.setCartDiscountIsPercent(
      event.mode == CartDiscountMode.percent,
    );
    emit(current.copyWith(cartDiscountMode: event.mode, cartDiscount: 0));
  }

  void _onCustomer(PosCustomerChanged event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(
      current.copyWith(
        customerName: event.name,
        clearCustomer: event.name.trim().isEmpty,
        clearSelectedCustomer:
            current.selectedCustomerId != null &&
            current.customerName != event.name,
      ),
    );
  }

  void _onCustomerSelected(PosCustomerSelected event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(
      current.copyWith(
        selectedCustomerId: event.customer.id,
        customerName: event.customer.name,
      ),
    );
  }

  void _onCustomerCreated(PosCustomerCreated event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    final customers = [...current.customers, event.customer]
      ..sort((a, b) => a.name.compareTo(b.name));
    emit(
      current.copyWith(
        customers: customers,
        selectedCustomerId: event.customer.id,
        customerName: event.customer.name,
      ),
    );
  }

  void _onNotes(PosNotesChanged event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(current.copyWith(notes: event.notes));
  }

  Future<void> _onHold(PosHoldRequested event, Emitter<PosState> emit) async {
    final current = state;
    if (current is! PosReady || current.lines.isEmpty) return;
    try {
      await _repository.holdSale(
        lines: current.lines,
        cartDiscount: current.cartDiscount,
        cartDiscountMode: current.cartDiscountMode,
        customerName: current.customerName,
        customerId: current.selectedCustomerId,
        notes: current.notes,
      );
      final held = await _repository.getHeldSales();
      emit(
        current.copyWith(
          lines: const [],
          cartDiscount: 0,
          clearCustomer: true,
          clearNotes: true,
          heldSales: held,
          message: 'Sale held successfully',
        ),
      );
    } catch (error) {
      emit(current.copyWith(message: userFacingError(error)));
    }
  }

  Future<void> _onHeldList(
    PosHeldSalesRequested event,
    Emitter<PosState> emit,
  ) async {
    final current = state;
    if (current is! PosReady) return;
    final held = await _repository.getHeldSales();
    emit(current.copyWith(heldSales: held));
  }

  Future<void> _onResume(
    PosResumeRequested event,
    Emitter<PosState> emit,
  ) async {
    final current = state;
    if (current is! PosReady) return;
    if (current.lines.isNotEmpty) {
      emit(
        current.copyWith(
          message:
              'Your cart already has items. Hold or clear it before '
              'resuming another bill.',
        ),
      );
      return;
    }
    try {
      final resumed = await _repository.resumeSale(event.heldSaleId);
      final held = await _repository.getHeldSales();
      emit(
        current.copyWith(
          lines: resumed.lines,
          cartDiscount: resumed.cartDiscount,
          cartDiscountMode: resumed.cartDiscountMode,
          customerName: resumed.customerName,
          selectedCustomerId: resumed.customerId,
          notes: resumed.notes,
          heldSales: held,
          message: 'Held sale resumed',
        ),
      );
    } catch (error) {
      emit(current.copyWith(message: userFacingError(error)));
    }
  }

  Future<void> _onHeldDeleted(
    PosHeldSaleDeleted event,
    Emitter<PosState> emit,
  ) async {
    final current = state;
    if (current is! PosReady) return;
    try {
      await _repository.deleteHeldSale(event.heldSaleId);
      final held = await _repository.getHeldSales();
      emit(current.copyWith(heldSales: held, clearMessage: true));
    } catch (error) {
      emit(current.copyWith(message: userFacingError(error)));
    }
  }

  void _onCheckout(PosCheckoutRequested event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady || current.lines.isEmpty) return;
    emit(current.copyWith(checkoutOpen: true));
  }

  void _onCheckoutClosed(PosCheckoutClosed event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(current.copyWith(checkoutOpen: false));
  }

  Future<void> _onPaymentCompleted(
    PosPaymentCompleted event,
    Emitter<PosState> emit,
  ) async {
    final current = state;
    if (current is! PosReady || current.lines.isEmpty) return;
    try {
      final sale = await _repository.completeSale(
        lines: current.lines,
        cartDiscount: current.cartDiscount,
        cartDiscountMode: current.cartDiscountMode,
        method: event.method,
        amountPaid: event.amountPaid,
        cardAmount: event.cardAmount,
        customerName: current.customerName,
        customerId: current.selectedCustomerId,
        notes: current.notes,
        cashAccountId: event.cashAccountId,
        bankAccountId: event.bankAccountId,
      );
      final products = await _repository.getProducts();
      final customers = await _repository.getCustomers();
      emit(
        current.copyWith(
          allProducts: products,
          customers: customers,
          lines: const [],
          cartDiscount: 0,
          clearCustomer: true,
          clearNotes: true,
          checkoutOpen: false,
          lastSale: sale,
          message: 'Sale completed · ${sale.invoiceNo}',
        ),
      );
      // Surface out-of-stock / low-stock alerts after inventory drops.
      await sl<NotificationsCubit>().refresh(flashNewOutOfStock: true);
    } catch (error) {
      emit(
        current.copyWith(message: userFacingError(error), checkoutOpen: false),
      );
    }
  }

  void _onClear(PosClearCart event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(
      current.copyWith(
        lines: const [],
        cartDiscount: 0,
        clearCustomer: true,
        clearNotes: true,
        clearLastSale: true,
      ),
    );
  }

  void _onDismiss(PosDismissMessage event, Emitter<PosState> emit) {
    final current = state;
    if (current is! PosReady) return;
    emit(current.copyWith(clearMessage: true, clearLastSale: true));
  }

  Future<void> _onCatalogRefresh(
    PosCatalogRefreshRequested event,
    Emitter<PosState> emit,
  ) async {
    final current = state;
    if (current is! PosReady) return;
    try {
      final products = await _repository.getProducts();
      final categories = await _repository.getCategories();
      final held = await _repository.getHeldSales();
      final customers = await _repository.getCustomers();
      emit(
        current.copyWith(
          allProducts: products,
          categories: categories,
          heldSales: held,
          customers: customers,
        ),
      );
    } catch (error) {
      emit(current.copyWith(message: userFacingError(error)));
    }
  }
}
