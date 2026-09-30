import 'package:flutter/material.dart';

import '../../../../core/di/injection.dart';
import '../../../../core/store_profile/store_profile_service.dart';
import '../../../../core/store_profile/store_profiles.dart';
import '../../../../themes/app_spacing.dart';
import '../../domain/entities/product_item.dart';

/// Dialog: pick size then color for a clothing product with variants.
Future<ProductVariantItem?> showPosVariantPicker({
  required BuildContext context,
  required ProductItem product,
}) async {
  if (!product.hasVariants || product.variants.isEmpty) return null;
  return showDialog<ProductVariantItem>(
    context: context,
    builder: (context) => _PosVariantPickerDialog(product: product),
  );
}

class _PosVariantPickerDialog extends StatefulWidget {
  const _PosVariantPickerDialog({required this.product});

  final ProductItem product;

  @override
  State<_PosVariantPickerDialog> createState() =>
      _PosVariantPickerDialogState();
}

class _PosVariantPickerDialogState extends State<_PosVariantPickerDialog> {
  String? _size;

  @override
  Widget build(BuildContext context) {
    final variants = widget.product.variants.where((v) => v.isActive).toList();
    final sizes = variants.map((v) => v.size).toSet().toList()..sort();
    final colors = variants
        .where((v) => _size == null || v.size == _size)
        .map((v) => v.color)
        .toSet()
        .toList()
      ..sort();

    return AlertDialog(
      title: Text('Select size & color — ${widget.product.name}'),
      content: SizedBox(
        width: 420,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Size', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final size in sizes)
                  ChoiceChip(
                    label: Text(size),
                    selected: _size == size,
                    onSelected: (_) => setState(() => _size = size),
                  ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Text('Color', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final color in colors)
                  ActionChip(
                    label: Text(color),
                    onPressed: _size == null
                        ? null
                        : () {
                            final match = variants.firstWhere(
                              (v) => v.size == _size && v.color == color,
                            );
                            Navigator.pop(context, match);
                          },
                  ),
              ],
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
      ],
    );
  }
}

/// Returns whether product variants feature is enabled for this install.
Future<bool> storeProfileEnablesVariants() async {
  final flags = await sl<StoreProfileService>().currentFlags();
  return flags.enableProductVariants;
}

Future<bool> storeProfileRequiresBatches() async {
  final flags = await sl<StoreProfileService>().currentFlags();
  return flags.batchesExpiryRequired;
}

Future<bool> storeProfileShowsBatches() async {
  final flags = await sl<StoreProfileService>().currentFlags();
  return flags.enableBatchesExpiry;
}

Future<bool> storeProfilePreferVolume() async {
  final flags = await sl<StoreProfileService>().currentFlags();
  return flags.preferVolumeUnits;
}

Future<StoreProfileId> currentStoreProfileId() {
  return sl<StoreProfileService>().currentProfileId();
}
