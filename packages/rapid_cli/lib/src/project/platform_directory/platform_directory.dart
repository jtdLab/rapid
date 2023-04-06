import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory_impl.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_features_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_navigation_package/platform_navigation_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_root_package/platform_root_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Signature for method that returns the [PlatformDirectory] for [platform].
typedef PlatformDirectoryBuilder = PlatformDirectory Function({
  required Platform platform,
  required Project project,
});

/// {@template platform_directory}
/// Base class for an abstraction of a platform directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>`
/// {@endtemplate}
abstract class PlatformDirectory implements Directory {
  @visibleForTesting
  PlatformNavigationPackageBuilder? navigationPackageOverrides;

  @visibleForTesting
  PlatformFeaturesDirectoryBuilder? featuresDirectoryOverrides;

  Platform get platform;

  Project get project;

  PlatformRootPackage get rootPackage;

  PlatformNavigationPackage get navigationPackage;

  PlatformFeaturesDirectory get featuresDirectory;
}

/// {@template none_ios_directory}
/// Abstraction of a platform directory of a Rapid project.
///
/// With platform != ios
///
/// Location: `packages/<project name>/<project name>_<platform>`
/// {@endtemplate}
abstract class NoneIosDirectory extends PlatformDirectory {
  /// {@macro none_ios_directory}
  factory NoneIosDirectory(
    Platform platform, {
    required Project project,
  }) =>
      NoneIosDirectoryImpl(platform, project: project);

  @visibleForTesting
  NoneIosRootPackageBuilder? rootPackageOverrides;

  @override
  NoneIosRootPackage get rootPackage;

  Future<void> create({
    String? description,
    String? orgName,
    required String language,
  });
}

/// {@template ios_directory}
/// Abstraction of a iOS directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_ios`
/// {@endtemplate}
abstract class IosDirectory extends PlatformDirectory {
  /// {@macro ios_directory}
  factory IosDirectory({
    required Project project,
  }) =>
      IosDirectoryImpl(project: project);

  @visibleForTesting
  IosRootPackageBuilder? rootPackageOverrides;

  @override
  IosRootPackage get rootPackage;

  Future<void> create({
    required String orgName,
    required String language,
  });
}
