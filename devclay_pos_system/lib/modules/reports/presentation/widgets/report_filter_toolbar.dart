import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../themes/app_spacing.dart';
import '../../domain/entities/report_detail_payload.dart';
import '../../domain/entities/report_filters.dart';
import '../../domain/services/report_period_utils.dart';

class ReportFilterToolbar extends StatelessWidget {
  const ReportFilterToolbar({
    super.key,
    required this.filters,
    required this.filterOptions,
    required this.requiresPeriod,
    required this.onFiltersChanged,
    this.showExpiryFilters = false,
  });

  final ReportFilters filters;
  final ReportFilterOptions filterOptions;
  final bool requiresPeriod;
  final ValueChanged<ReportFilters> onFiltersChanged;
  final bool showExpiryFilters;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (requiresPeriod) ...[
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: ReportPeriodPreset.values.map((preset) {
              if (preset == ReportPeriodPreset.custom) {
                return FilterChip(
                  label: const Text('Custom'),
                  selected: filters.period == ReportPeriodPreset.custom,
                  onSelected: (_) => _pickCustomRange(context),
                );
              }
              return FilterChip(
                label: Text(ReportPeriodUtils.presetLabel(preset)),
                selected: filters.period == preset,
                onSelected: (_) => onFiltersChanged(
                  filters.copyWith(period: preset, clearCustomRange: true),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        if (showExpiryFilters) ...[
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              _expiryChip('Expired', -1),
              _expiryChip('7 days', 7),
              _expiryChip('30 days', 30),
              _expiryChip('60 days', 60),
              _expiryChip('90 days', 90),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            if (filterOptions.categories.isNotEmpty)
              _dropdown<String?>(
                label: 'Category',
                value: filters.category,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All categories')),
                  ...filterOptions.categories.map(
                    (c) => DropdownMenuItem(value: c, child: Text(c)),
                  ),
                ],
                onChanged: (value) => onFiltersChanged(
                  filters.copyWith(
                    category: value,
                    clearCategory: value == null,
                  ),
                ),
              ),
            if (filterOptions.paymentMethods.isNotEmpty)
              _dropdown<String?>(
                label: 'Payment',
                value: filters.paymentMethod,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All methods')),
                  ...filterOptions.paymentMethods.map(
                    (m) => DropdownMenuItem(value: m, child: Text(m)),
                  ),
                ],
                onChanged: (value) => onFiltersChanged(
                  filters.copyWith(
                    paymentMethod: value,
                    clearPaymentMethod: value == null,
                  ),
                ),
              ),
            if (filterOptions.suppliers.isNotEmpty)
              _dropdown<int?>(
                label: 'Supplier',
                value: filters.supplierId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All suppliers')),
                  ...filterOptions.suppliers.map(
                    (s) => DropdownMenuItem(value: s.$1, child: Text(s.$2)),
                  ),
                ],
                onChanged: (value) => onFiltersChanged(
                  filters.copyWith(
                    supplierId: value,
                    clearSupplierId: value == null,
                  ),
                ),
              ),
            if (filterOptions.customers.isNotEmpty)
              _dropdown<int?>(
                label: 'Customer',
                value: filters.customerId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All customers')),
                  ...filterOptions.customers.map(
                    (c) => DropdownMenuItem(value: c.$1, child: Text(c.$2)),
                  ),
                ],
                onChanged: (value) => onFiltersChanged(
                  filters.copyWith(
                    customerId: value,
                    clearCustomerId: value == null,
                  ),
                ),
              ),
            if (filterOptions.products.isNotEmpty)
              _dropdown<int?>(
                label: 'Product',
                value: filters.productId,
                items: [
                  const DropdownMenuItem(value: null, child: Text('All products')),
                  ...filterOptions.products.map(
                    (p) => DropdownMenuItem(value: p.$1, child: Text(p.$2)),
                  ),
                ],
                onChanged: (value) => onFiltersChanged(
                  filters.copyWith(
                    productId: value,
                    clearProductId: value == null,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _expiryChip(String label, int days) {
    return FilterChip(
      label: Text(label),
      selected: filters.expiryWithinDays == days,
      onSelected: (_) => onFiltersChanged(
        filters.copyWith(expiryWithinDays: days),
      ),
    );
  }

  Future<void> _pickCustomRange(BuildContext context) async {
    final now = DateTime.now();
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now,
      initialDateRange: filters.customStart != null && filters.customEnd != null
          ? DateTimeRange(start: filters.customStart!, end: filters.customEnd!)
          : DateTimeRange(
              start: now.subtract(const Duration(days: 30)),
              end: now,
            ),
    );
    if (range == null) return;
    onFiltersChanged(
      filters.copyWith(
        period: ReportPeriodPreset.custom,
        customStart: range.start,
        customEnd: range.end,
      ),
    );
  }

  Widget _dropdown<T>({
    required String label,
    required T value,
    required List<DropdownMenuItem<T>> items,
    required ValueChanged<T?> onChanged,
  }) {
    return SizedBox(
      width: 180,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 4,
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<T>(
            isExpanded: true,
            value: value,
            items: items,
            onChanged: onChanged,
          ),
        ),
      ),
    );
  }
}

String reportDateRangeDetail(ReportDateRange range, ReportFilters filters) {
  if (filters.period != ReportPeriodPreset.custom) {
    return range.label;
  }
  final fmt = DateFormat('dd MMM yyyy');
  return '${fmt.format(range.start)} – ${fmt.format(range.end.subtract(const Duration(days: 1)))}';
}
