import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Copies product images into the app's offline documents folder.
class ProductImageStore {
  ProductImageStore();

  static const _uuid = Uuid();

  Future<Directory> _imagesDir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/product_images');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Copies [sourcePath] into app storage and returns the new absolute path.
  Future<String> saveFromPath(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('Selected image was not found.');
    }

    final ext = sourcePath.contains('.')
        ? sourcePath.split('.').last.toLowerCase()
        : 'jpg';
    final safeExt = (ext.length <= 4) ? ext : 'jpg';
    final dir = await _imagesDir();
    final target = File('${dir.path}/${_uuid.v4()}.$safeExt');
    await source.copy(target.path);
    return target.path;
  }

  /// Writes image bytes into app storage and returns the new absolute path.
  Future<String> saveFromBytes(Uint8List bytes, {String ext = 'jpg'}) async {
    final dir = await _imagesDir();
    final target = File('${dir.path}/${_uuid.v4()}.$ext');
    await target.writeAsBytes(bytes, flush: true);
    return target.path;
  }

  Future<void> deleteIfExists(String? path) async {
    if (path == null || path.isEmpty) return;
    final file = File(path);
    if (await file.exists()) {
      await file.delete();
    }
  }
}
