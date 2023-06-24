import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/arb_file.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';

import '../../../project.dart';
import 'platform_feature_package_impl.dart';

/// Signature for method that returns the [PlatformFeaturePackage] for [name].
typedef PlatformFeaturePackageBuilder<T extends PlatformFeaturePackage> = T
    Function(
  String name,
  Platform platform, {
  required RapidProject project,
});

abstract class PlatformFeaturePackage
    implements
        DartPackage,
        OverridableGenerator,
        Comparable<PlatformFeaturePackage> {
  @visibleForTesting
  L10nFileBuilder? l10nFileOverrides;

  @visibleForTesting
  L10nDirectoryBuilder? l10nDirectoryOverrides;

  @visibleForTesting
  LanguageLocalizationsFileBuilder? languageLocalizationsFileOverrides;

  @visibleForTesting
  ArbDirectoryBuilder? arbDirectoryOverrides;

  @visibleForTesting
  BlocBuilder? blocOverrides;

  @visibleForTesting
  CubitBuilder? cubitOverrides;

  @visibleForTesting
  PlatformFeaturePackageApplicationBarrelFileBuilder?
      applicationBarrelFileOverrides;

  @visibleForTesting
  PlatformFeaturePackageBarrelFileBuilder? barrelFileOverrides;

  String get name;

  Platform get platform;

  RapidProject get project;

  Bloc bloc({required String name, required String dir});

  Cubit cubit({required String name, required String dir});

  PlatformFeaturePackageApplicationBarrelFile get applicationBarrelFile;

  PlatformFeaturePackageBarrelFile get barrelFile;

  bool get hasLanguages;

  Set<String> supportedLanguages();

  String defaultLanguage();

  Future<void> setDefaultLanguage(String newDefaultLanguage);

  Future<void> addLanguage(String language);

  Future<void> removeLanguage(String language);
}

abstract class PlatformRoutableFeaturePackage extends PlatformFeaturePackage {
  @visibleForTesting
  PlatformFeaturePackageNavigatorBuilder? get navigatorImplementationOverrides;

  PlatformFeaturePackageNavigatorImplementation get navigatorImplementation;
}

/// {@template platform_custom_feature_package}
/// Abstraction of a platform custom feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_features/<project name>_<platform>_<name>`
/// {@endtemplate}
abstract class PlatformCustomFeaturePackage
    implements PlatformRoutableFeaturePackage {
  /// {@macro platform_custom_feature_package}
  factory PlatformCustomFeaturePackage(
    String name,
    Platform platform, {
    required RapidProject project,
  }) =>
      PlatformCustomFeaturePackageImpl(
        name,
        platform,
        project: project,
      );

  Future<void> create({
    required String description,
    required bool routing,
    required bool localization,
    required String defaultLanguage,
    required Set<String> languages,
  });
}

/// {@template platform_flow_feature_package}
/// Abstraction of a platform flow feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_features/<project name>_<platform>_<name>_flow`
/// {@endtemplate}
abstract class PlatformFlowFeaturePackage
    implements PlatformRoutableFeaturePackage {
  /// {@macro platform_flow_feature_package}
  factory PlatformFlowFeaturePackage(
    String name,
    Platform platform, {
    required RapidProject project,
  }) =>
      PlatformFlowFeaturePackageImpl(
        name,
        platform,
        project: project,
      );

  Future<void> create({
    required bool tab,
    required String description,
    required bool localization,
    required String defaultLanguage,
    required Set<String> languages,
    required Set<PlatformFeaturePackage>? features,
  });
}

/// {@template platform_page_feature_package}
/// Abstraction of a platform page feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_features/<project name>_<platform>_<name>_page`
/// {@endtemplate}
abstract class PlatformPageFeaturePackage
    implements PlatformRoutableFeaturePackage {
  /// {@macro platform_page_feature_package}
  factory PlatformPageFeaturePackage(
    String name,
    Platform platform, {
    required RapidProject project,
  }) =>
      PlatformPageFeaturePackageImpl(
        name,
        platform,
        project: project,
      );

  Future<void> create({
    required String description,
    required bool localization,
    bool exampleTranslation,
    required String defaultLanguage,
    required Set<String> languages,
  });
}

