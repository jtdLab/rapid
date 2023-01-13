import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/app_package.dart';
import 'package:rapid_cli/src/project/di_package.dart';
import 'package:rapid_cli/src/project/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_package.dart';
import 'package:rapid_cli/src/project/melos_file.dart';
import 'package:rapid_cli/src/project/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_ui_package.dart';

/// Rapid Project
class Project {
  /// The app package.
  late final AppPackage appPackage = AppPackage(project: this);

  /// The dependency injection package.
  late final DiPackage diPackage = DiPackage(project: this);

  /// The domain package.
  late final DomainPackage domainPackage = DomainPackage(project: this);

  /// The infrastructure package.
  late final InfrastructurePackage infrastructurePackage =
      InfrastructurePackage(project: this);

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
  PlatformUiPackage platformUiPackage(Platform platform) =>
      PlatformUiPackage(platform: platform, project: this);
}
