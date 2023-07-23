import 'dart:io';

import 'package:bundles/bundles.dart';

Future<void> main(List<String> arguments) async {
  // must be run from rapid_cli dir
  if (!Directory.current.path.endsWith('packages/rapid_cli')) {
    print('Must be run from packages/rapid_cli');
    return;
  }

  if (arguments.contains('--dry-run')) {
    await checkForUpdates(
      currentDartVersion: dart.minVersion,
      currentFlutterVersion: flutter.minVersion,
      packages: packages,
    );

    return;
  }

  await updatePlatformNativeDirectoryTemplates();
  await updatePubspecYamlFiles();
  await rebundleTemplates(templates);
  await run('dart', ['format', 'lib', '--fix']);
}