/// {@template platform_widget_feature_package}
/// Abstraction of a platform widget feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_features/<project name>_<platform>_<name>_widget`
/// {@endtemplate}
abstract class PlatformWidgetFeaturePackage implements PlatformFeaturePackage {
  /// {@macro platform_widget_feature_package}
  factory PlatformWidgetFeaturePackage(
    String name,
    Platform platform, {
    required RapidProject project,
  }) =>
      PlatformWidgetFeaturePackageImpl(
        name,
        platform,
        project: project,
      );

  Future<void> create({
    required String description,
    required bool localization,
    required String defaultLanguage,
    required Set<String> languages,
  });
}

/// {@template platform_app_feature_package}
/// Abstraction of a platform app feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_features/<project name>_<platform>_app`
/// {@endtemplate}
abstract class PlatformAppFeaturePackage implements PlatformFeaturePackage {
  /// {@macro platform_app_feature_package}
  factory PlatformAppFeaturePackage(
    Platform platform, {
    required RapidProject project,
  }) =>
      PlatformAppFeaturePackageImpl(
        platform,
        project: project,
      );

  Future<void> create({
    required String description,
    bool routing,
    required bool localization,
    required String defaultLanguage,
    required Set<String> languages,
  });
}

typedef L10nDirectoryBuilder = L10nDirectory Function({
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template l10n_directory}
/// Abstraction of the l10n directory of a platform customizable feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/l10n.yaml`
/// {@endtemplate}
abstract class L10nDirectory implements Directory {
  /// {@macro l10n_directory}
  factory L10nDirectory({
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      L10nDirectoryImpl(
        platformFeaturePackage: platformFeaturePackage,
      );
}

/// Thrown when [L10nFile.readTemplateArbFile] fails to read the `template-arb-file` property.
class ReadTemplateArbFileFailure implements Exception {}

typedef L10nFileBuilder = L10nFile Function({
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template l10n_file}
/// Abstraction of the l10n file of a platform customizable feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/l10n.yaml`
/// {@endtemplate}
abstract class L10nFile implements YamlFile {
  /// {@macro l10n_file}
  factory L10nFile({
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      L10nFileImpl(
        platformFeaturePackage: platformFeaturePackage,
      );

  /// The `template-arb-file` property.
  String readTemplateArbFile();

  void setTemplateArbFile(String newTemplateArbFile);
}

typedef LanguageLocalizationsFileBuilder = LanguageLocalizationsFile Function(
  String language, {
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template language_localizations_file}
/// Abstraction of the localizations file of a specific language of a platform customizable feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/<feature name>_localizations_<language>.dart`
/// {@endtemplate}
abstract class LanguageLocalizationsFile implements DartFile {
  /// {@macro language_localizations_file}
  factory LanguageLocalizationsFile(
    String language, {
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      LanguageLocalizationsFileImpl(
        language,
        platformFeaturePackage: platformFeaturePackage,
      );
}

typedef ArbDirectoryBuilder = ArbDirectory Function({
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template arb_directory}
/// Abstraction of the arb directory of a platform customizable feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/arb`
/// {@endtemplate}
abstract class ArbDirectory implements Directory {
  /// {@macro arb_directory}
  factory ArbDirectory({
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      ArbDirectoryImpl(
        platformFeaturePackage: platformFeaturePackage,
      );

  @visibleForTesting
  LanguageArbFileBuilder? languageArbFileOverrides;

  PlatformFeaturePackage
      get platformFeaturePackage; // TODO needs to be visible?

  LanguageArbFile languageArbFile({required String language});

  List<LanguageArbFile> languageArbFiles();

  Future<void> create({
    required Set<String> languages,
    List<Map<String, dynamic>> Function(String language)? translations,
  });
}

typedef LanguageArbFileBuilder = LanguageArbFile Function({
  required String language,
  required ArbDirectory arbDirectory,
});

/// {@template language_arb_file}
/// Abstraction of a arb file for a language of a platform customizable feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/arb/<feature name>_<language>.arb`
/// {@endtemplate}
abstract class LanguageArbFile
    implements ArbFile, OverridableGenerator, Comparable<LanguageArbFile> {
  /// {@macro language_arb_file}
  factory LanguageArbFile({
    required String language,
    required ArbDirectory arbDirectory,
  }) =>
      LanguageArbFileImpl(
        language: language,
        arbDirectory: arbDirectory,
      );

  String get language;

  Future<void> create();

  void addTranslation({
    required String name,
    required String translation,
    required String description,
  });
}

typedef BlocBuilder = Bloc Function({
  required String name,
  required String dir,
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template bloc}
/// Abstraction of a bloc of a platform custom feature package of a Rapid project.
/// {@endtemplate}
abstract class Bloc
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro bloc}
  factory Bloc({
    required String name,
    required String dir,
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      BlocImpl(
        name: name,
        dir: dir,
        platformFeaturePackage: platformFeaturePackage,
      );

  Future<void> create();
}

typedef CubitBuilder = Cubit Function({
  required String name,
  required String dir,
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template cubit}
/// Abstraction of a cubit of a platform custom feature package of a Rapid project.
/// {@endtemplate}
abstract class Cubit
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro cubit}
  factory Cubit({
    required String name,
    required String dir,
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      CubitImpl(
        name: name,
        dir: dir,
        platformFeaturePackage: platformFeaturePackage,
      );

  Future<void> create();
}

typedef PlatformFeaturePackageNavigatorBuilder
    = PlatformFeaturePackageNavigatorImplementation Function({
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template platform_feature_package_navigator_implementation}
/// Abstraction of the navigator implementation of a platform feature package of a Rapid project.
/// {@endtemplate}
abstract class PlatformFeaturePackageNavigatorImplementation
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro platform_feature_package_navigator_implementation}
  factory PlatformFeaturePackageNavigatorImplementation({
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      PlatformFeaturePackageNavigatorImplementationImpl(
        platformFeaturePackage: platformFeaturePackage,
      );

  Future<void> create();
}

typedef PlatformFeaturePackageApplicationBarrelFileBuilder
    = PlatformFeaturePackageApplicationBarrelFile Function({
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template platform_feature_package_application_barrel_file}
/// Abstraction of the barrel file of a platform feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_features/<project name>_<platform>_<feature name>/lib/src/application/application.dart`
/// {@endtemplate}
abstract class PlatformFeaturePackageApplicationBarrelFile implements DartFile {
  /// {@macro platform_feature_package_application_barrel_file}
  factory PlatformFeaturePackageApplicationBarrelFile({
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      PlatformFeaturePackageApplicationBarrelFileImpl(
        platformFeaturePackage: platformFeaturePackage,
      );

  Future<void> create();
}

typedef PlatformFeaturePackageBarrelFileBuilder
    = PlatformFeaturePackageBarrelFile Function({
  required PlatformFeaturePackage platformFeaturePackage,
});

/// {@template platform_feature_package_barrel_file}
/// Abstraction of the barrel file of a platform feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_features/<project name>_<platform>_<feature name>/lib/<project name>_<platform>_<feature name>.dart`
/// {@endtemplate}
abstract class PlatformFeaturePackageBarrelFile implements DartFile {
  /// {@macro platform_feature_package_barrel_file}
  factory PlatformFeaturePackageBarrelFile({
    required PlatformFeaturePackage platformFeaturePackage,
  }) =>
      PlatformFeaturePackageBarrelFileImpl(
        platformFeaturePackage: platformFeaturePackage,
      );
}
