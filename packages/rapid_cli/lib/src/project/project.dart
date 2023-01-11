import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package.dart';
import 'package:rapid_cli/src/project/di_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';

/// Rapid Project
class Project {
  /// The app package.
  late final AppPackage appPackage = AppPackage(project: this);

  /// The dependency injection package.
  late final DiPackage diPackage = DiPackage(project: this);

  // TODO maybe add getter for other important packages

  /// The domain package.
  late final DartPackage domainPackage = DartPackage(
    path: p.join('packages', melosFile.name(), '${melosFile.name()}_domain'),
  );

  /// The melos file.
  final MelosFile melosFile = MelosFile();

  /// Wheter [platform] is activated.
  bool isActivated(Platform platform) =>
      platformDirectory(platform).exists() &&
      platformUiPackage(platform).exists();

  /// The directory containing [platform] specific packages.
  PlatformDirectory platformDirectory(Platform platform) =>
      PlatformDirectory(platform: platform, project: this);

  /// The package containing [platform] specific ui code.
  DartPackage platformUiPackage(Platform platform) => DartPackage(
        path: p.join(
          'packages',
          '${melosFile.name()}_ui',
          '${melosFile.name()}_ui_${platform.name}',
        ),
      );
}
