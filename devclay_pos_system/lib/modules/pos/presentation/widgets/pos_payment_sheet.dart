import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../database/collections/cash_shift.dart';
import '../../../../services/retail/retail_control_service.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/field_limits.dart';
import '../../../accounts/domain/entities/account_entities.dart';
import '../../../customers/domain/repositories/customers_repository.dart';
import '../../../customers/presentation/widgets/customer_editor_sheet.dart';
import '../../domain/entities/pos_entities.dart';
import '../../domain/repositories/pos_repository.dart';
import '../bloc/pos_bloc.dart';
import 'pos_shift_sheet.dart';

const _kCashDenominations = [10, 20, 50, 100, 200, 500, 1000, 2000, 5000];
const _kMaxCashAmount = 999999999.0; // FieldLimits.priceDigits

Future<void> showPosPaymentSheet(BuildContext context, PosReady state) {
  final bloc = context.read<PosBloc>();
  return showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return BlocProvider.value(
        value: bloc,
        child: _PaymentDialog(state: state),
      );
    },
  );
}

class _PaymentDialog extends StatefulWidget {
  const _PaymentDialog({required this.state});

  final PosReady state;

  @override
  State<_PaymentDialog> createState() => _PaymentDialogState();
}

class _PaymentDialogState extends State<_PaymentDialog> {
  PaymentMethodKind _method = PaymentMethodKind.cash;
  late final TextEditingController _cashController;
  late final TextEditingController _cardController;
  late final TextEditingController _customerController;
  late final FocusNode _cashFocus;
  late final FocusNode _cardFocus;
  late final FocusNode _customerFocus;
  late final FocusNode _dialogFocus;
  late List<PosCustomer> _customers;
  PosCustomer? _selectedCustomer;
  List<AccountItem> _accounts = const [];
  int? _cashAccountId;
  int? _bankAccountId;
  bool _loadingAccounts = true;
  bool _submitting = false;
  bool _shiftRequired = false;
  bool _loadingShiftStatus = true;
  CashShift? _activeShift;

