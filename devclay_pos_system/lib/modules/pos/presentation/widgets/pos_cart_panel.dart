import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../core/auth/permissions.dart';
import '../../../../core/di/injection.dart';
import '../../../../routes/app_router.dart';
import '../../../../services/retail/retail_control_service.dart';
import '../../../../themes/app_durations.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_shadows.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/measure_units.dart';
import '../../../../utils/khata_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/field_limits.dart';
import '../../../../widgets/product_image.dart';
import '../bloc/pos_bloc.dart';
import '../../domain/entities/pos_entities.dart';
import 'pos_held_sales_sheet.dart';
import 'pos_shift_sheet.dart';
import 'pos_item_colors.dart';
import 'manager_approval_dialog.dart';

class PosCartPanel extends StatefulWidget {
  const PosCartPanel({
    super.key,
    required this.state,
    required this.metaExpanded,
    required this.onMetaExpandedChanged,
    required this.customerController,
    required this.notesController,
    required this.discountController,
    required this.customerFocus,
    required this.notesFocus,
    required this.discountFocus,
    required this.onFieldEditingComplete,
    required this.onAddCustomer,
  });

  final PosReady state;
  final bool metaExpanded;
  final ValueChanged<bool> onMetaExpandedChanged;
  final TextEditingController customerController;
  final TextEditingController notesController;
  final TextEditingController discountController;
  final FocusNode customerFocus;
  final FocusNode notesFocus;
  final FocusNode discountFocus;
  final VoidCallback onFieldEditingComplete;
  final VoidCallback onAddCustomer;

  @override
  State<PosCartPanel> createState() => _PosCartPanelState();
}

class _PosCartPanelState extends State<PosCartPanel> {
  final _scrollController = ScrollController();
  bool _discountApproved = false;

