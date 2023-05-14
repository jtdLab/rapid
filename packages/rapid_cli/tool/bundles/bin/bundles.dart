import 'package:bundles/bundles.dart';

Future<void> main(List<String> arguments) async {
  if (arguments.contains('--dry-run')) {
    await checkForUpdates(
      currentDartVersion: dart.minVersion,
      currentFlutterVersion: flutter.minVersion,
      packages: packages,
    );

    return;
  }

  await updatePlatformNativeDirectoryTemplates();
  await updatePackageTemplates();
  await rebundleTemplates(templates);
  await run('dart', ['format', 'lib', '--fix']);
}
