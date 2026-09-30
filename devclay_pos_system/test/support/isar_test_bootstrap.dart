import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:isar_community/isar.dart';

/// Shared Isar native-lib bootstrap for unit/integration tests.
Future<void> ensureIsarCoreInitialized() async {
  final configFile = File('.dart_tool/package_config.json');
  final config =
      jsonDecode(await configFile.readAsString()) as Map<String, dynamic>;
  final packages = config['packages'] as List<dynamic>;
  final package = packages.cast<Map<String, dynamic>>().firstWhere(
        (item) => item['name'] == 'isar_community_flutter_libs',
      );
  final configUri = configFile.absolute.uri;
  final resolvedRoot = configUri.resolve(package['rootUri'] as String);
  final packageRoot = resolvedRoot.toString().endsWith('/')
      ? resolvedRoot
      : Uri.parse('${resolvedRoot.toString()}/');
  final relativeLibrary = Platform.isMacOS
      ? 'macos/libisar.dylib'
      : Platform.isWindows
          ? 'windows/libisar.dll'
          : 'linux/libisar.so';
  await Isar.initializeIsarCore(
    libraries: {
      Abi.current(): packageRoot.resolve(relativeLibrary).toFilePath(),
    },
  );
}
