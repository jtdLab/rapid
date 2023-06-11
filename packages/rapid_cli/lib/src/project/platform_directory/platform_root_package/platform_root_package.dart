import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';

import '../../infrastructure_directory/infrastructure_package/infrastructure_package.dart';
import '../../project.dart';
import '../platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'platform_native_directory/platform_native_directory.dart';
import 'platform_root_package_impl.dart';

typedef _PlatformRootPackageBuilder<T extends PlatformRootPackage> = T Function(
  Platform platform, {
  required RapidProject project,
});

/// {@template platform_root_package}
/// Base class for an abstraction of a platform root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>`
/// {@endtemplate}
abstract class PlatformRootPackage
    implements DartPackage, OverridableGenerator {
  /// Use to override [localizationsDelegatesFile] for testing.
  @visibleForTesting
  LocalizationsDelegatesFileBuilder? localizationsDelegatesFileOverrides;

  /// Use to override [injectionFile] for testing.
  @visibleForTesting
  InjectionFileBuilder? injectionFileOverrides;

  /// Use to override [routerFile] for testing.
  @visibleForTesting
  RouterFileBuilder? routerFileOverrides;

  /// Returns the platform of this package.
  Platform get platform;

  /// Returns the project associated with this package.
  RapidProject get project;

  /// Returns the localizations delegates file of this package.
  LocalizationsDelegatesFile get localizationsDelegatesFile;

  /// Returns the injection file of this package.
  InjectionFile get injectionFile;

  /// Returns the router file of this package.
  RouterFile get routerFile;

  /// Returns the default language of this package.
  String defaultLanguage();

  /// Returns the languages supported by this package.
  Set<String> supportedLanguages();

  /// Registers [featurePackage] to this package.
  Future<void> registerFeaturePackage(
    PlatformFeaturePackage featurePackage, {
    required bool routing,
  });

  /// Unregisters [featurePackage] from this package.
  Future<void> unregisterFeaturePackage(PlatformFeaturePackage featurePackage);

  /// Registers [infrastructurePackage] to this package.
  Future<void> registerInfrastructurePackage(
    InfrastructurePackage infrastructurePackage,
  );

  /// Unregisters [infrastructurePackage] from this package.
  Future<void> unregisterInfrastructurePackage(
    InfrastructurePackage infrastructurePackage,
  );

  /// Adds [language] to this package.
  Future<void> addLanguage(String language);

  /// Removes [language] from this package.
  Future<void> removeLanguage(String language);
}

/// Signature of [NoneIosRootPackage.new].
typedef NoneIosRootPackageBuilder
    = _PlatformRootPackageBuilder<NoneIosRootPackage>;

abstract class NoneIosRootPackage extends PlatformRootPackage {
  factory NoneIosRootPackage(
    Platform platform, {
    required RapidProject project,
  }) =>
      NoneIosRootPackageImpl(
        platform,
        project: project,
      );

  /// Use to override [nativeDirectory] for testing.
  @visibleForTesting
  NoneIosNativeDirectoryBuilder? nativeDirectoryOverrides;

  /// Returns the platform native directory of this directory.
  NoneIosNativeDirectory get nativeDirectory;

  /// Creates this package on disk.
  Future<void> create({
    String? description,
    String? orgName,
  });
}

/// Signature of [IosRootPackage.new].
typedef IosRootPackageBuilder = _PlatformRootPackageBuilder<IosRootPackage>;

/// {@template ios_root_package}
/// Abstraction of an iOS root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_ios/<project name>_ios`
/// {@endtemplate}
abstract class IosRootPackage extends PlatformRootPackage {
  /// {@macro ios_root_package}
  factory IosRootPackage({
    required RapidProject project,
  }) =>
      IosRootPackageImpl(
        project: project,
      );

  /// Use to override [nativeDirectory] for testing.
  @visibleForTesting
  IosNativeDirectoryBuilder? nativeDirectoryOverrides;

  /// Returns the platform native directory of this directory.
  IosNativeDirectory get nativeDirectory;

  /// Creates this package on disk.
  Future<void> create({
    required String orgName,
    required String language,
  });
}

/// Signature of [MobileRootPackage.new].
typedef MobileRootPackageBuilder
    = _PlatformRootPackageBuilder<MobileRootPackage>;

/// {@template mobile_root_package}
/// Abstraction of a Mobile root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_ios/<project name>_mobile`
/// {@endtemplate}
abstract class MobileRootPackage extends PlatformRootPackage {
  /// {@macro mobile_root_package}
  factory MobileRootPackage({
    required RapidProject project,
  }) =>
      MobileRootPackageImpl(
        project: project,
      );

  /// Use to override [nativeDirectory] for testing.
  @visibleForTesting
  IosNativeDirectoryBuilder? iosNativeDirectoryOverrides;

  /// Use to override [nativeDirectory] for testing.
  @visibleForTesting
  NoneIosNativeDirectoryBuilder? androidNativeDirectoryOverrides;

  /// Returns the platform native directory of this directory.
  IosNativeDirectory get iosNativeDirectory;

  /// Returns the platform native directory of this directory.
  NoneIosNativeDirectory get androidNativeDirectory;

  /// Creates this package on disk.
  Future<void> create({
    required String orgName,
    required String language,
    String? description,
  });
}

/// Signature of [LocalizationsDelegatesFile.new].
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

  /// Returns the supported locales of this file.
  Set<String> supportedLocales();

  /// Adds localizations delegate of feature with [packageName] to this file.
  void addLocalizationsDelegate(String packageName);

  /// Adds [locale] to the supported locales of this file.
  void addSupportedLocale(String locale);

  /// Removes the localizations delegate of feature with [packageName] from this file.
  void removeLocalizationsDelegate(String packageName);

  /// Adds [locale] from the supported locales of this file.
  void removeSupportedLocale(String locale);
}

/// Signature of [InjectionFile.new].
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

  /// Adds feature with [packageName] to this file.
  void addFeaturePackage(String packageName);

  /// Removes feature with [packageName] from this file.
  void removeFeaturePackage(String packageName);
}

/// Signature of [RouterFile.new].
typedef RouterFileBuilder = RouterFile Function({
  required PlatformRootPackage rootPackage,
});

/// {@template router_file}
/// Abstraction of the router file of a platform root package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>/lib/router.dart`
/// {@endtemplate}
abstract class RouterFile implements DartFile {
  /// {@macro router_file}
  factory RouterFile({
    required PlatformRootPackage rootPackage,
  }) =>
      RouterFileImpl(
        rootPackage: rootPackage,
      );

  /// Adds module of [packageName] to this file.
  void addRouterModule(String packageName);

  /// Removes module of [packageName] from this file.
  void removeRouterModule(String packageName);
}
