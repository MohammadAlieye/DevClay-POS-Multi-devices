import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../themes/app_spacing.dart';

/// Search field used in shell and future POS/product screens.
class AppSearchField extends StatelessWidget {
  const AppSearchField({
    super.key,
    this.controller,
    this.focusNode,
    this.hintText = 'Search…',
    this.onChanged,
    this.onSubmitted,
    this.width = 320,
    this.autofocus = false,
  });

  final TextEditingController? controller;
  final FocusNode? focusNode;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final double width;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final field = TextField(
      controller: controller,
      focusNode: focusNode,
      autofocus: autofocus,
      onChanged: onChanged,
      onSubmitted: onSubmitted,
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: const Icon(Symbols.search, size: 18),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
      ),
    );

    if (width == double.infinity) return field;
    return SizedBox(width: width, child: field);
  }
}

/// Standard text field wrapper.
class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hintText,
    this.obscureText = false,
    this.keyboardType,
    this.onChanged,
    this.onSubmitted,
    this.errorText,
  });

  final TextEditingController? controller;
  final String? label;
  final String? hintText;
  final bool obscureText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(label!, style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: AppSpacing.xs),
        ],
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          decoration: InputDecoration(hintText: hintText, errorText: errorText),
        ),
      ],
    );
  }
}
