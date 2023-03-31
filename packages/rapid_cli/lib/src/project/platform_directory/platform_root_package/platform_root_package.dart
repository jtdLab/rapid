import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_root_package/platform_native_directory/platform_native_directory.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_root_package_impl.dart';

typedef PlatformRootPackageBuilder = PlatformRootPackage Function(
  Platform platform, {
  required Project project,
});

/// {@template platform_root_package}
/// Base class for an abstraction of a platform root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>`
/// {@endtemplate}
abstract class PlatformRootPackage
    implements DartPackage, OverridableGenerator {
  @visibleForTesting
  LocalizationsDelegatesFileBuilder? localizationsDelegatesFileOverrides;

  @visibleForTesting
  InjectionFileBuilder? injectionFileOverrides;

  Platform get platform;

  Project get project;

  Set<String> supportedLanguages();

  Future<void> registerFeature({
    required String packageName,
    required Logger logger,
  });

  Future<void> unregisterFeature({
    required String packageName,
    required Logger logger,
  });
}

typedef NoneIosRootPackageBuilder = NoneIosRootPackage Function(
  Platform platform, {
  required Project project,
});

abstract class NoneIosRootPackage extends PlatformRootPackage {
  factory NoneIosRootPackage(
    Platform platform, {
    required Project project,
  }) =>
      NoneIosRootPackageImpl(
        platform,
        project: project,
      );

  @visibleForTesting
  NoneIosNativeDirectoryBuilder? nativeDirectoryOverrides;

  Future<void> create({
    String? description,
    String? orgName,
    required Logger logger,
  });
}

typedef IosRootPackageBuilder = IosRootPackage Function({
  required Project project,
});

/// {@template ios_root_package}
/// Abstraction of an iOS root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_ios/<project name>_ios`
/// {@endtemplate}
abstract class IosRootPackage extends PlatformRootPackage {
  /// {@macro ios_root_package}
  factory IosRootPackage({
    required Project project,
  }) =>
      IosRootPackageImpl(
        project: project,
      );

  @visibleForTesting
  IosNativeDirectoryBuilder? nativeDirectoryOverrides;

  Future<void> create({
    required String orgName,
    required String language,
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
}

typedef LocalizationsDelegatesFileBuilder = LocalizationsDelegatesFile
    Function({
  required PlatformRootPackage rootPackage,
});

/// {@template localizations_delegates_file}
/// Abstraction of the delegates file of a platform root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>/lib/localizations_delegates.dart`
/// {@endtemplate}
abstract class LocalizationsDelegatesFile implements DartFile {
  /// {@macro localizations_delegates_file}
  factory LocalizationsDelegatesFile({
    required PlatformRootPackage rootPackage,
  }) =>
      LocalizationsDelegatesFileImpl(
        rootPackage: rootPackage,
      );

  Set<String> supportedLocales();

  /// Adds localizations delegate of feature with [packageName].
  void addLocalizationsDelegate(String packageName);

  void addSupportedLocale(String locale);

  /// Removes localizations delegate of feature with [packageName].
  void removeLocalizationsDelegate(String packageName);

  void removeSupportedLocale(String locale);
}

typedef InjectionFileBuilder = InjectionFile Function({
  required PlatformRootPackage rootPackage,
});

/// {@template injection_file}
/// Abstraction of the injection file of a platform root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>/lib/injection.dart`
/// {@endtemplate}
abstract class InjectionFile implements DartFile {
  /// {@macro injection_file}
  factory InjectionFile({
    required PlatformRootPackage rootPackage,
  }) =>
      InjectionFileImpl(
        rootPackage: rootPackage,
      );

  /// Adds feature with [packageName] to the injection file.
  void addFeaturePackage(String packageName);

  /// Removes feature with [packageName] from the injection file.
  void removeFeaturePackage(String packageName);
}