  @override
  void initState() {
    super.initState();
    // Leave cash empty — cashier types amount, taps Exact, or uses +notes.
    _cashController = TextEditingController();
    _cardController = TextEditingController();
    _customers = [...widget.state.customers];
    _selectedCustomer = _customerById(widget.state.selectedCustomerId);
    _customerController = TextEditingController(
      text: _selectedCustomer?.name ?? widget.state.customerName ?? '',
    );
    _cashFocus = FocusNode(debugLabel: 'pos-pay-cash');
    _cardFocus = FocusNode(debugLabel: 'pos-pay-card');
    _customerFocus = FocusNode(debugLabel: 'pos-pay-customer');
    _dialogFocus = FocusNode(debugLabel: 'pos-pay-dialog');
    HardwareKeyboard.instance.addHandler(_onHardwareKey);
    _loadAccounts();
    _loadShiftStatus();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _cashFocus.requestFocus();
    });
  }

  Future<void> _loadShiftStatus() async {
    try {
      final service = sl<RetailControlService>();
      final policy = await service.shiftPolicy();
      final shift = await service.activeShift();
      if (!mounted) return;
      setState(() {
        _shiftRequired = policy.required;
        _activeShift = shift;
        _loadingShiftStatus = false;
      });
    } catch (_) {
      if (mounted) setState(() => _loadingShiftStatus = false);
    }
  }

  Future<void> _openShift() async {
    await showPosShiftSheet(context);
    if (mounted) await _loadShiftStatus();
  }

  PosCustomer? _customerById(int? id) {
    if (id == null) return null;
    for (final customer in _customers) {
      if (customer.id == id) return customer;
    }
    return null;
  }

  void _selectCustomer(PosCustomer customer) {
    setState(() {
      _selectedCustomer = customer;
      _customerController.value = TextEditingValue(
        text: customer.name,
        selection: TextSelection.collapsed(offset: customer.name.length),
      );
    });
    context.read<PosBloc>().add(PosCustomerSelected(customer));
    _customerFocus.unfocus();
  }

  Future<void> _addCustomer() async {
    final draft = await showCustomerEditorSheet(
      context: context,
      initialName: _customerController.text.trim(),
    );
    if (draft == null || !mounted) return;
    final saved = await sl<CustomersRepository>().saveCustomer(draft);
    if (!mounted) return;
    final customer = PosCustomer(
      id: saved.id,
      name: saved.name,
      phone: saved.phone,
      balance: saved.balance,
    );
    setState(() {
      _customers = [..._customers, customer]
        ..sort((a, b) => a.name.compareTo(b.name));
    });
    context.read<PosBloc>().add(PosCustomerCreated(customer));
    _selectCustomer(customer);
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await sl<PosRepository>().getPaymentAccounts();
      if (!mounted) return;
      final cashAccounts = accounts
          .where((a) => a.type == AccountType.cash.name)
          .toList();
      final bankAccounts = accounts
          .where(
            (a) =>
                a.type == AccountType.bank.name ||
                a.type == AccountType.mobile.name,
          )
          .toList();
      setState(() {
        _accounts = accounts;
        _cashAccountId =
            cashAccounts
                .where((a) => a.isDefault)
                .map((a) => a.id)
                .firstOrNull ??
            cashAccounts.firstOrNull?.id;
        _bankAccountId =
            bankAccounts
                .where((a) => a.isDefault)
                .map((a) => a.id)
                .firstOrNull ??
            bankAccounts.firstOrNull?.id;
        _loadingAccounts = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _loadingAccounts = false);
    }
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onHardwareKey);
    _cashController.dispose();
    _cardController.dispose();
    _customerController.dispose();
    _cashFocus.dispose();
    _cardFocus.dispose();
    _customerFocus.dispose();
    _dialogFocus.dispose();
    super.dispose();
  }

  List<AccountItem> get _cashAccounts =>
      _accounts.where((a) => a.type == AccountType.cash.name).toList();

  List<AccountItem> get _bankAccounts => _accounts
      .where(
        (a) =>
            a.type == AccountType.bank.name ||
            a.type == AccountType.mobile.name,
      )
      .toList();

  void _setCash(double value) {
    if (value <= 0) {
      _cashController.clear();
    } else {
      final capped = value > _kMaxCashAmount ? _kMaxCashAmount : value;
      _cashController.text = capped.toStringAsFixed(0);
      _cashController.selection = TextSelection.collapsed(
        offset: _cashController.text.length,
      );
    }
    setState(() {});
  }

  void _addDenomination(int amount) {
    final current = double.tryParse(_cashController.text) ?? 0;
    _setCash(current + amount);
  }

  String _customerBalanceText(double balance) =>
      KhataBalanceRules.amountLabel(balance);

  Color _customerBalanceColor(double balance) =>
      KhataBalanceRules.colorFor(balance);

  bool _canComplete({
    required double cash,
    required double card,
    required double total,
  }) {
    final paid = switch (_method) {
      PaymentMethodKind.cash => cash,
      PaymentMethodKind.card => total,
      PaymentMethodKind.split => cash + card,
      PaymentMethodKind.khata => cash,
    };
    return (_method == PaymentMethodKind.khata || paid + 0.001 >= total) &&
        (_method != PaymentMethodKind.khata || _selectedCustomer != null) &&
        (_method != PaymentMethodKind.card ||
            _bankAccountId != null ||
            _bankAccounts.isEmpty) &&
        (_method != PaymentMethodKind.cash ||
            _cashAccountId != null ||
            _cashAccounts.isEmpty) &&
        (_method != PaymentMethodKind.khata ||
            paid <= 0 ||
            _cashAccountId != null ||
            _cashAccounts.isEmpty) &&
        (_method != PaymentMethodKind.split ||
            ((_bankAccountId != null || _bankAccounts.isEmpty) &&
                (_cashAccountId != null || _cashAccounts.isEmpty)));
  }

  void _submitPayment({required double cash, required double card}) {
    if (_submitting) return;
    if (_loadingShiftStatus) {
      AppToast.show(context, 'Checking cashier shift. Please try again.');
      return;
    }
    if (_shiftRequired && _activeShift == null) {
      AppToast.show(context, 'Open a shift before completing this sale.');
      return;
    }
    final total = widget.state.totals.total;
    if (!_canComplete(cash: cash, card: card, total: total)) return;

    setState(() => _submitting = true);
    context.read<PosBloc>().add(
      PosPaymentCompleted(
        method: _method,
        amountPaid: _method == PaymentMethodKind.card ? total : cash,
        cardAmount: _method == PaymentMethodKind.split ? card : 0,
        cashAccountId:
            _method == PaymentMethodKind.cash ||
                _method == PaymentMethodKind.split ||
                (_method == PaymentMethodKind.khata && cash > 0)
            ? _cashAccountId
            : null,
        bankAccountId:
            _method == PaymentMethodKind.card ||
                _method == PaymentMethodKind.split
            ? _bankAccountId
            : null,
      ),
    );
    Navigator.of(context).pop();
  }

  /// Enter: fill Exact cash when empty/short, then complete payment when ready.
  /// Works after a manual cash amount too (typed amount ≥ total → Pay).
  void _handleEnter() {
    if (_submitting) return;
    final total = widget.state.totals.total;
    var cash = double.tryParse(_cashController.text.trim()) ?? 0;
    final card = double.tryParse(_cardController.text.trim()) ?? 0;

    if (_method == PaymentMethodKind.cash && cash + 0.001 < total) {
      // First Enter fills Exact; a second Enter confirms payment.
      cash = total;
      _setCash(total);
      return;
    } else if (_method == PaymentMethodKind.split &&
        cash + card + 0.001 < total &&
        cash <= 0 &&
        card <= 0) {
      cash = total;
      _setCash(total);
      return;
    }

    if (_canComplete(cash: cash, card: card, total: total)) {
      _submitPayment(cash: cash, card: card);
    }
  }

  bool _onHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (!mounted) return false;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      // Catch Enter even while the cash/card TextField has focus.
      _handleEnter();
      return true;
    }
    return false;
  }

  KeyEventResult _onDialogKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _handleEnter();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final total = widget.state.totals.total;
    final cash = double.tryParse(_cashController.text) ?? 0;
    final card = double.tryParse(_cardController.text) ?? 0;
    final paid = switch (_method) {
      PaymentMethodKind.cash => cash,
      PaymentMethodKind.card => total,
      PaymentMethodKind.split => cash + card,
      PaymentMethodKind.khata => cash,
    };
    final change = (paid - total).clamp(0, double.infinity);
    final projectedKhata = (_selectedCustomer?.balance ?? 0) + total - cash;
    final canComplete = _canComplete(cash: cash, card: card, total: total);

    return Focus(
      focusNode: _dialogFocus,
      autofocus: true,
      onKeyEvent: _onDialogKey,
      child: Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520, maxHeight: 720),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Text('Pay', style: theme.textTheme.headlineSmall),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Symbols.close),
                      tooltip: 'Close (Esc)',
                    ),
                  ],
                ),
                Text(
                  CurrencyFormatter.format(total),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.displaySmall?.copyWith(
                    color: AppColors.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Enter cash · first empty Enter fills Exact · second Enter pays · Esc cancels',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (_shiftRequired && _activeShift == null) ...[
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sm),
                    decoration: BoxDecoration(
                      color: AppColors.warning.withValues(alpha: 0.12),
                      borderRadius: AppRadii.smAll,
                    ),
                    child: Row(
                      children: [
                        const Icon(Symbols.warning, color: AppColors.warning),
                        const SizedBox(width: AppSpacing.sm),
                        const Expanded(
                          child: Text(
                            'An open shift is required before payment.',
                          ),
                        ),
                        TextButton(
                          onPressed: _openShift,
                          child: const Text('Open shift'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                ],
                Center(
                  child: Wrap(
                    spacing: AppSpacing.sm,
                    runSpacing: AppSpacing.xs,
                    alignment: WrapAlignment.center,
                    children: [
                      _MethodChip(
                        label: 'Cash',
                        selected: _method == PaymentMethodKind.cash,
                        onTap: () => setState(() {
                          _method = PaymentMethodKind.cash;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) _cashFocus.requestFocus();
                          });
                        }),
                      ),
                      _MethodChip(
                        label: 'Card / Bank',
                        selected: _method == PaymentMethodKind.card,
                        onTap: () =>
                            setState(() => _method = PaymentMethodKind.card),
                      ),
                      _MethodChip(
                        label: 'Split',
                        selected: _method == PaymentMethodKind.split,
                        onTap: () => setState(() {
                          _method = PaymentMethodKind.split;
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) _cashFocus.requestFocus();
                          });
                        }),
                      ),
                      _MethodChip(
                        label: 'Khata / Udhar',
                        selected: _method == PaymentMethodKind.khata,
                        onTap: () {
                          setState(() => _method = PaymentMethodKind.khata);
                          _setCash(0);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            if (mounted) _cashFocus.requestFocus();
                          });
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Flexible(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (_method == PaymentMethodKind.khata) ...[
                          RawAutocomplete<PosCustomer>(
                            textEditingController: _customerController,
                            focusNode: _customerFocus,
                            displayStringForOption: (customer) => customer.name,
                            optionsBuilder: (value) {
                              final query = value.text.trim().toLowerCase();
                              if (query.isEmpty) return const [];
                              return _customers
                                  .where(
                                    (customer) =>
                                        customer.name.toLowerCase().contains(
                                          query,
                                        ) ||
                                        customer.phone.contains(query),
                                  )
                                  .take(6);
                            },
                            onSelected: _selectCustomer,
                            fieldViewBuilder:
                                (
                                  context,
                                  controller,
                                  focusNode,
                                  onFieldSubmitted,
                                ) {
                                  return TextField(
                                    controller: controller,
                                    focusNode: focusNode,
                                    onChanged: (text) {
                                      if (_selectedCustomer != null &&
                                          text != _selectedCustomer!.name) {
                                        setState(
                                          () => _selectedCustomer = null,
                                        );
                                      }
                                      context.read<PosBloc>().add(
                                        PosCustomerChanged(text),
                                      );
                                    },
                                    decoration: InputDecoration(
                                      labelText: 'Khata customer',
                                      hintText: 'Search name or phone',
                                      prefixIcon: const Icon(
                                        Symbols.person_search,
                                      ),
                                      suffixIcon: IconButton(
                                        tooltip: 'Add new customer',
                                        onPressed: _addCustomer,
                                        icon: const Icon(Symbols.person_add),
                                      ),
                                    ),
                                  );
                                },
                            optionsViewBuilder: (context, onSelected, options) {
                              return Align(
                                alignment: Alignment.topLeft,
                                child: Material(
                                  elevation: 8,
                                  borderRadius: AppRadii.smAll,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 440,
                                      maxHeight: 240,
                                    ),
                                    child: ListView(
                                      padding: EdgeInsets.zero,
                                      shrinkWrap: true,
                                      children: options
                                          .map(
                                            (customer) => ListTile(
                                              dense: true,
                                              leading: CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    _customerBalanceColor(
                                                      customer.balance,
                                                    ).withValues(alpha: 0.14),
                                                child: Icon(
                                                  switch (KhataBalanceRules.direction(
                                                    customer.balance,
                                                  )) {
                                                    KhataDirection.take =>
                                                      Symbols.call_received,
                                                    KhataDirection.give =>
                                                      Symbols.call_made,
                                                    KhataDirection.settled =>
                                                      Symbols.person,
                                                  },
                                                  size: 14,
                                                  color: _customerBalanceColor(
                                                    customer.balance,
                                                  ),
                                                ),
                                              ),
                                              title: Text(customer.name),
                                              subtitle: Text(customer.phone),
                                              trailing: Text(
                                                _customerBalanceText(
                                                  customer.balance,
                                                ),
                                                style: theme
                                                    .textTheme
                                                    .labelMedium
                                                    ?.copyWith(
                                                      color:
                                                          _customerBalanceColor(
                                                            customer.balance,
                                                          ),
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              onTap: () => onSelected(customer),
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: _selectedCustomer == null
                                  ? AppColors.textSecondary.withValues(
                                      alpha: 0.08,
                                    )
                                  : _customerBalanceColor(
                                      projectedKhata,
                                    ).withValues(alpha: 0.10),
                              borderRadius: AppRadii.smAll,
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  Symbols.menu_book,
                                  size: 22,
                                  color: _selectedCustomer == null
                                      ? AppColors.textSecondary
                                      : _customerBalanceColor(projectedKhata),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                Expanded(
                                  child: Text(
                                    _selectedCustomer == null
                                        ? 'Search a customer above or add a new one.'
                                        : '${_selectedCustomer!.name} · After payment: '
                                              '${_customerBalanceText(projectedKhata)}.',
                                    style: TextStyle(
                                      color: _selectedCustomer == null
                                          ? null
                                          : _customerBalanceColor(
                                              projectedKhata,
                                            ),
                                      fontWeight: _selectedCustomer == null
                                          ? null
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        if (_method != PaymentMethodKind.card) ...[
                          const SizedBox(height: AppSpacing.sm),
                          TextField(
                            controller: _cashController,
                            focusNode: _cashFocus,
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.headlineSmall,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                FieldLimits.priceDigits,
                              ),
                            ],
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (_) => _handleEnter(),
                            decoration: InputDecoration(
                              labelText: _method == PaymentMethodKind.khata
                                  ? 'Customer pays now'
                                  : 'Cash received',
                              hintText: 'Enter amount',
                              prefixText: 'Rs ',
                              alignLabelWithHint: true,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            alignment: WrapAlignment.center,
                            children: [
                              ActionChip(
                                label: Text(
                                  _method == PaymentMethodKind.khata
                                      ? 'Paid full'
                                      : 'Exact',
                                ),
                                avatar: const Icon(Symbols.check, size: 16),
                                onPressed: () => _setCash(total),
                              ),
                              ActionChip(
                                label: Text(
                                  _method == PaymentMethodKind.khata
                                      ? 'Full Khata'
                                      : 'Clear',
                                ),
                                avatar: const Icon(Symbols.backspace, size: 16),
                                onPressed: () => _setCash(0),
                              ),
                              ..._kCashDenominations.map(
                                (amount) => ActionChip(
                                  label: Text('+$amount'),
                                  onPressed: () => _addDenomination(amount),
                                ),
                              ),
                            ],
                          ),
                          if (_cashAccounts.isNotEmpty) ...[
                            const SizedBox(height: AppSpacing.md),
                            Text(
                              'Deposit to cash account',
                              style: theme.textTheme.titleSmall,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            ..._cashAccounts.map(
                              (account) => ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  _cashAccountId == account.id
                                      ? Symbols.radio_button_checked
                                      : Symbols.radio_button_unchecked,
                                  color: AppColors.accent,
                                ),
                                title: Text(account.name),
                                subtitle: Text(
                                  'Balance ${CurrencyFormatter.format(account.balance)}',
                                ),
                                onTap: () =>
                                    setState(() => _cashAccountId = account.id),
                              ),
                            ),
                          ],
                        ],
                        if (_method == PaymentMethodKind.split) ...[
                          const SizedBox(height: AppSpacing.md),
                          TextField(
                            controller: _cardController,
                            focusNode: _cardFocus,
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly,
                              LengthLimitingTextInputFormatter(
                                FieldLimits.priceDigits,
                              ),
                            ],
                            onChanged: (_) => setState(() {}),
                            onSubmitted: (_) => _handleEnter(),
                            decoration: const InputDecoration(
                              labelText: 'Card / bank amount',
                              hintText: 'Enter amount',
                              prefixText: 'Rs ',
                            ),
                          ),
                        ],
                        if (_method != PaymentMethodKind.cash &&
                            _method != PaymentMethodKind.khata) ...[
                          const SizedBox(height: AppSpacing.md),
                          Text(
                            'Bank / wallet account',
                            style: theme.textTheme.titleSmall,
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          if (_loadingAccounts)
                            const Padding(
                              padding: EdgeInsets.all(AppSpacing.md),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          else if (_bankAccounts.isEmpty)
                            Text(
                              'No bank or mobile accounts yet. Add one in Accounts, then return here.',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.warning,
                              ),
                            )
                          else
                            ..._bankAccounts.map(
                              (account) => ListTile(
                                dense: true,
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  _bankAccountId == account.id
                                      ? Symbols.radio_button_checked
                                      : Symbols.radio_button_unchecked,
                                  color: AppColors.accent,
                                ),
                                title: Text(
                                  '${account.name} · ${account.type == AccountType.mobile.name ? 'Mobile' : 'Bank'}',
                                ),
                                subtitle: Text(
                                  'Balance ${CurrencyFormatter.format(account.balance)}',
                                ),
                                onTap: () =>
                                    setState(() => _bankAccountId = account.id),
                              ),
                            ),
                        ],
                        const SizedBox(height: AppSpacing.md),
                        if (_method == PaymentMethodKind.khata)
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: _customerBalanceColor(
                                projectedKhata,
                              ).withValues(alpha: 0.10),
                              borderRadius: AppRadii.smAll,
                            ),
                            child: Column(
                              children: [
                                _PaymentSummaryRow(
                                  label: 'Paid now',
                                  amount: cash,
                                ),
                                const SizedBox(height: AppSpacing.xs),
                                _PaymentSummaryRow(
                                  label: KhataBalanceRules.statusLabelFor(
                                    projectedKhata,
                                  ),
                                  amount: projectedKhata.abs(),
                                  emphasized: true,
                                  accentColor: _customerBalanceColor(
                                    projectedKhata,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          Container(
                            padding: const EdgeInsets.all(AppSpacing.md),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.08),
                              borderRadius: AppRadii.smAll,
                            ),
                            child: Row(
                              children: [
                                Text(
                                  'Change',
                                  style: theme.textTheme.titleMedium,
                                ),
                                const Spacer(),
                                Text(
                                  CurrencyFormatter.format(change),
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.accent,
                                      ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                AppButton(
                  label: _submitting
                      ? 'Saving…'
                      : _method == PaymentMethodKind.khata
                      ? cash + 0.001 >= total
                            ? 'Complete Payment'
                            : cash <= 0
                            ? 'Add Full Bill to Khata'
                            : 'Pay & Add Remainder to Khata'
                      : 'Pay',
                  icon: Symbols.payments,
                  expanded: true,
                  height: 64,
                  iconSize: 22,
                  labelStyle: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                  isLoading: _submitting,
                  onPressed: !canComplete || _submitting
                      ? null
                      : () => _submitPayment(cash: cash, card: card),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PaymentSummaryRow extends StatelessWidget {
  const _PaymentSummaryRow({
    required this.label,
    required this.amount,
    this.emphasized = false,
    this.accentColor,
  });

  final String label;
  final double amount;
  final bool emphasized;
  final Color? accentColor;

  @override
  Widget build(BuildContext context) {
    final color = emphasized ? accentColor : null;
    final style = Theme.of(context).textTheme.titleMedium?.copyWith(
      color: color,
      fontWeight: emphasized ? FontWeight.w800 : FontWeight.w600,
    );
    return Row(
      children: [
        Text(label, style: style),
        const Spacer(),
        Text(CurrencyFormatter.format(amount), style: style),
      ],
    );
  }
}

class _MethodChip extends StatelessWidget {
  const _MethodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    );
  }
}
