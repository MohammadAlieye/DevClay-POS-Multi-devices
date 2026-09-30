import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../core/di/injection.dart';
import '../../../../themes/app_colors.dart';
import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';
import '../../../../widgets/app_card.dart';
import '../../../../widgets/app_search_field.dart';
import '../../../../widgets/app_toast.dart';
import '../../../../widgets/empty_state.dart';
import '../../domain/entities/label_entities.dart';
import '../bloc/labels_bloc.dart';
import '../widgets/label_preview_card.dart';
import '../widgets/label_template_editor_sheet.dart';

class LabelsPage extends StatelessWidget {
  const LabelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LabelsBloc>()..add(const LabelsStarted()),
      child: const _LabelsView(),
    );
  }
}

class _LabelsView extends StatelessWidget {
  const _LabelsView();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LabelsBloc, LabelsState>(
      listenWhen: (prev, curr) => curr is LabelsLoaded && curr.message != null,
      listener: (context, state) {
        if (state is LabelsLoaded && state.message != null) {
          AppToast.show(context, state.message!);
          context.read<LabelsBloc>().add(const LabelsMessageDismissed());
        }
      },
      builder: (context, state) {
        return switch (state) {
          LabelsInitial() || LabelsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          LabelsError(:final message) => EmptyState(
              title: 'Labels unavailable',
              message: message,
              icon: Symbols.barcode,
              action: AppButton(
                label: 'Retry',
                onPressed: () =>
                    context.read<LabelsBloc>().add(const LabelsStarted()),
              ),
            ),
          LabelsLoaded() => _LabelsLoadedView(state: state),
        };
      },
    );
  }
}

class _LabelsLoadedView extends StatelessWidget {
  const _LabelsLoadedView({required this.state});

  final LabelsLoaded state;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Barcode & label printing',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
              ),
              AppButton(
                label: 'Refresh',
                variant: AppButtonVariant.secondary,
                icon: Symbols.refresh,
                onPressed: () => context
                    .read<LabelsBloc>()
                    .add(const LabelsRefreshRequested()),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          SegmentedButton<LabelsTab>(
            segments: const [
              ButtonSegment(
                value: LabelsTab.print,
                label: Text('Print'),
                icon: Icon(Symbols.print, size: 18),
              ),
              ButtonSegment(
                value: LabelsTab.templates,
                label: Text('Templates'),
                icon: Icon(Symbols.layers, size: 18),
              ),
              ButtonSegment(
                value: LabelsTab.history,
                label: Text('History'),
                icon: Icon(Symbols.history, size: 18),
              ),
            ],
            selected: {state.tab},
            onSelectionChanged: (value) {
              context.read<LabelsBloc>().add(LabelsTabChanged(value.first));
            },
          ),
          const SizedBox(height: AppSpacing.md),
          Expanded(
            child: switch (state.tab) {
              LabelsTab.print => _PrintTab(state: state),
              LabelsTab.templates => _TemplatesTab(state: state),
              LabelsTab.history => _HistoryTab(state: state),
            },
          ),
        ],
      ),
    );
  }
}

class _PrintTab extends StatelessWidget {
  const _PrintTab({required this.state});

  final LabelsLoaded state;

