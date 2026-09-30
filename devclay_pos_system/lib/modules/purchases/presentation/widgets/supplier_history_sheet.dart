import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_colors.dart';
import '../../../../themes/app_radii.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../utils/supplier_balance.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/empty_state.dart';
import '../../domain/entities/purchase_entities.dart';

enum _HistoryFilter { all, due, paid }

Future<void> showSupplierHistorySheet({
  required BuildContext context,
  required SupplierItem supplier,
  required List<PurchaseRecord> purchases,
  required VoidCallback onPayDue,
  required ValueChanged<PurchaseRecord> onPurchaseTap,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => _SupplierHistoryDialog(
      supplier: supplier,
      purchases: purchases,
      onPayDue: onPayDue,
      onPurchaseTap: onPurchaseTap,
    ),
  );
}

class _SupplierHistoryDialog extends StatefulWidget {
  const _SupplierHistoryDialog({
    required this.supplier,
    required this.purchases,
    required this.onPayDue,
    required this.onPurchaseTap,
  });

  final SupplierItem supplier;
  final List<PurchaseRecord> purchases;
  final VoidCallback onPayDue;
  final ValueChanged<PurchaseRecord> onPurchaseTap;

  @override
  State<_SupplierHistoryDialog> createState() => _SupplierHistoryDialogState();
}

class _SupplierHistoryDialogState extends State<_SupplierHistoryDialog> {
  _HistoryFilter _filter = _HistoryFilter.all;

  List<PurchaseRecord> get _filtered {
    return switch (_filter) {
      _HistoryFilter.all => widget.purchases,
      _HistoryFilter.due =>
        widget.purchases.where((p) => p.dueAmount > 0.009).toList(),
      _HistoryFilter.paid =>
        widget.purchases.where((p) => p.dueAmount <= 0.009).toList(),
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final formatter = DateFormat('dd MMM yyyy');
    final total = widget.purchases.fold<double>(
      0,
      (sum, purchase) => sum + purchase.total,
    );
    final invoiceDue = widget.purchases.fold<double>(
      0,
      (sum, purchase) => sum + purchase.dueAmount,
    );
    final openingBalance = widget.supplier.balance;
    final netDue = invoiceDue + openingBalance;
    final filtered = _filtered;
    final media = MediaQuery.sizeOf(context);

    return Dialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 640,
          maxHeight: media.height * 0.85,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: AppColors.accent.withValues(alpha: 0.12),
                    child: Icon(Symbols.local_shipping, color: AppColors.accent),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.supplier.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        if (widget.supplier.phone.trim().isNotEmpty)
                          Text(
                            widget.supplier.phone,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 8,
                          runSpacing: 6,
                          children: [
                            _StatPill(
                              label: 'Purchases',
                              value: '${widget.purchases.length}',
                            ),
                            _StatPill(
                              label: 'Total',
                              value: CurrencyFormatter.format(total),
                            ),
                            _StatPill(
                              label: 'Net',
                              value: SupplierBalanceRules.netDueLabel(netDue),
                              highlight: netDue > 0.009,
                              highlightColor: KhataBalanceRules.colorForSupplier(
                                netDue,
                              ),
                            ),
                            if (SupplierBalanceRules.hasBalance(openingBalance))
                              _StatPill(
                                label: 'Opening',
                                value: SupplierBalanceRules.detailLabel(
                                  openingBalance,
                                ),
                                highlight: openingBalance > 0.009,
                                highlightColor: SupplierBalanceRules.colorFor(
                                  openingBalance,
                                ),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Symbols.close),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Wrap(
                spacing: 8,
                children: [
                  for (final option in _HistoryFilter.values)
                    FilterChip(
                      label: Text(switch (option) {
                        _HistoryFilter.all => 'All',
                        _HistoryFilter.due => 'To give',
                        _HistoryFilter.paid => 'Paid',
                      }),
                      selected: _filter == option,
                      onSelected: (_) => setState(() => _filter = option),
                    ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            const Divider(height: 1),
            Expanded(
              child: filtered.isEmpty
                  ? EmptyState(
                      title: 'No purchases',
                      message: switch (_filter) {
                        _HistoryFilter.due =>
                          'No open invoices to give for this supplier.',
                        _HistoryFilter.paid => 'No fully paid invoices yet.',
                        _HistoryFilter.all =>
                          'No purchase history recorded for this supplier.',
                      },
                      icon: Symbols.receipt_long,
                    )
                  : ListView.separated(
                      padding: const EdgeInsets.all(20),
                      itemCount: filtered.length,
                      separatorBuilder: (_, _) =>
                          const SizedBox(height: AppSpacing.sm),
                      itemBuilder: (context, index) {
                        final purchase = filtered[index];
                        final hasDue = purchase.dueAmount > 0.009;
                        return Material(
                          color: theme.colorScheme.surfaceContainerHighest
                              .withValues(alpha: 0.45),
                          borderRadius: AppRadii.smAll,
                          child: InkWell(
                            borderRadius: AppRadii.smAll,
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.onPurchaseTap(purchase);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(AppSpacing.md),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: hasDue
                                          ? KhataBalanceRules.giveColor
                                              .withValues(alpha: 0.15)
                                          : KhataBalanceRules.takeColor
                                              .withValues(alpha: 0.15),
                                      borderRadius: AppRadii.xsAll,
                                    ),
                                    child: Icon(
                                      hasDue
                                          ? Symbols.pending_actions
                                          : Symbols.check_circle,
                                      color: hasDue
                                          ? KhataBalanceRules.giveColor
                                          : KhataBalanceRules.settledColor,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          purchase.invoiceNo,
                                          style: theme.textTheme.titleSmall
                                              ?.copyWith(
                                                fontWeight: FontWeight.w700,
                                              ),
                                        ),
                                        Text(
                                          '${formatter.format(purchase.purchaseDate)} · '
                                          '${purchase.lines.length} product${purchase.lines.length == 1 ? '' : 's'}',
                                          style: theme.textTheme.labelSmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        CurrencyFormatter.format(purchase.total),
                                        style: theme.textTheme.titleSmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                            ),
                                      ),
                                      Text(
                                        hasDue
                                            ? KhataBalanceRules.payableLabel(
                                                purchase.dueAmount,
                                              )
                                            : 'Paid',
                                        style: theme.textTheme.labelMedium
                                            ?.copyWith(
                                              color: hasDue
                                                  ? KhataBalanceRules.giveColor
                                                  : KhataBalanceRules.settledColor,
                                              fontWeight: FontWeight.w700,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
            if (netDue > 0.009) ...[
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(20),
                child: AppButton(
                  label: 'Give ${CurrencyFormatter.format(netDue)}',
                  icon: Symbols.payments,
                  expanded: true,
                  onPressed: () {
                    Navigator.of(context).pop();
                    widget.onPayDue();
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    this.highlight = false,
    this.highlightColor,
  });

  final String label;
  final String value;
  final bool highlight;
  final Color? highlightColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = highlight
        ? (highlightColor ?? KhataBalanceRules.giveColor)
        : null;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color?.withValues(alpha: 0.12) ??
            theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: color?.withValues(alpha: 0.35) ??
              theme.dividerColor.withValues(alpha: 0.5),
        ),
      ),
      child: Text(
        '$label · $value',
        style: theme.textTheme.labelMedium?.copyWith(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
