import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/root_dir.dart';

import 'app_package.dart';
import 'di_package.dart';
import 'melos_file.dart';
import 'platform_dir.dart';
import 'platform_ui_package.dart';

/// {@template project}
/// Abstraction of a Rapid project.
/// {@endtemplate}
class Project {
  /// The root directory
  final RootDir rootDir = RootDir();

  /// The `melos.yaml`
  final MelosFile melosFile = MelosFile();

  /// The app package
  late final AppPackage appPackage = AppPackage(project: this);

  /// The di package
  late final DiPackage diPackage = DiPackage(project: this);

  /// The directory containing [platform] specific packages
  PlatformDir platformDir(Platform platform) =>
      PlatformDir(platform, project: this);

  /// The package containing [platform] specific ui code.
  PlatformUiPackage platformUiPackage(Platform platform) =>
      PlatformUiPackage(platform, project: this);

  /// Wheter [platform] is activated.
  bool isActivated(Platform platform) =>
      platformDir(platform).exists() && platformUiPackage(platform).exists();
}