  @override
  void didUpdateWidget(covariant PosCartPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    final next = widget.state.lines;
    final prev = oldWidget.state.lines;
    if (next.isEmpty) {
      if (prev.isNotEmpty && _discountApproved) {
        setState(() => _discountApproved = false);
      }
      return;
    }

    int? targetIndex;
    if (next.length > prev.length) {
      targetIndex = next.length - 1;
    } else if (next.length == prev.length) {
      for (var i = 0; i < next.length; i++) {
        if (next[i].product.id == prev[i].product.id &&
            next[i].quantity > prev[i].quantity) {
          targetIndex = i;
          break;
        }
      }
    }

    if (targetIndex == null) return;
    final index = targetIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToCartLine(index);
    });
  }

  void _scrollToCartLine(int index) {
    final lines = widget.state.lines;
    if (index < 0 || index >= lines.length) return;

    final ctx = GlobalObjectKey(_cartLineKey(lines[index])).currentContext;
    if (ctx != null) {
      Scrollable.ensureVisible(
        ctx,
        duration: AppDurations.fast,
        curve: Curves.easeOutCubic,
        alignment: 0.9,
      );
      return;
    }

    if (!_scrollController.hasClients) return;
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: AppDurations.fast,
      curve: Curves.easeOutCubic,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.state;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final totals = state.totals;
    final hasMeta =
        (state.customerName?.trim().isNotEmpty ?? false) ||
        (state.notes?.trim().isNotEmpty ?? false) ||
        state.cartDiscount > 0;

    final panelBg = isDark ? AppColors.darkCard : Colors.white;
    final lineBorder = isDark ? AppColors.darkBorder : const Color(0xFFE2E8F0);

    return Container(
      decoration: BoxDecoration(
        borderRadius: AppRadii.lgAll,
        boxShadow: AppShadows.md(theme.brightness),
      ),
      child: Material(
        color: panelBg,
        borderRadius: AppRadii.lgAll,
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.sm,
                AppSpacing.md,
              ),
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFF1A2740), Color(0xFF152033)],
                      )
                    : const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFEFF4FF), Color(0xFFE8F0FE)],
                      ),
                border: Border(bottom: BorderSide(color: lineBorder)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: AppRadii.smAll,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.28),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Symbols.shopping_bag,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Current sale',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          totals.itemCount == 0
                              ? 'Ready for the next customer'
                              : '${totals.itemCount} item${totals.itemCount == 1 ? '' : 's'} in cart',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Badge(
                      isLabelVisible: state.heldSales.isNotEmpty,
                      label: Text('${state.heldSales.length}'),
                      child: AppIconButton(
                        icon: Symbols.history,
                        tooltip: 'Held bills — resume paused sales',
                        onPressed: () => showHeldSalesSheet(context),
                      ),
                    ),
                  TextButton.icon(
                    icon: const Icon(Symbols.point_of_sale, size: 18),
                    label: const Text('Shift / tally'),
                    onPressed: () => showPosShiftSheet(context),
                  ),
                  FilterChip(
                    label: Text(
                      state.wholesaleMode ? 'Wholesale' : 'Retail',
                    ),
                    selected: state.wholesaleMode,
                    onSelected: (value) => context.read<PosBloc>().add(
                      PosWholesaleModeToggled(value),
                    ),
                    avatar: Icon(
                      state.wholesaleMode
                          ? Symbols.storefront
                          : Symbols.sell,
                      size: 18,
                    ),
                  ),
                  Badge(
                    isLabelVisible: hasMeta && !widget.metaExpanded,
                    smallSize: 8,
                    child: AppIconButton(
                      icon: Symbols.person,
                      tooltip: widget.metaExpanded
                          ? 'Hide customer details'
                          : 'Customer, notes & discount',
                      selected: widget.metaExpanded || hasMeta,
                      onPressed: () =>
                          widget.onMetaExpandedChanged(!widget.metaExpanded),
                    ),
                  ),
                  AppIconButton(
                    icon: Symbols.delete_sweep,
                    tooltip: 'Clear cart',
                    onPressed: _confirmClearCart,
                  ),
                ],
              ),
            ),
            Expanded(
              child: ColoredBox(
                color: isDark
                    ? const Color(0xFF101824)
                    : const Color(0xFFF7F9FC),
                child: state.lines.isEmpty
                    ? _EmptyCart(theme: theme, isDark: isDark)
                    : ListView.separated(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(AppSpacing.sm),
                        itemCount: state.lines.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.xs),
                        itemBuilder: (context, index) {
                          final line = state.lines[index];
                          return KeyedSubtree(
                            key: GlobalObjectKey(_cartLineKey(line)),
                            child: _CartLineTile(
                              index: index,
                              product: line.product,
                              quantity: line.quantity,
                              originalSubtotal: line.originalSubtotal,
                              discountAmount: line.discountAmount,
                              subtotalBeforeTax: line.subtotalBeforeTax,
                              maxDiscountAmount: line.maxDiscountAmount,
                              minSubtotalBeforeTax: line.minSubtotalBeforeTax,
                              lineDiscount: line.effectiveLineDiscount,
                              lineDiscountMode: line.lineDiscountMode,
                              quantityLabel: line.displayQuantityText,
                              isVariableSale: line.isVariableSale,
                              selectedBatch: line.selectedBatch,
                            ),
                          );
                        },
                      ),
              ),
            ),
            AnimatedSize(
              duration: AppDurations.fast,
              curve: Curves.easeOutCubic,
              alignment: Alignment.topCenter,
              child: widget.metaExpanded
                  ? _CartMetaStrip(
                      isDark: isDark,
                      theme: theme,
                      lineBorder: lineBorder,
                      discountMode: state.cartDiscountMode,
                      customerController: widget.customerController,
                      notesController: widget.notesController,
                      discountController: widget.discountController,
                      customerFocus: widget.customerFocus,
                      notesFocus: widget.notesFocus,
                      discountFocus: widget.discountFocus,
                      onFieldEditingComplete: widget.onFieldEditingComplete,
                      onAddCustomer: widget.onAddCustomer,
                      discountEnabled:
                          _discountApproved ||
                          contextHasPermission(
                            context,
                            AppPermission.discountsApprove,
                          ),
                      onRequestDiscountApproval: _requestDiscountApproval,
                      onClose: () => widget.onMetaExpandedChanged(false),
                    )
                  : const SizedBox.shrink(),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                gradient: isDark
                    ? const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFF152033), Color(0xFF121A2A)],
                      )
                    : const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Color(0xFFF8FAFF), Color(0xFFEEF3FB)],
                      ),
                border: Border(top: BorderSide(color: lineBorder)),
              ),
              child: Column(
                children: [
                  _TotalRow(label: 'Subtotal', value: totals.subtotal),
                  if (totals.tax > 0)
                    _TotalRow(label: 'Tax', value: totals.tax),
                  if (totals.discount > 0)
                    _TotalRow(
                      label: state.cartDiscount > 0
                          ? 'Discount (${_discountSummaryLabel(state.cartDiscount, state.cartDiscountMode)})'
                          : 'Discount',
                      value: totals.discount,
                      emphasize: true,
                    ),
                  const SizedBox(height: AppSpacing.sm),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    decoration: BoxDecoration(
                      gradient: AppColors.accentGradient,
                      borderRadius: AppRadii.smAll,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(alpha: 0.3),
                          blurRadius: 14,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Total due',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Spacer(),
                        Text(
                          CurrencyFormatter.format(totals.total),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Tooltip(
                          message: 'Pay (Enter)',
                          child: AppButton(
                            label: 'Pay',
                            expanded: true,
                            height: 64,
                            icon: Symbols.payments,
                            iconSize: 22,
                            labelStyle: theme.textTheme.titleMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                            onPressed: state.lines.isEmpty
                                ? null
                                : () => context.read<PosBloc>().add(
                                    const PosCheckoutRequested(),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        flex: 2,
                        child: Tooltip(
                          message: 'Hold bill',
                          child: AppButton(
                            label: 'Hold',
                            expanded: true,
                            height: 64,
                            variant: AppButtonVariant.secondary,
                            icon: Symbols.pause_circle,
                            onPressed: state.lines.isEmpty
                                ? null
                                : () => context.read<PosBloc>().add(
                                    const PosHoldRequested(),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _requestDiscountApproval() async {
    final supervisor = await requestManagerApproval(
      context,
      action: 'Approve a discount for the current sale.',
    );
    if (supervisor == null || !mounted) return;
    await sl<RetailControlService>().recordApproval(
      supervisor: supervisor,
      action: 'discount.approved',
      details: 'Discount access approved for the current POS cart',
    );
    if (mounted) setState(() => _discountApproved = true);
  }

  Future<void> _confirmClearCart() async {
    if (widget.state.lines.isEmpty) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Clear current cart?'),
        content: const Text(
          'All items, customer details, notes, and discounts will be removed. '
          'Use Hold if the customer may return.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Keep cart'),
          ),
          FilledButton.tonalIcon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            icon: const Icon(Symbols.delete_sweep),
            label: const Text('Clear cart'),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      context.read<PosBloc>().add(const PosClearCart());
      setState(() => _discountApproved = false);
    }
  }
}

class _CartMetaStrip extends StatelessWidget {
  const _CartMetaStrip({
    required this.isDark,
    required this.theme,
    required this.lineBorder,
    required this.discountMode,
    required this.customerController,
    required this.notesController,
    required this.discountController,
    required this.customerFocus,
    required this.notesFocus,
    required this.discountFocus,
    required this.onFieldEditingComplete,
    required this.onAddCustomer,
    required this.discountEnabled,
    required this.onRequestDiscountApproval,
    required this.onClose,
  });

  final bool isDark;
  final ThemeData theme;
  final Color lineBorder;
  final CartDiscountMode discountMode;
  final TextEditingController customerController;
  final TextEditingController notesController;
  final TextEditingController discountController;
  final FocusNode customerFocus;
  final FocusNode notesFocus;
  final FocusNode discountFocus;
  final VoidCallback onFieldEditingComplete;
  final VoidCallback onAddCustomer;
  final bool discountEnabled;
  final VoidCallback onRequestDiscountApproval;
  final VoidCallback onClose;

  PosCustomer? _selectedCustomer(BuildContext context) {
    final state = context.read<PosBloc>().state;
    if (state is! PosReady || state.selectedCustomerId == null) return null;
    for (final customer in state.customers) {
      if (customer.id == state.selectedCustomerId) return customer;
    }
    return null;
  }

  List<PosCustomer> _matches(BuildContext context, String text) {
    final query = text.trim().toLowerCase();
    if (query.isEmpty) return const [];
    // Once the field already holds the chosen customer there is nothing left
    // to pick, so the list stays closed instead of covering the cart.
    final selected = _selectedCustomer(context);
    if (selected != null && selected.name.toLowerCase() == query) {
      return const [];
    }
    final state = context.read<PosBloc>().state;
    if (state is! PosReady) return const [];
    return state.customers
        .where(
          (customer) =>
              customer.name.toLowerCase().contains(query) ||
              customer.phone.contains(query),
        )
        .take(6)
        .toList();
  }

  /// Applies the tap even when the autocomplete considers this option already
  /// selected, then drops focus so the options list always closes.
  void _pickCustomer(
    BuildContext context,
    void Function(PosCustomer) onSelected,
    PosCustomer customer,
  ) {
    onSelected(customer);
    if (customerController.text != customer.name) {
      customerController.value = TextEditingValue(
        text: customer.name,
        selection: TextSelection.collapsed(offset: customer.name.length),
      );
      context.read<PosBloc>().add(PosCustomerSelected(customer));
    }
    customerFocus.unfocus();
    // Hand the keyboard back to the scanner once a customer is locked in.
    onFieldEditingComplete();
  }

  @override
  Widget build(BuildContext context) {
    final decoration = InputDecoration(
      isDense: true,
      filled: true,
      fillColor: isDark ? AppColors.darkSurfaceMuted : const Color(0xFFF3F6FA),
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.sm,
        AppSpacing.sm,
        AppSpacing.xs,
        AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF101824) : const Color(0xFFF7F9FC),
        border: Border(
          top: BorderSide(color: lineBorder),
          bottom: BorderSide(color: lineBorder),
        ),
      ),
      child: Column(
        children: [
          RawAutocomplete<PosCustomer>(
            textEditingController: customerController,
            focusNode: customerFocus,
            displayStringForOption: (customer) => customer.name,
            optionsBuilder: (value) => _matches(context, value.text),
            onSelected: (customer) =>
                context.read<PosBloc>().add(PosCustomerSelected(customer)),
            fieldViewBuilder:
                (context, controller, focusNode, onFieldSubmitted) {
                  return SizedBox(
                    height: 38,
                    child: TextField(
                      controller: controller,
                      focusNode: focusNode,
                      style: theme.textTheme.bodySmall,
                      decoration: decoration.copyWith(
                        hintText: 'Search customer by name or phone',
                        prefixIcon: const Icon(Symbols.person_search, size: 16),
                        suffixIcon: IconButton(
                          tooltip: 'Add new customer',
                          onPressed: onAddCustomer,
                          icon: const Icon(Symbols.person_add, size: 17),
                        ),
                      ),
                      onChanged: (value) => context.read<PosBloc>().add(
                        PosCustomerChanged(value),
                      ),
                      onEditingComplete: onFieldEditingComplete,
                    ),
                  );
                },
            optionsViewBuilder: (context, onSelected, options) {
              return Align(
                alignment: Alignment.topLeft,
                child: ValueListenableBuilder<TextEditingValue>(
                  valueListenable: customerController,
                  builder: (context, value, _) {
                    // Re-filter against the live text so a stale list is never
                    // left hanging over the cart.
                    final visible = _matches(context, value.text);
                    if (visible.isEmpty) return const SizedBox.shrink();
                    return Material(
                      elevation: 8,
                      borderRadius: AppRadii.smAll,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 360,
                          maxHeight: 240,
                        ),
                        child: ListView(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          children: visible
                              .map(
                                (customer) => ListTile(
                                  dense: true,
                                  leading: CircleAvatar(
                                    radius: 14,
                                    backgroundColor: KhataBalanceRules.colorFor(
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
                                      color: KhataBalanceRules.colorFor(
                                        customer.balance,
                                      ),
                                    ),
                                  ),
                                  title: Text(customer.name),
                                  subtitle: Text(customer.phone),
                                  trailing: Text(
                                    KhataBalanceRules.amountLabel(
                                      customer.balance,
                                    ),
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: KhataBalanceRules.colorFor(
                                            customer.balance,
                                          ),
                                          fontWeight: FontWeight.w700,
                                        ),
                                  ),
                                  onTap: () => _pickCustomer(
                                    context,
                                    onSelected,
                                    customer,
                                  ),
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          Builder(
            builder: (context) {
              final selected = _selectedCustomer(context);
              if (selected == null ||
                  !KhataBalanceRules.hasBalance(selected.balance)) {
                return const SizedBox.shrink();
              }
              final color = KhataBalanceRules.colorFor(selected.balance);
              return Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${selected.name} · ${KhataBalanceRules.amountLabel(selected.balance)}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: color,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 34,
            child: TextField(
              controller: notesController,
              focusNode: notesFocus,
              style: theme.textTheme.bodySmall,
              decoration: decoration.copyWith(
                hintText: 'Notes',
                prefixIcon: const Icon(Symbols.notes, size: 16),
              ),
              onChanged: (value) =>
                  context.read<PosBloc>().add(PosNotesChanged(value)),
              onEditingComplete: onFieldEditingComplete,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: discountEnabled
                    ? SizedBox(
                        height: 34,
                        child: TextField(
                          controller: discountController,
                          focusNode: discountFocus,
                          style: theme.textTheme.bodySmall,
                          decoration: decoration.copyWith(
                            hintText: discountMode == CartDiscountMode.percent
                                ? 'Discount %'
                                : 'Discount amount',
                            suffixText: discountMode == CartDiscountMode.percent
                                ? '%'
                                : null,
                            prefixText: discountMode == CartDiscountMode.fixed
                                ? 'Rs '
                                : null,
                            prefixIcon: _DiscountModeIcon(
                              mode: discountMode,
                              onToggle: () {
                                final next =
                                    discountMode == CartDiscountMode.percent
                                    ? CartDiscountMode.fixed
                                    : CartDiscountMode.percent;
                                context.read<PosBloc>().add(
                                  PosCartDiscountModeChanged(next),
                                );
                              },
                            ),
                          ),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          inputFormatters:
                              discountMode == CartDiscountMode.percent
                              ? FieldLimits.taxPercent
                              : FieldLimits.money,
                          onChanged: (value) {
                            final parsed = double.tryParse(value.trim()) ?? 0;
                            context.read<PosBloc>().add(
                              PosCartDiscountChanged(parsed),
                            );
                          },
                          onEditingComplete: onFieldEditingComplete,
                        ),
                      )
                    : OutlinedButton.icon(
                        onPressed: onRequestDiscountApproval,
                        icon: const Icon(Symbols.lock, size: 16),
                        label: const Text('Manager approval for discount'),
                      ),
              ),
              AppIconButton(
                icon: Symbols.close,
                tooltip: 'Hide customer details',
                onPressed: onClose,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _EmptyCart extends StatelessWidget {
  const _EmptyCart({required this.theme, required this.isDark});

  final ThemeData theme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.accent.withValues(alpha: isDark ? 0.16 : 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Symbols.add_shopping_cart,
                size: 32,
                color: AppColors.accent.withValues(alpha: 0.85),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Cart is empty',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              'Tap a product on the left to start a sale',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CartLineTile extends StatefulWidget {
  const _CartLineTile({
    required this.index,
    required this.product,
    required this.quantity,
    required this.originalSubtotal,
    required this.discountAmount,
    required this.subtotalBeforeTax,
    required this.maxDiscountAmount,
    required this.minSubtotalBeforeTax,
    required this.lineDiscount,
    required this.lineDiscountMode,
    required this.quantityLabel,
    this.isVariableSale = false,
    this.selectedBatch,
  });

  final int index;
  final PosProduct product;
  final int quantity;
  final double originalSubtotal;
  final double discountAmount;
  final double subtotalBeforeTax;
  final double maxDiscountAmount;
  final double minSubtotalBeforeTax;
  final double lineDiscount;
  final LineDiscountMode lineDiscountMode;
  final String quantityLabel;
  final bool isVariableSale;
  final PosBatchLot? selectedBatch;

  @override
  State<_CartLineTile> createState() => _CartLineTileState();
}

class _CartLineTileState extends State<_CartLineTile> {
  late final TextEditingController _discountController;
  late final TextEditingController _qtyController;
  late final FocusNode _discountFocus;
  late final FocusNode _qtyFocus;
  bool _editingDiscount = false;
  bool _editingQty = false;

  @override
  void initState() {
    super.initState();
    _discountController = TextEditingController(
      text: _discountText(widget.lineDiscount),
    );
    _qtyController = TextEditingController(
      text: _qtyText(
        widget.isVariableSale
            ? MeasureUnits.fromBaseUnits(
                widget.quantity,
                widget.product.unit,
                widget.product.sellTypeEnum,
              )
            : widget.quantity.toDouble(),
      ),
    );
    _discountFocus = FocusNode(debugLabel: 'cart-discount-${widget.index}');
    _qtyFocus = FocusNode(debugLabel: 'cart-qty-${widget.index}');
    _discountFocus.addListener(_onDiscountFocusChanged);
    _qtyFocus.addListener(_onQtyFocusChanged);
  }

  double get displayQuantity => widget.isVariableSale
      ? MeasureUnits.fromBaseUnits(
          widget.quantity,
          widget.product.unit,
          widget.product.sellTypeEnum,
        )
      : widget.quantity.toDouble();

  @override
  void didUpdateWidget(covariant _CartLineTile oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_editingDiscount &&
        (oldWidget.lineDiscount != widget.lineDiscount ||
            oldWidget.lineDiscountMode != widget.lineDiscountMode)) {
      _discountController.text = _discountText(widget.lineDiscount);
    }
    if (!_editingQty && oldWidget.quantity != widget.quantity) {
      _qtyController.text = _qtyText(displayQuantity);
    }
  }

  @override
  void dispose() {
    _discountFocus.removeListener(_onDiscountFocusChanged);
    _qtyFocus.removeListener(_onQtyFocusChanged);
    _discountController.dispose();
    _qtyController.dispose();
    _discountFocus.dispose();
    _qtyFocus.dispose();
    super.dispose();
  }

  String _qtyText(double value) => MeasureUnits.formatDisplayInput(value);

  String _moneyText(double value) =>
      value.toStringAsFixed(value == value.roundToDouble() ? 0 : 2);

  String _discountText(double value) {
    if (widget.lineDiscountMode == LineDiscountMode.percent) {
      return value == value.roundToDouble()
          ? value.toInt().toString()
          : value.toStringAsFixed(1);
    }
    return _moneyText(value);
  }

  String get _pricingBreakdown {
    if (widget.discountAmount <= 0) {
      if (widget.maxDiscountAmount > 0) {
        return '${CurrencyFormatter.format(widget.originalSubtotal)} · '
            'Max disc ${CurrencyFormatter.format(widget.maxDiscountAmount)}';
      }
      return CurrencyFormatter.format(widget.originalSubtotal);
    }
    final atFloor =
        (widget.subtotalBeforeTax - widget.minSubtotalBeforeTax).abs() < 0.01;
    final discountLabel = widget.lineDiscountMode == LineDiscountMode.percent
        ? '-${_formatPercent(widget.lineDiscount)}'
        : '-${CurrencyFormatter.format(widget.discountAmount)}';
    final suffix = atFloor ? ' (cost floor)' : '';
    return '${CurrencyFormatter.format(widget.originalSubtotal)} → '
        '$discountLabel → '
        '${CurrencyFormatter.format(widget.subtotalBeforeTax)}$suffix';
  }

  void _onQtyFocusChanged() {
    if (_qtyFocus.hasFocus) {
      if (!_editingQty) setState(() => _editingQty = true);
      return;
    }
    if (!_editingQty || !widget.isVariableSale) return;
    final value = MeasureUnits.parseDecimalInput(_qtyController.text);
    if (value == null || value <= 0) {
      _qtyController.text = _qtyText(displayQuantity);
      setState(() => _editingQty = false);
      return;
    }
    context.read<PosBloc>().add(
      PosDisplayQuantityChanged(index: widget.index, displayQuantity: value),
    );
    setState(() => _editingQty = false);
  }

  void _commitQtyInput() {
    if (!widget.isVariableSale) return;
    final value = MeasureUnits.parseDecimalInput(_qtyController.text);
    if (value == null || value <= 0) {
      _qtyController.text = _qtyText(displayQuantity);
      return;
    }
    context.read<PosBloc>().add(
      PosDisplayQuantityChanged(index: widget.index, displayQuantity: value),
    );
    _qtyFocus.unfocus();
  }

  void _onDiscountFocusChanged() {
    if (_discountFocus.hasFocus) {
      if (!_editingDiscount) setState(() => _editingDiscount = true);
      return;
    }
    if (!_editingDiscount) return;
    final raw = _discountController.text.trim();
    if (raw.isEmpty) {
      _commitDiscount(finishEditing: true);
      return;
    }
    if (double.tryParse(raw.replaceAll(',', '.')) == null) {
      _revertDiscount();
      return;
    }
    _commitDiscount(finishEditing: true);
  }

  void _commitDiscount({bool finishEditing = false}) {
    final raw = _discountController.text.trim();
    final value = double.tryParse(raw.replaceAll(',', '.')) ?? 0;
    context.read<PosBloc>().add(
      PosLineDiscountChanged(index: widget.index, value: value),
    );
    if (!mounted) return;
    setState(() => _editingDiscount = !finishEditing);
  }

  void _revertDiscount() {
    if (!mounted) return;
    setState(() {
      _editingDiscount = false;
      _discountController.text = _discountText(widget.lineDiscount);
    });
    _discountFocus.unfocus();
  }

  OutlineInputBorder _pillBorder(BorderSide side) => OutlineInputBorder(
    borderRadius: BorderRadius.circular(999),
    borderSide: side,
  );

  InputDecoration _compactFieldDecoration({
    required ThemeData theme,
    required Color accent,
    String? prefixText,
    String? suffixText,
    Widget? prefixIcon,
  }) {
    return InputDecoration(
      isDense: true,
      filled: true,
      fillColor: theme.brightness == Brightness.dark
          ? AppColors.darkSurfaceMuted
          : Colors.white,
      prefixText: prefixText,
      suffixText: suffixText,
      prefixIcon: prefixIcon,
      prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      border: _pillBorder(BorderSide.none),
      enabledBorder: _pillBorder(
        BorderSide(color: accent.withValues(alpha: 0.35)),
      ),
      focusedBorder: _pillBorder(BorderSide(color: accent, width: 1.6)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final visual = PosProductVisual.forProduct(context, widget.product);
    final accent = visual.accent;
    final softFill = visual.fill;
    final softBorder = visual.border;

    return Material(
      color: softFill,
      borderRadius: AppRadii.smAll,
      elevation: 0,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          borderRadius: AppRadii.smAll,
          border: Border.all(
            color: softBorder,
            width: visual.isAlert ? 1.4 : 1,
          ),
          boxShadow: AppShadows.sm(theme.brightness),
        ),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 44,
              decoration: BoxDecoration(
                color: visual.isAlert ? accent : AppColors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ProductImage(
              path: widget.product.imagePath,
              size: 44,
              borderRadius: AppRadii.xs,
            ),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (widget.selectedBatch != null)
                    Text(
                      'Batch ${widget.selectedBatch!.displayCode} · ${widget.selectedBatch!.quantity} available',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    )
                  else if (widget.product.batches.length > 1)
                    Text(
                      'Automatic batch · earliest expiry first',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                        fontSize: 9,
                      ),
                    ),
                  if (visual.badgeLabel != null) ...[
                    const SizedBox(height: 2),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        visual.badgeLabel!,
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 9,
                        ),
                      ),
                    ),
                  ],
                  Text(
                    widget.product.formattedRate,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Text(
                    _pricingBreakdown,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            widget.isVariableSale
                ? _DecimalQtyControl(
                    accent: accent,
                    controller: _qtyController,
                    focusNode: _qtyFocus,
                    onMinus: () => context.read<PosBloc>().add(
                      PosQuantityChanged(
                        index: widget.index,
                        quantity: widget.quantity - 1,
                      ),
                    ),
                    onPlus: () => context.read<PosBloc>().add(
                      PosQuantityChanged(
                        index: widget.index,
                        quantity: widget.quantity + 1,
                      ),
                    ),
                    onSubmitted: _commitQtyInput,
                  )
                : _QtyControl(
                    accent: accent,
                    quantity: widget.quantity,
                    onMinus: () => context.read<PosBloc>().add(
                      PosQuantityChanged(
                        index: widget.index,
                        quantity: widget.quantity - 1,
                      ),
                    ),
                    onPlus: () => context.read<PosBloc>().add(
                      PosQuantityChanged(
                        index: widget.index,
                        quantity: widget.quantity + 1,
                      ),
                    ),
                  ),
            if (widget.product.itemsPerBox > 1 && !widget.isVariableSale) ...[
              const SizedBox(width: AppSpacing.xs),
              Tooltip(
                message:
                    'Add one box (${widget.product.itemsPerBox} ${widget.product.unit ?? 'pcs'})',
                child: OutlinedButton(
                  onPressed: () => context.read<PosBloc>().add(
                    PosQuantityChanged(
                      index: widget.index,
                      quantity: widget.quantity + widget.product.itemsPerBox,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 34),
                    visualDensity: VisualDensity.compact,
                  ),
                  child: const Text('+ Box'),
                ),
              ),
            ],
            const SizedBox(width: AppSpacing.xs),
            SizedBox(
              width: 100,
              child: Tooltip(
                message: widget.maxDiscountAmount > 0
                    ? 'Max discount ${CurrencyFormatter.format(widget.maxDiscountAmount)} '
                          '(min charge ${CurrencyFormatter.format(widget.minSubtotalBeforeTax)})'
                    : 'No discount margin below purchase cost',
                child: TextField(
                  controller: _discountController,
                  focusNode: _discountFocus,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters:
                      widget.lineDiscountMode == LineDiscountMode.percent
                      ? FieldLimits.taxPercent
                      : FieldLimits.money,
                  textInputAction: TextInputAction.done,
                  style: theme.textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                  decoration: _compactFieldDecoration(
                    theme: theme,
                    accent: accent,
                    suffixText:
                        widget.lineDiscountMode == LineDiscountMode.percent
                        ? '%'
                        : null,
                    prefixText:
                        widget.lineDiscountMode == LineDiscountMode.fixed
                        ? 'Rs '
                        : null,
                    prefixIcon: _DiscountModeIcon(
                      mode: widget.lineDiscountMode,
                      onToggle: () {
                        final next =
                            widget.lineDiscountMode == LineDiscountMode.percent
                            ? LineDiscountMode.fixed
                            : LineDiscountMode.percent;
                        context.read<PosBloc>().add(
                          PosLineDiscountChanged(
                            index: widget.index,
                            value: 0,
                            mode: next,
                          ),
                        );
                      },
                    ),
                  ),
                  onSubmitted: (_) => _commitDiscount(),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Tooltip(
              message: 'Line total = catalog price × qty − discount',
              child: Container(
                // width: 92,
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: theme.brightness == Brightness.dark
                      ? AppColors.darkSurfaceMuted
                      : const Color(0xFFF3F6FB),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: accent.withValues(alpha: 0.28)),
                ),
                child: Text(
                  CurrencyFormatter.format(widget.subtotalBeforeTax),
                  textAlign: TextAlign.right,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: visual.isAlert
                        ? accent
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ),
            IconButton(
              tooltip: 'Remove item',
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () =>
                  context.read<PosBloc>().add(PosLineRemoved(widget.index)),
              icon: Icon(
                Symbols.delete_outline,
                size: 18,
                color: theme.colorScheme.error.withValues(alpha: 0.85),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DecimalQtyControl extends StatelessWidget {
  const _DecimalQtyControl({
    required this.accent,
    required this.controller,
    required this.focusNode,
    required this.onMinus,
    required this.onPlus,
    required this.onSubmitted,
  });

  final Color accent;
  final TextEditingController controller;
  final FocusNode focusNode;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  final VoidCallback onSubmitted;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(icon: Symbols.remove, color: accent, onPressed: onMinus),
          SizedBox(
            width: 60,
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
              ),
              inputFormatters: FieldLimits.decimalQty,
              textInputAction: TextInputAction.done,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: accent,
              ),
              decoration: const InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 8,
                ),
              ),
              onTap: () {
                controller.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: controller.text.length,
                );
              },
              onSubmitted: (_) => onSubmitted(),
            ),
          ),
          _QtyButton(icon: Symbols.add, color: accent, onPressed: onPlus),
        ],
      ),
    );
  }
}

class _QtyControl extends StatelessWidget {
  const _QtyControl({
    required this.accent,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  final Color accent;
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceMuted : Colors.white,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _QtyButton(icon: Symbols.remove, color: accent, onPressed: onMinus),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 6),
            child: Text(
              '$quantity',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: accent,
              ),
            ),
          ),
          _QtyButton(icon: Symbols.add, color: accent, onPressed: onPlus),
        ],
      ),
    );
  }
}

class _QtyButton extends StatelessWidget {
  const _QtyButton({
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 30,
          height: 30,
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final double value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final color = emphasize ? AppColors.warning : null;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color ?? Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ),
          const Spacer(),
          Text(
            CurrencyFormatter.format(value),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

/// Soft neutral accents — minimal, readable, low visual noise.
String _cartLineKey(CartLine line) =>
    'pos-cart-line-${line.product.id}-${line.selectedBatch?.id ?? 'auto'}';

String _formatPercent(double value) {
  if (value == value.roundToDouble()) {
    return '${value.toInt()}%';
  }
  return '${value.toStringAsFixed(1)}%';
}

String _discountSummaryLabel(double value, CartDiscountMode mode) {
  return switch (mode) {
    CartDiscountMode.percent => _formatPercent(value),
    CartDiscountMode.fixed => CurrencyFormatter.format(value),
  };
}

class _DiscountModeIcon extends StatelessWidget {
  const _DiscountModeIcon({required this.mode, required this.onToggle});

  final CartDiscountMode mode;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context) {
    final isPercent = mode == CartDiscountMode.percent;
    return Tooltip(
      message: isPercent
          ? 'Percentage discount — tap for fixed Rs'
          : 'Fixed Rs discount — tap for percentage',
      child: InkWell(
        onTap: onToggle,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Icon(isPercent ? Symbols.percent : Symbols.payments, size: 16),
        ),
      ),
    );
  }
}
