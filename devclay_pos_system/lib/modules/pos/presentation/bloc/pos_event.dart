part of 'pos_bloc.dart';

sealed class PosEvent extends Equatable {
  const PosEvent();

  @override
  List<Object?> get props => [];
}

final class PosStarted extends PosEvent {
  const PosStarted();
}

final class PosSearchChanged extends PosEvent {
  const PosSearchChanged(this.query);

  final String query;

  @override
  List<Object?> get props => [query];
}

/// Barcode / SKU / name submitted from the POS search field (scanner Enter).
final class PosScanSubmitted extends PosEvent {
  const PosScanSubmitted(this.code);

  final String code;

  @override
  List<Object?> get props => [code];
}

final class PosVariableLineAdded extends PosEvent {
  const PosVariableLineAdded({
    required this.product,
    required this.quantityBaseUnits,
    required this.quantityLabel,
    this.overrideLineTotal,
    this.selectedBatch,
    this.replaceIndex,
  });

  final PosProduct product;
  final int quantityBaseUnits;
  final String quantityLabel;
  final double? overrideLineTotal;
  final PosBatchLot? selectedBatch;
  final int? replaceIndex;

  @override
  List<Object?> get props => [
    product,
    quantityBaseUnits,
    quantityLabel,
    overrideLineTotal,
    selectedBatch,
    replaceIndex,
  ];
}

final class PosDisplayQuantityChanged extends PosEvent {
  const PosDisplayQuantityChanged({
    required this.index,
    required this.displayQuantity,
  });

  final int index;
  final double displayQuantity;

  @override
  List<Object?> get props => [index, displayQuantity];
}

final class PosCategorySelected extends PosEvent {
  const PosCategorySelected(this.category);

  final String category;

  @override
  List<Object?> get props => [category];
}

final class PosStockFilterSelected extends PosEvent {
  const PosStockFilterSelected(this.filter);

  final PosStockFilter filter;

  @override
  List<Object?> get props => [filter];
}

final class PosProductAdded extends PosEvent {
  const PosProductAdded(this.product, {this.batch});

  final PosProduct product;
  final PosBatchLot? batch;

  @override
  List<Object?> get props => [product, batch];
}

final class PosQuantityChanged extends PosEvent {
  const PosQuantityChanged({required this.index, required this.quantity});

  final int index;
  final int quantity;

  @override
  List<Object?> get props => [index, quantity];
}

final class PosLineChargeChanged extends PosEvent {
  const PosLineChargeChanged({required this.index, required this.charge});

  final int index;
  /// Final line amount before tax (after line discount).
  final double charge;

  @override
  List<Object?> get props => [index, charge];
}

final class PosLineDiscountChanged extends PosEvent {
  const PosLineDiscountChanged({
    required this.index,
    required this.value,
    this.mode,
  });

  final int index;
  final double value;
  final LineDiscountMode? mode;

  @override
  List<Object?> get props => [index, value, mode];
}

final class PosLineRemoved extends PosEvent {
  const PosLineRemoved(this.index);

  final int index;

  @override
  List<Object?> get props => [index];
}

final class PosCartDiscountChanged extends PosEvent {
  const PosCartDiscountChanged(this.value);

  final double value;

  @override
  List<Object?> get props => [value];
}

final class PosCartDiscountModeChanged extends PosEvent {
  const PosCartDiscountModeChanged(this.mode);

  final CartDiscountMode mode;

  @override
  List<Object?> get props => [mode];
}

final class PosCustomerChanged extends PosEvent {
  const PosCustomerChanged(this.name);

  final String name;

  @override
  List<Object?> get props => [name];
}

final class PosCustomerSelected extends PosEvent {
  const PosCustomerSelected(this.customer);

  final PosCustomer customer;

  @override
  List<Object?> get props => [customer];
}

final class PosCustomerCreated extends PosEvent {
  const PosCustomerCreated(this.customer);

  final PosCustomer customer;

  @override
  List<Object?> get props => [customer];
}

final class PosNotesChanged extends PosEvent {
  const PosNotesChanged(this.notes);

  final String notes;

  @override
  List<Object?> get props => [notes];
}

final class PosHoldRequested extends PosEvent {
  const PosHoldRequested();
}

final class PosHeldSalesRequested extends PosEvent {
  const PosHeldSalesRequested();
}

final class PosResumeRequested extends PosEvent {
  const PosResumeRequested(this.heldSaleId);

  final int heldSaleId;

  @override
  List<Object?> get props => [heldSaleId];
}

final class PosHeldSaleDeleted extends PosEvent {
  const PosHeldSaleDeleted(this.heldSaleId);

  final int heldSaleId;

  @override
  List<Object?> get props => [heldSaleId];
}

final class PosCheckoutRequested extends PosEvent {
  const PosCheckoutRequested();
}

final class PosCheckoutClosed extends PosEvent {
  const PosCheckoutClosed();
}

final class PosPaymentCompleted extends PosEvent {
  const PosPaymentCompleted({
    required this.method,
    required this.amountPaid,
    this.cardAmount = 0,
    this.cashAccountId,
    this.bankAccountId,
  });

  final PaymentMethodKind method;
  final double amountPaid;
  final double cardAmount;
  final int? cashAccountId;
  final int? bankAccountId;

  @override
  List<Object?> get props => [
    method,
    amountPaid,
    cardAmount,
    cashAccountId,
    bankAccountId,
  ];
}

final class PosClearCart extends PosEvent {
  const PosClearCart();
}

final class PosDismissMessage extends PosEvent {
  const PosDismissMessage();
}

/// Reloads products + held bills without clearing the cart.
final class PosCatalogRefreshRequested extends PosEvent {
  const PosCatalogRefreshRequested();
}

final class PosWholesaleModeToggled extends PosEvent {
  const PosWholesaleModeToggled(this.enabled);

  final bool enabled;

  @override
  List<Object?> get props => [enabled];
}
