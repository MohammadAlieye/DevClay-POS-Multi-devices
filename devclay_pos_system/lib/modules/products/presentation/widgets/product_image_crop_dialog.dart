import 'package:crop_your_image/crop_your_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../../themes/app_spacing.dart';
import '../../../../widgets/app_button.dart';

/// Square crop dialog for product images.
Future<Uint8List?> showProductImageCropDialog({
  required BuildContext context,
  required Uint8List imageBytes,
}) {
  return showDialog<Uint8List>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => _ProductImageCropDialog(imageBytes: imageBytes),
  );
}

class _ProductImageCropDialog extends StatefulWidget {
  const _ProductImageCropDialog({required this.imageBytes});

  final Uint8List imageBytes;

  @override
  State<_ProductImageCropDialog> createState() =>
      _ProductImageCropDialogState();
}

class _ProductImageCropDialogState extends State<_ProductImageCropDialog> {
  final _controller = CropController();
  late final FocusNode _dialogFocus;
  var _cropping = false;
  var _handlingClose = false;

  @override
  void initState() {
    super.initState();
    _dialogFocus = FocusNode(debugLabel: 'product-image-crop-dialog');
    HardwareKeyboard.instance.addHandler(_onHardwareKey);
  }

  @override
  void dispose() {
    HardwareKeyboard.instance.removeHandler(_onHardwareKey);
    _dialogFocus.dispose();
    super.dispose();
  }

  bool _canHandleKeys() {
    if (_handlingClose || _cropping || !mounted) return false;
    final route = ModalRoute.of(context);
    return route != null && route.isCurrent;
  }

  void _closeDialog([Uint8List? result]) {
    if (_handlingClose || !mounted) return;
    _handlingClose = true;
    Navigator.of(context).pop(result);
  }

  void _applyCrop() {
    if (_cropping || _handlingClose) return;
    setState(() => _cropping = true);
    _controller.crop();
  }

  bool _onHardwareKey(KeyEvent event) {
    if (event is! KeyDownEvent) return false;
    if (!_canHandleKeys()) return false;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _closeDialog();
      return true;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _applyCrop();
      return true;
    }
    return false;
  }

  KeyEventResult _onDialogKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (!_canHandleKeys()) return KeyEventResult.ignored;

    if (event.logicalKey == LogicalKeyboardKey.escape) {
      _closeDialog();
      return KeyEventResult.handled;
    }

    if (event.logicalKey == LogicalKeyboardKey.enter ||
        event.logicalKey == LogicalKeyboardKey.numpadEnter) {
      _applyCrop();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Focus(
      focusNode: _dialogFocus,
      autofocus: true,
      onKeyEvent: _onDialogKey,
      child: AlertDialog(
        title: const Text('Crop product image'),
        content: SizedBox(
          width: 420,
          height: 420,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Drag to reposition · Enter to apply · Esc to cancel',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Crop(
                    image: widget.imageBytes,
                    controller: _controller,
                    aspectRatio: 1,
                    initialRectBuilder:
                        InitialRectBuilder.withSizeAndRatio(size: 0.85),
                    maskColor: Colors.black.withValues(alpha: 0.45),
                    onCropped: (result) {
                      if (!mounted) return;
                      switch (result) {
                        case CropSuccess(:final croppedImage):
                          _closeDialog(croppedImage);
                        case CropFailure(:final cause):
                          setState(() => _cropping = false);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Crop failed: $cause')),
                          );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: _cropping ? null : () => _closeDialog(),
            child: const Text('Cancel'),
          ),
          AppButton(
            label: _cropping ? 'Cropping…' : 'Apply',
            icon: Symbols.crop,
            isLoading: _cropping,
            height: 40,
            onPressed: _cropping ? null : _applyCrop,
          ),
        ],
      ),
    );
  }
}
