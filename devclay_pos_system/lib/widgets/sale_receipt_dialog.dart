import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../constants/developer_contact.dart';
import '../modules/sales/domain/entities/sale_entities.dart';
import '../themes/app_colors.dart';
import '../themes/app_radii.dart';
import '../themes/app_spacing.dart';
import '../utils/currency_formatter.dart';
import 'app_button.dart';

Future<void> showSaleReceiptDialog(
  BuildContext context,
  SaleReceiptData receipt, {
  Future<void> Function()? onPrint,
  bool keyboardPrint = true,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => Dialog(
      shape: const RoundedRectangleBorder(borderRadius: AppRadii.lgAll),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: _SaleReceiptBody(
            receipt: receipt,
            onPrint: onPrint,
            keyboardPrint: keyboardPrint,
          ),
        ),
      ),
    ),
  );
}

class _SaleReceiptBody extends StatefulWidget {
  const _SaleReceiptBody({
    required this.receipt,
    this.onPrint,
    this.keyboardPrint = true,
  });

  final SaleReceiptData receipt;
  final Future<void> Function()? onPrint;
  final bool keyboardPrint;

  @override
  State<_SaleReceiptBody> createState() => _SaleReceiptBodyState();
}

class _SaleReceiptBodyState extends State<_SaleReceiptBody> {
  bool _printing = false;
  late final FocusNode _focus;

  @override
  void initState() {
    super.initState();
    _focus = FocusNode(debugLabel: 'sale-receipt');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focus.requestFocus();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    super.dispose();
  }

