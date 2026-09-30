import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../modules/notifications/presentation/cubit/notifications_cubit.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/empty_state.dart';
import '../../../../widgets/product_image.dart';
import '../../domain/entities/recycle_bin_item.dart';
import '../../domain/repositories/recycle_bin_repository.dart';
import '../bloc/recycle_bin_cubit.dart';

class RecycleBinPage extends StatelessWidget {
  const RecycleBinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => RecycleBinCubit(sl<RecycleBinRepository>())..load(),
      child: BlocListener<NotificationsCubit, NotificationsState>(
        listenWhen: (previous, current) =>
            previous.undoRevision != current.undoRevision,
        listener: (context, state) {
          context.read<RecycleBinCubit>().load();
        },
        child: const _RecycleBinView(),
      ),
    );
  }
}

class _RecycleBinView extends StatelessWidget {
  const _RecycleBinView();

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('d MMM yyyy · h:mm a');

    return BlocConsumer<RecycleBinCubit, RecycleBinState>(
      listenWhen: (prev, next) =>
          next.message != null && next.message != prev.message,
      listener: (context, state) {
        if (state.message != null) {
          AppToast.show(context, state.message!);
        }
      },
      builder: (context, state) {
        if (state.loading && state.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Deleted items stay here until you restore or permanently erase them.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  if (state.items.isNotEmpty) ...[
                    const SizedBox(width: AppSpacing.sm),
                    AppButton(
                      label: 'Empty bin',
                      icon: Symbols.delete_forever,
                      variant: AppButtonVariant.danger,
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Empty Recycle Bin?'),
                            content: const Text(
                              'This permanently deletes every item in the bin. '
                              'This cannot be undone.',
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, false),
                                child: const Text('Cancel'),
                              ),
                              FilledButton(
                                onPressed: () => Navigator.pop(context, true),
                                child: const Text('Empty permanently'),
                              ),
                            ],
                          ),
                        );
                        if (ok == true && context.mounted) {
                          await context.read<RecycleBinCubit>().emptyBin();
                        }
                      },
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: state.items.isEmpty
                    ? const EmptyState(
                        title: 'Recycle Bin is empty',
                        message:
                            'Deleted products, held bills, employees and staff accounts will appear here.',
                        icon: Symbols.delete,
                      )
                    : ListView.separated(
                        itemCount: state.items.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.sm),
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return _RecycleTile(
                            item: item,
                            dateLabel: dateFormat.format(item.deletedAt),
                            onRestore: () => context
                                .read<RecycleBinCubit>()
                                .restore(item),
                            onPurge: () async {
                              final ok = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Delete permanently?'),
                                  content: Text(
                                    'Erase "${item.title}" forever? '
                                    'This cannot be undone.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text('Cancel'),
                                    ),
                                    FilledButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text('Delete forever'),
                                    ),
                                  ],
                                ),
                              );
                              if (ok == true && context.mounted) {
                                await context
                                    .read<RecycleBinCubit>()
                                    .purge(item);
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _RecycleTile extends StatelessWidget {
  const _RecycleTile({
    required this.item,
    required this.dateLabel,
    required this.onRestore,
    required this.onPurge,
  });

  final RecycleBinItem item;
  final String dateLabel;
  final VoidCallback onRestore;
  final VoidCallback onPurge;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final icon = switch (item.kind) {
      RecycleBinKind.product => Symbols.inventory_2,
      RecycleBinKind.heldSale => Symbols.pause_circle,
      RecycleBinKind.employee => Symbols.badge,
      RecycleBinKind.staffUser => Symbols.manage_accounts,
    };

    return Material(
      color: theme.colorScheme.surface,
      borderRadius: BorderRadius.circular(12),
      child: ListTile(
        leading: item.kind == RecycleBinKind.product
            ? ProductImage(path: item.imagePath, size: 48)
            : CircleAvatar(
                backgroundColor: AppColors.accent.withValues(alpha: 0.12),
                child: Icon(icon, color: AppColors.accent, size: 18),
              ),
        title: Text(item.title),
        subtitle: Text('${item.subtitle}\nDeleted $dateLabel'),
        isThreeLine: true,
        trailing: Wrap(
          spacing: 4,
          children: [
            TextButton(
              onPressed: onRestore,
              child: const Text('Restore'),
            ),
            IconButton(
              tooltip: 'Delete forever',
              onPressed: onPurge,
              icon: const Icon(Symbols.delete_forever, size: 18),
            ),
          ],
        ),
      ),
    );
  }
}
