import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
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
abstract class PlatformDirectory implements DartPackage {
  @visibleForTesting
  PlatformNavigationPackageBuilder? navigationPackageOverrides;

  @visibleForTesting
  PlatformFeaturesDirectoryBuilder? featuresDirectoryOverrides;

  Platform get platform;

  Project get project;

  PlatformRootPackage get rootPackage;

  PlatformNavigationPackage get navigationPackage;

  PlatformFeaturesDirectory get featuresDirectory;

  String defaultLanguage();

  Set<String> supportedLanguages();

  Future<void> addFeature({
    required String name,
    required String description,
    required Logger logger,
  });

  Future<void> removeFeature({
    required String name,
    required Logger logger,
  });

  Future<void> addLanguage(
    String language, {
    required Logger logger,
  });

  Future<void> removeLanguage(
    String language, {
    required Logger logger,
  });

  Future<void> setDefaultLanguage(
    String newDefaultLanguage, {
    required Logger logger,
  });

  Future<void> addBloc({
    required String name,
    required String featureName,
    required Logger logger,
  });

  Future<void> removeBloc({
    required String name,
    required String featureName,
    required Logger logger,
  });

  Future<void> addCubit({
    required String name,
    required String featureName,
    required Logger logger,
  });

  Future<void> removeCubit({
    required String name,
    required String featureName,
    required Logger logger,
  });
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
  NoneIosRootPackageBuilder?
      rootPackageOverrides; // TODO why no pass it via constructor

  Future<void> create({
    String? description,
    String? orgName,
    required String language,
    required Logger logger,
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

  Future<void> create({
    required String orgName,
    required String language,
    required Logger logger,
  });
}