  @override
  Widget build(BuildContext context) {
    final template = state.selectedTemplate;
    final previewLines = state.previewLines;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: AppSearchField(
                      width: double.infinity,
                      hintText: 'Search product, SKU, or barcode…',
                      onChanged: (q) => context
                          .read<LabelsBloc>()
                          .add(LabelsSearchChanged(q)),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    label: 'Select all',
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context
                        .read<LabelsBloc>()
                        .add(const LabelsSelectAllVisible()),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  AppButton(
                    label: 'Clear',
                    variant: AppButtonVariant.ghost,
                    onPressed: () => context
                        .read<LabelsBloc>()
                        .add(const LabelsClearSelection()),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: state.visibleProducts.isEmpty
                    ? const EmptyState(
                        title: 'No products found',
                        message: 'Add products or search by name, SKU, or barcode.',
                        icon: Symbols.inventory_2,
                      )
                    : ListView.separated(
                        itemCount: state.visibleProducts.length,
                        separatorBuilder: (_, _) =>
                            const SizedBox(height: AppSpacing.xs),
                        itemBuilder: (context, index) {
                          final product = state.visibleProducts[index];
                          final selected =
                              state.selectedLines.containsKey(product.id);
                          final copies = state.selectedLines[product.id]?.copies ??
                              state.defaultCopies;

                          return AppCard(
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppSpacing.md,
                              vertical: AppSpacing.sm,
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: selected,
                                  onChanged: (_) => context
                                      .read<LabelsBloc>()
                                      .add(LabelsProductToggled(product.id)),
                                ),
                                Expanded(
                                  child: InkWell(
                                    onTap: () => context.read<LabelsBloc>().add(
                                          LabelsProductToggled(product.id),
                                        ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                        Text(
                                          '${product.sku} · ${product.barcode}',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                if (selected)
                                  LabelCopiesStepper(
                                    key: ValueKey('line-copies-${product.id}'),
                                    copies: copies,
                                    onChanged: (value) => context
                                        .read<LabelsBloc>()
                                        .add(
                                          LabelsLineCopiesChanged(
                                            product.id,
                                            value,
                                          ),
                                        ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AppCard(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.md,
                  vertical: AppSpacing.sm,
                ),
                child: Row(
                  children: [
                    Icon(
                      Symbols.layers,
                      size: 20,
                      color: AppColors.accent,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: template == null
                          ? Text(
                              'No template selected',
                              style: Theme.of(context).textTheme.titleSmall,
                            )
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  template.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.titleSmall,
                                ),
                                Text(
                                  '${template.sizeLabel} · ${LabelLabels.payloadFormat(template.payloadFormat)}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                    ),
                    AppButton(
                      label: 'Change',
                      variant: AppButtonVariant.secondary,
                      height: 40,
                      onPressed: () => context.read<LabelsBloc>().add(
                            const LabelsTabChanged(LabelsTab.templates),
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Label preview',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    Text(
                      previewLines.isEmpty
                          ? 'Select products to preview each label'
                          : template == null
                              ? 'Choose a template on the Templates tab'
                              : '${template.name} · ${template.sizeLabel}'
                                  '${previewLines.length > 1 ? ' · ${previewLines.length} products' : ''}',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    if (state.previewIsCapped)
                      Text(
                        'Showing first ${previewLines.length} of ${state.previewTotalCount}',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    const SizedBox(height: AppSpacing.sm),
                    Expanded(
                      child: template == null
                          ? EmptyState(
                              title: 'No template selected',
                              message:
                                  'Open Templates and tap the layout you want to print.',
                              icon: Symbols.layers,
                              action: AppButton(
                                label: 'Choose template',
                                onPressed: () => context.read<LabelsBloc>().add(
                                      const LabelsTabChanged(
                                        LabelsTab.templates,
                                      ),
                                    ),
                              ),
                            )
                          : previewLines.isEmpty
                              ? const EmptyState(
                                  title: 'No labels selected',
                                  message:
                                      'Tick products on the left. Each one gets its own preview and copy count.',
                                  icon: Symbols.barcode,
                                )
                              : ListView.separated(
                                  itemCount: previewLines.length,
                                  separatorBuilder: (_, _) =>
                                      const SizedBox(height: AppSpacing.sm),
                                  itemBuilder: (context, index) {
                                    final line = previewLines[index];
                                    return LabelPreviewCard(
                                      template: template,
                                      line: line,
                                      onCopiesChanged: (value) => context
                                          .read<LabelsBloc>()
                                          .add(
                                            LabelsLineCopiesChanged(
                                              line.productId,
                                              value,
                                            ),
                                          ),
                                    );
                                  },
                                ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              AppButton(
                label: state.isPrinting
                    ? 'Printing…'
                    : 'Print ${state.pendingLabelCount} labels',
                icon: Symbols.print,
                expanded: true,
                onPressed: state.isPrinting || state.pendingLabelCount <= 0
                    ? null
                    : () => context
                        .read<LabelsBloc>()
                        .add(const LabelsPrintRequested()),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TemplatesTab extends StatelessWidget {
  const _TemplatesTab({required this.state});

  final LabelsLoaded state;

  Future<void> _openEditor(
    BuildContext context, {
    LabelTemplateItem? existing,
  }) async {
    final draft = await showLabelTemplateEditorSheet(
      context: context,
      existing: existing,
    );
    if (draft == null || !context.mounted) return;
    context.read<LabelsBloc>().add(
          LabelsTemplateSaved(draft: draft, id: existing?.id),
        );
  }

  @override
  Widget build(BuildContext context) {
    final templates = state.storeTypeFilter == null
        ? state.templates
        : state.templates
            .where((t) => t.storeType == state.storeTypeFilter)
            .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Choose a layout for printing. The selected template is used on the Print tab.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
            AppButton(
              label: 'New template',
              icon: Symbols.add,
              onPressed: () => _openEditor(context),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            FilterChip(
              label: const Text('All'),
              selected: state.storeTypeFilter == null,
              onSelected: (_) => context.read<LabelsBloc>().add(
                    const LabelsStoreTypeFilterChanged(null),
                  ),
            ),
            ...LabelStoreType.values.map((type) {
              return FilterChip(
                label: Text(LabelLabels.storeType(type)),
                selected: state.storeTypeFilter == type,
                onSelected: (selected) => context.read<LabelsBloc>().add(
                      LabelsStoreTypeFilterChanged(selected ? type : null),
                    ),
              );
            }),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Expanded(
          child: templates.isEmpty
              ? const EmptyState(
                  title: 'No templates in this type',
                  message: 'Choose All or another store type.',
                  icon: Symbols.layers,
                )
              : ListView.separated(
                  itemCount: templates.length,
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.sm),
                  itemBuilder: (context, index) {
                    final template = templates[index];
                    final selected = template.id == state.selectedTemplateId;
                    return AppCard(
                      padding: const EdgeInsets.all(AppSpacing.md),
                      color: selected
                          ? AppColors.accent.withValues(alpha: 0.08)
                          : null,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () => context.read<LabelsBloc>().add(
                                    LabelsTemplateSelected(template.id),
                                  ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Flexible(
                                        child: Text(
                                          template.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall,
                                        ),
                                      ),
                                      if (selected) ...[
                                        const SizedBox(width: AppSpacing.sm),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: AppColors.accent
                                                .withValues(alpha: 0.12),
                                            borderRadius:
                                                BorderRadius.circular(999),
                                          ),
                                          child: Text(
                                            'Selected',
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall
                                                ?.copyWith(
                                                  color: AppColors.accent,
                                                ),
                                          ),
                                        ),
                                      ],
                                      if (template.isDefault) ...[
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          'Default',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ],
                                      if (template.isBuiltIn) ...[
                                        const SizedBox(width: AppSpacing.sm),
                                        Text(
                                          'Built-in',
                                          style: Theme.of(context)
                                              .textTheme
                                              .labelSmall,
                                        ),
                                      ],
                                    ],
                                  ),
                                  Text(
                                    '${template.storeTypeLabel} · ${template.sizeLabel} · '
                                    '${LabelLabels.symbology(template.symbology)} · '
                                    '${LabelLabels.payloadFormat(template.payloadFormat)}',
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                                  if (template.description.isNotEmpty)
                                    Text(
                                      template.description,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall,
                                    ),
                                ],
                              ),
                            ),
                          ),
                          AppButton(
                            label: 'Edit',
                            icon: Symbols.edit,
                            variant: AppButtonVariant.secondary,
                            height: 40,
                            onPressed: () =>
                                _openEditor(context, existing: template),
                          ),
                          if (!template.isBuiltIn) ...[
                            const SizedBox(width: AppSpacing.xs),
                            IconButton(
                              tooltip: 'Delete',
                              icon: const Icon(Symbols.delete, size: 20),
                              onPressed: () => context.read<LabelsBloc>().add(
                                    LabelsTemplateDeleted(template.id),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _HistoryTab extends StatelessWidget {
  const _HistoryTab({required this.state});

  final LabelsLoaded state;

  @override
  Widget build(BuildContext context) {
    if (state.history.isEmpty) {
      return const EmptyState(
        title: 'No print jobs yet',
        message: 'Label print history appears here after your first batch.',
        icon: Symbols.history,
      );
    }

    final formatter = DateFormat('d MMM yyyy · HH:mm');

    return ListView.separated(
      itemCount: state.history.length,
      separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.sm),
      itemBuilder: (context, index) {
        final job = state.history[index];
        return AppCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      job.templateName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  Text(
                    job.status,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.success,
                        ),
                  ),
                ],
              ),
              Text(
                formatter.format(job.printedAt),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                '${job.labelCount} labels · ${job.productCount} products · '
                '${job.storeType} · ${job.payloadFormat}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
              Text(
                job.itemsSummary,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        );
      },
    );
  }
}
