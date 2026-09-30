import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:image/image.dart' as img;

import 'product_image_store.dart';

/// Metadata for a local product image file.
class ProductImageInfo {
  const ProductImageInfo({
    required this.width,
    required this.height,
    required this.bytes,
  });

  final int width;
  final int height;
  final int bytes;

  String get dimensionsLabel => '$width × $height px';

  String get sizeLabel {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get summary => '$dimensionsLabel · $sizeLabel';
}

abstract final class ProductImageUtils {
  static final _store = ProductImageStore();

  static Future<ProductImageInfo?> readInfo(String path) async {
    final file = File(path);
    if (!await file.exists()) return null;

    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return null;

    try {
      final codec = await ui.instantiateImageCodec(bytes);
      final frame = await codec.getNextFrame();
      final image = frame.image;
      final info = ProductImageInfo(
        width: image.width,
        height: image.height,
        bytes: bytes.length,
      );
      image.dispose();
      return info;
    } catch (_) {
      return ProductImageInfo(width: 0, height: 0, bytes: bytes.length);
    }
  }

  /// Copies a picked file into app storage so macOS picker paths stay valid.
  static Future<String> stagePickedImage(String sourcePath) {
    return _store.saveFromPath(sourcePath);
  }

  /// Writes cropped bytes into app storage and returns its path.
  static Future<String> saveCroppedBytes(Uint8List croppedBytes) async {
    final decoded = img.decodeImage(croppedBytes);
    final bytes = decoded != null
        ? Uint8List.fromList(img.encodeJpg(decoded, quality: 88))
        : croppedBytes;

    return _store.saveFromBytes(bytes);
  }
}
