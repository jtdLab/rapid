import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/language.dart';
import 'package:rapid_cli/src/core/platform.dart';

import '../project.dart';
import 'platform_directory_impl.dart';
import 'platform_features_directory/platform_features_directory.dart';
import 'platform_navigation_package/platform_navigation_package.dart';
import 'platform_root_package/platform_root_package.dart';

typedef PlatformDirectoryBuilder<T extends PlatformDirectory> = T Function({
  required Platform platform,
  required RapidProject project,
});

/// {@template platform_directory}
/// Base class for an abstraction of a platform directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>`
/// {@endtemplate}
abstract class PlatformDirectory implements Directory {
  /// Use to override [navigationPackage] for testing.
  @visibleForTesting
  PlatformNavigationPackageBuilder? navigationPackageOverrides;

  /// Use to override [featuresDirectory] for testing.
  @visibleForTesting
  PlatformFeaturesDirectoryBuilder? featuresDirectoryOverrides;

  /// Returns the platform of this directory.
  Platform get platform;

  /// Returns the project associated with this directory.
  RapidProject get project;

  /// Returns the root package of this directory.
  PlatformRootPackage get rootPackage;

  /// Returns platforn navigation package of this directory.
  PlatformNavigationPackage get navigationPackage;

  /// Returns the features directory of this directory.
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
    required RapidProject project,
  }) =>
      NoneIosDirectoryImpl(platform, project: project);

  /// Use to override [rootPackage] for testing.
  @visibleForTesting
  NoneIosRootPackageBuilder? rootPackageOverrides;

  @override
  NoneIosRootPackage get rootPackage;

  /// Creates this directory on disk.
  Future<void> create({
    String? description,
    String? orgName,
    required Language language,
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
    required RapidProject project,
  }) =>
      IosDirectoryImpl(project: project);

  /// Use to override [rootPackage] for testing.
  @visibleForTesting
  IosRootPackageBuilder? rootPackageOverrides;

  @override
  IosRootPackage get rootPackage;

  /// Creates this directory on disk.
  Future<void> create({
    required String orgName,
    required Language language,
  });
}

/// {@template mobile_directory}
/// Abstraction of a Mobile directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_mobile`
/// {@endtemplate}
abstract class MobileDirectory extends PlatformDirectory {
  /// {@macro ios_directory}
  factory MobileDirectory({
    required RapidProject project,
  }) =>
      MobileDirectoryImpl(project: project);

  /// Use to override [rootPackage] for testing.
  @visibleForTesting
  MobileRootPackageBuilder? rootPackageOverrides;

  @override
  MobileRootPackage get rootPackage;

  /// Creates this directory on disk.
  Future<void> create({
    required String orgName,
    required Language language,
    String? description,
  });
}
