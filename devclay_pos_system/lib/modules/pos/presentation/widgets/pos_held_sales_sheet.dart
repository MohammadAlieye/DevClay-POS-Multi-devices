import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../modules/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../utils/currency_formatter.dart';
import '../../../../widgets/app_toast.dart';
import '../../domain/repositories/pos_repository.dart';
import '../bloc/pos_bloc.dart';

Future<void> showHeldSalesSheet(BuildContext context) {
  final parentContext = context;
  final bloc = context.read<PosBloc>();
  bloc.add(const PosHeldSalesRequested());
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    constraints: const BoxConstraints(maxWidth: 760, maxHeight: 620),
    builder: (sheetContext) {
      return BlocProvider.value(
        value: bloc,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: BlocBuilder<PosBloc, PosState>(
              builder: (context, state) {
                final heldSales = state is PosReady
                    ? state.heldSales
                    : const [];
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            Symbols.pause_circle,
                            color: AppColors.accent,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Held bills',
                                style: Theme.of(
                                  context,
                                ).textTheme.headlineSmall,
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Choose a bill to continue the sale.',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceMuted,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            '${heldSales.length} held',
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.xs),
                        IconButton(
                          tooltip: 'Close',
                          onPressed: () => Navigator.of(sheetContext).pop(),
                          icon: const Icon(Symbols.close),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    if (heldSales.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(AppSpacing.lg),
                        child: Column(
                          children: [
                            Icon(Symbols.history, size: 36),
                            SizedBox(height: AppSpacing.sm),
                            Text('No held bills yet'),
                            SizedBox(height: 4),
                            Text(
                              'Add items to cart, then press Hold bill.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      )
                    else
                      Flexible(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: heldSales.length,
                          itemBuilder: (context, index) {
                            final sale = heldSales[index];
                            final theme = Theme.of(context);
                            return Padding(
                              padding: const EdgeInsets.only(
                                bottom: AppSpacing.sm,
                              ),
                              child: Material(
                                color: theme.colorScheme.surface,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: BorderSide(
                                    color: theme.dividerColor.withValues(
                                      alpha: 0.55,
                                    ),
                                  ),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: InkWell(
                                  onTap: () {
                                    bloc.add(PosResumeRequested(sale.id));
                                    Navigator.of(sheetContext).pop();
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(
                                      AppSpacing.md,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: AppColors.accent.withValues(
                                              alpha: 0.09,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: Icon(
                                            Symbols.receipt_long,
                                            color: AppColors.accent,
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.md),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                sale.holdCode,
                                                style: theme
                                                    .textTheme
                                                    .titleMedium
                                                    ?.copyWith(
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                              ),
                                              const SizedBox(height: 6),
                                              Wrap(
                                                spacing: 12,
                                                runSpacing: 4,
                                                children: [
                                                  _BillMeta(
                                                    icon: Symbols.person,
                                                    text:
                                                        sale.customerName ??
                                                        'Walk-in',
                                                  ),
                                                  _BillMeta(
                                                    icon: Symbols.shopping_bag,
                                                    text:
                                                        '${sale.itemCount} ${sale.itemCount == 1 ? 'item' : 'items'}',
                                                  ),
                                                  _BillMeta(
                                                    icon: Symbols.schedule,
                                                    text: DateFormat(
                                                      'h:mm a',
                                                    ).format(sale.heldAt),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: AppSpacing.md),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                              CurrencyFormatter.format(
                                                sale.total,
                                              ),
                                              style: theme.textTheme.titleMedium
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w800,
                                                  ),
                                            ),
                                            const SizedBox(height: 4),
                                            Text(
                                              'Resume',
                                              style: theme.textTheme.labelLarge
                                                  ?.copyWith(
                                                    color: AppColors.accent,
                                                  ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        Icon(
                                          Symbols.arrow_forward,
                                          size: 20,
                                          color: AppColors.accent,
                                        ),
                                        const SizedBox(width: AppSpacing.xs),
                                        IconButton(
                                          tooltip: 'Remove held bill',
                                          visualDensity: VisualDensity.compact,
                                          icon: const Icon(
                                            Symbols.delete_outline,
                                            size: 20,
                                          ),
                                          onPressed: () async {
                                            final confirm = await showDialog<bool>(
                                              context: sheetContext,
                                              builder: (dialogContext) {
                                                return AlertDialog(
                                                  title: const Text(
                                                    'Remove held bill?',
                                                  ),
                                                  content: Text(
                                                    'Move ${sale.holdCode} to the '
                                                    'Recycle Bin? You can restore it '
                                                    'later.',
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            dialogContext,
                                                          ).pop(false),
                                                      child: const Text(
                                                        'Cancel',
                                                      ),
                                                    ),
                                                    FilledButton(
                                                      onPressed: () =>
                                                          Navigator.of(
                                                            dialogContext,
                                                          ).pop(true),
                                                      child: const Text(
                                                        'Remove',
                                                      ),
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                            if (confirm != true) return;
                                            final id = sale.id;
                                            final code = sale.holdCode;
                                            bloc.add(PosHeldSaleDeleted(id));
                                            await sl<NotificationsCubit>()
                                                .notifyRecycle(
                                                  title: 'Held bill deleted',
                                                  body:
                                                      '$code moved to Recycle Bin',
                                                  actionType: NotificationTypes
                                                      .restoreHeldSale,
                                                  entityId: id,
                                                );
                                            if (sheetContext.mounted) {
                                              Navigator.of(sheetContext).pop();
                                            }
                                            if (!parentContext.mounted) return;
                                            AppToast.withUndo(
                                              parentContext,
                                              '$code moved to Recycle Bin',
                                              onUndo: () async {
                                                await sl<PosRepository>()
                                                    .restoreHeldSale(id);
                                                sl<NotificationsCubit>()
                                                    .announceRestore(
                                                      NotificationTypes
                                                          .restoreHeldSale,
                                                    );
                                                if (!parentContext.mounted) {
                                                  return;
                                                }
                                                AppToast.success(
                                                  parentContext,
                                                  '$code restored',
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      );
    },
  );
}

class _BillMeta extends StatelessWidget {
  const _BillMeta({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).textTheme.bodySmall?.color;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 4),
        Text(text, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