  Future<void> _handlePrint({bool closeAfter = false}) async {
    final onPrint = widget.onPrint;
    if (onPrint == null || _printing) return;
    setState(() => _printing = true);
    try {
      await onPrint();
      if (closeAfter && mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted && !closeAfter) setState(() => _printing = false);
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (!widget.keyboardPrint) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      Navigator.of(context).pop();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      if (widget.onPrint != null) {
        _handlePrint(closeAfter: true);
      } else {
        Navigator.of(context).pop();
      }
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final receipt = widget.receipt;
    final theme = Theme.of(context);
    final dateFormat = DateFormat('EEE, dd-MMM-yyyy h:mm a');
    final stampFormat = DateFormat('dd-MMM-yyyy HH:mm:ss');

    return Focus(
      focusNode: _focus,
      autofocus: true,
      onKeyEvent: _onKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (receipt.showSuccessIcon) ...[
            const Icon(
              Symbols.check_circle,
              color: AppColors.success,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          // Logo temporarily disabled (settings upload commented out).
          if (receipt.businessName != null &&
              receipt.businessName!.isNotEmpty) ...[
            Text(
              receipt.businessName!,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            if (receipt.businessAddress != null &&
                receipt.businessAddress!.isNotEmpty)
              Text(
                receipt.businessAddress!,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            if (receipt.taxNumber != null && receipt.taxNumber!.isNotEmpty)
              Text(
                'NTN ${receipt.taxNumber}',
                style: theme.textTheme.labelSmall,
                textAlign: TextAlign.center,
              ),
            if (receipt.businessPhone != null &&
                receipt.businessPhone!.isNotEmpty)
              Text(
                'Contact #: ${receipt.businessPhone}',
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            const SizedBox(height: AppSpacing.md),
          ],
          Text(receipt.title, style: theme.textTheme.headlineSmall),
          Text(receipt.invoiceNo, style: theme.textTheme.bodyMedium),
          const SizedBox(height: AppSpacing.sm),
          if (receipt.operatorName?.isNotEmpty == true)
            _ReceiptRow(label: 'Operator Name', value: receipt.operatorName!),
          _ReceiptRow(
            label: 'Invoice Date',
            value: dateFormat.format(receipt.soldAt),
          ),
          _ReceiptRow(
            label: 'Client Name',
            value: receipt.customerName?.isNotEmpty == true
                ? receipt.customerName!
                : 'Walk-in Customer',
          ),
          if (receipt.counterName?.isNotEmpty == true)
            _ReceiptRow(label: 'Counter', value: receipt.counterName!),
          if (receipt.systemName?.isNotEmpty == true)
            _ReceiptRow(label: 'System Name', value: receipt.systemName!),
          const SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(child: Text('Item', style: theme.textTheme.labelMedium)),
              SizedBox(
                width: 56,
                child: Text(
                  'Qty',
                  style: theme.textTheme.labelMedium,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                width: 80,
                child: Text(
                  'Amount',
                  style: theme.textTheme.labelMedium,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),

          const Divider(),
          ...receipt.lines.map(
            (line) => Padding(
              padding: const EdgeInsets.only(bottom: 8, top: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          line.productName,
                          style: theme.textTheme.bodyMedium,
                        ),
                        Text(
                          line.displayQuantityText,
                          style: theme.textTheme.labelSmall,
                        ),
                        Text(
                          CurrencyFormatter.format(line.unitPrice),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        if (line.lineDiscount > 0)
                          Text(
                            '- ${CurrencyFormatter.format(line.lineDiscount)} disc',
                            style: theme.textTheme.labelSmall?.copyWith(
                              color: theme.colorScheme.error,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        if (line.batchSummary != null)
                          Text(
                            line.batchSummary!,
                            style: theme.textTheme.labelSmall?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 56,
                    child: Text(
                      line.displayQuantityText,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium,
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: Text(
                      CurrencyFormatter.format(line.lineTotal),
                      textAlign: TextAlign.end,
                      style: theme.textTheme.titleSmall,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Divider(),
          const SizedBox(height: AppSpacing.xs),
          _ReceiptRow(label: 'Total Item', value: '${receipt.totalItems}'),
          _ReceiptRow(label: 'Total Qty', value: '${receipt.totalQty}'),
          _ReceiptRow(
            label: 'Gross Amount',
            value: CurrencyFormatter.format(receipt.grossAmount),
          ),
          if (receipt.discount > 0)
            _ReceiptRow(
              label: 'Discount',
              value: '- ${CurrencyFormatter.format(receipt.discount)}',
            ),
          if (receipt.tax > 0)
            _ReceiptRow(
              label: 'G.S.T',
              value: CurrencyFormatter.format(receipt.tax),
            ),
          if (receipt.fbrInvoiceEnabled) ...[
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Other Charges Detail',
                style: theme.textTheme.titleSmall,
              ),
            ),
            _ReceiptRow(
              label: 'FBR POS FEE',
              value: CurrencyFormatter.format(receipt.fbrPosFee),
            ),
            _ReceiptRow(
              label: 'Total Charges',
              value: CurrencyFormatter.format(receipt.fbrPosFee),
            ),
          ],
          const SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Text('Net Amount', style: theme.textTheme.titleLarge),
              const Spacer(),
              Text(
                CurrencyFormatter.format(receipt.netAmount),
                style: theme.textTheme.titleLarge?.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (receipt.fbrInvoiceEnabled) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'FBR Invoice # ${receipt.fbrInvoiceNo?.isNotEmpty == true ? receipt.fbrInvoiceNo! : 'Pending integration'}',
                style: theme.textTheme.bodySmall,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Verify this invoice through FBR TaxAsaan Mobile App or SMS at 9966.',
                style: theme.textTheme.labelSmall,
              ),
            ),
          ],
          const SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: Text('Payment Detail', style: theme.textTheme.titleSmall),
          ),
          _ReceiptRow(
            label: receipt.paymentMethod,
            value: CurrencyFormatter.format(receipt.amountPaid),
          ),
          _ReceiptRow(
            label: 'Total Amount',
            value: CurrencyFormatter.format(receipt.netAmount),
          ),
          if (receipt.changeAmount > 0)
            _ReceiptRow(
              label: 'Change',
              value: CurrencyFormatter.format(receipt.changeAmount),
            ),
          if (receipt.notes != null && receipt.notes!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(receipt.notes!, style: theme.textTheme.bodySmall),
            ),
          ],
          if (receipt.receiptTerms?.trim().isNotEmpty == true) ...[
            const SizedBox(height: AppSpacing.md),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Terms And Conditions',
                style: theme.textTheme.titleSmall,
              ),
            ),
            const SizedBox(height: AppSpacing.xs),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                receipt.receiptTerms!,
                style: theme.textTheme.bodySmall,
              ),
            ),
          ],
          if (receipt.receiptFooter != null &&
              receipt.receiptFooter!.isNotEmpty) ...[
            const SizedBox(height: AppSpacing.sm),
            Text(
              receipt.receiptFooter!,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
          const SizedBox(height: AppSpacing.md),
          const Divider(),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Data Entry Date: ${stampFormat.format(receipt.soldAt)}',
            style: theme.textTheme.labelSmall,
          ),
          Text(
            'Print Date: ${stampFormat.format(receipt.printedAt ?? DateTime.now())}',
            style: theme.textTheme.labelSmall,
          ),
          const _DeveloperReceiptFooter(),
          const SizedBox(height: AppSpacing.lg),
          if (widget.onPrint != null) ...[
            Text(
              'Enter = Print & close · Esc = Close',
              textAlign: TextAlign.center,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: _printing ? 'Printing…' : 'Print receipt (80 mm)',
              icon: Symbols.print,
              expanded: true,
              height: 56,
              iconSize: 22,
              onPressed: _printing ? null : () => _handlePrint(),
            ),
            const SizedBox(height: AppSpacing.sm),
          ],
          AppButton(
            label: receipt.showSuccessIcon ? 'Done' : 'Close',
            variant: widget.onPrint != null
                ? AppButtonVariant.secondary
                : AppButtonVariant.primary,
            expanded: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }
}

class _DeveloperReceiptFooter extends StatelessWidget {
  const _DeveloperReceiptFooter();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final labelStyle = theme.textTheme.labelSmall?.copyWith(
      color: theme.colorScheme.onSurface.withValues(alpha: 0.55),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.3,
    );
    final valueStyle = theme.textTheme.labelSmall;

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.sm),
      child: Column(
        children: [
          Text(
            'Software by ${DeveloperContact.developerName}',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(
                alpha: 0.45,
              ),
              borderRadius: AppRadii.smAll,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.2),
              ),
            ),
            child: Column(
              children: [
                _DeveloperContactRow(
                  icon: Symbols.call,
                  label: 'Phone',
                  value: DeveloperContact.mobile,
                  labelStyle: labelStyle,
                  valueStyle: valueStyle,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Divider(
                    height: 1,
                    color: theme.colorScheme.outline.withValues(alpha: 0.2),
                  ),
                ),
                _DeveloperContactRow(
                  icon: Symbols.mail,
                  label: 'Email',
                  value: DeveloperContact.email,
                  labelStyle: labelStyle,
                  valueStyle: valueStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _DeveloperContactRow extends StatelessWidget {
  const _DeveloperContactRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.labelStyle,
    required this.valueStyle,
  });

  final IconData icon;
  final String label;
  final String value;
  final TextStyle? labelStyle;
  final TextStyle? valueStyle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 14, color: AppColors.accent),
        const SizedBox(width: 8),
        SizedBox(width: 44, child: Text(label, style: labelStyle)),
        Expanded(
          child: Text(value, style: valueStyle, textAlign: TextAlign.end),
        ),
      ],
    );
  }
}

class _ReceiptRow extends StatelessWidget {
  const _ReceiptRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
