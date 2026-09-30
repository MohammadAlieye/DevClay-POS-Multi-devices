import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

/// Copies finance receipt attachments into the app's offline documents folder.
class FinanceAttachmentStore {
  FinanceAttachmentStore();

  static const _uuid = Uuid();

  Future<Directory> _attachmentsDir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/finance_attachments');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<String> saveFromPath(String sourcePath) async {
    final source = File(sourcePath);
    if (!await source.exists()) {
      throw StateError('Selected file was not found.');
    }

    final ext = sourcePath.contains('.')
        ? sourcePath.split('.').last.toLowerCase()
        : 'bin';
    final safeExt = (ext.length <= 5) ? ext : 'bin';
    final dir = await _attachmentsDir();
    final target = File('${dir.path}/${_uuid.v4()}.$safeExt');
    await source.copy(target.path);
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
