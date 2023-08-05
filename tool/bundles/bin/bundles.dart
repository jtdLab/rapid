import 'dart:io';

import 'package:bundles/bundles.dart';

Future<void> main(List<String> arguments) async {
  // must be run from root
  if (!Directory.current.listSync().any((e) => e.path.endsWith('bricks'))) {
    print('Could not find directory named "bricks"');
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
