import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/arb_file.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_feature_package_impl.dart';

/// Base class of a platform feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>`
abstract class PlatformFeaturePackage implements DartPackage {
  Project get project;

  String get name;

  Platform get platform;
}

/// {@template platform_routing_feature_package}
/// Abstraction of a platform routing feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_routing`
/// {@endtemplate}
abstract class PlatformRoutingFeaturePackage implements PlatformFeaturePackage {
  /// {@macro platform_routing_feature_package}
  factory PlatformRoutingFeaturePackage(
    Platform platform, {
    required Project project,
    PubspecFile? pubspecFile,
    GeneratorBuilder? generator,
  }) =>
      PlatformRoutingFeaturePackageImpl(
        platform,
        project: project,
        pubspecFile: pubspecFile,
        generator: generator,
      );

  Future<void> create({required Logger logger});

  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  });

  Future<void> unregisterCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  });
}

typedef LanguageLocalizationsFileBuilder = LanguageLocalizationsFile Function({
  required String language,
});

/// Base class of a customizable platform feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>`
abstract class PlatformCustomizableFeaturePackage
    implements PlatformFeaturePackage {
  LanguageLocalizationsFileBuilder get languageLocalizationsFile;

  Set<String> supportedLanguages();

  bool supportsLanguage(String language);

  String defaultLanguage();

  Future<void> setDefaultLanguage(
    String newDefaultLanguage, {
    required Logger logger,
  });

  Future<void> addLanguage({
    required String language,
    required Logger logger,
  });

  Future<void> removeLanguage({
    required String language,
    required Logger logger,
  });

  Bloc bloc({required String name});

  Cubit cubit({required String name});
}

/// Thrown when [L10nFile.readTemplateArbFile] fails to read the `template-arb-file` property.
class ReadTemplateArbFileFailure implements Exception {}

/// {@template l10n_file}
/// Abstraction of the l10n file of a platform customizable feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/l10n.yaml`
/// {@endtemplate}
abstract class L10nFile implements YamlFile {
  /// {@macro l10n_file}
  factory L10nFile({
    required PlatformCustomizableFeaturePackage
        platformCustomizableFeaturePackage,
  }) =>
      L10nFileImpl(
        platformCustomizableFeaturePackage: platformCustomizableFeaturePackage,
      );

  // TODO rename to readTemplateArbFile()

  /// The `template-arb-file` property.
  String readTemplateArbFile();

  void setTemplateArbFile(String newTemplateArbFile);
}

/// {@template language_localizations_file}
/// Abstraction of the localizations file of a specific language of a platform customizable feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/<project name>_<platform>_<feature name>_localizations_<language>.dart`
/// {@endtemplate}
abstract class LanguageLocalizationsFile implements DartFile {
  /// {@macro language_localizations_file}
  factory LanguageLocalizationsFile(
    String language, {
    required PlatformCustomizableFeaturePackage
        platformCustomizableFeaturePackage,
  }) =>
      LanguageLocalizationsFileImpl(
        language,
        platformCustomizableFeaturePackage: platformCustomizableFeaturePackage,
      );
}

/// {@template arb_directory}
/// Abstraction of the arb directory of a platform customizable feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/arb`
/// {@endtemplate}
abstract class ArbDirectory implements Directory {
  /// {@macro arb_directory}
  factory ArbDirectory({
    required PlatformCustomizableFeaturePackage
        platformCustomizableFeaturePackage,
  }) =>
      ArbDirectoryImpl(
        platformCustomizableFeaturePackage: platformCustomizableFeaturePackage,
      );

  PlatformCustomizableFeaturePackage get platformCustomizableFeaturePackage;

  List<LanguageArbFile> languageArbFiles();

  LanguageArbFile languageArbFile({required String language});
}

/// {@template language_arb_file}
/// Abstraction of a arb file for a language of a platform customizable feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/arb/<feature name>_<language>.arb`
/// {@endtemplate}
abstract class LanguageArbFile implements ArbFile {
  /// {@macro language_arb_file}
  factory LanguageArbFile({
    required String language,
    required ArbDirectory arbDirectory,
    GeneratorBuilder? generator,
  }) =>
      LanguageArbFileImpl(
        language: language,
        arbDirectory: arbDirectory,
        generator: generator,
      );

  ArbDirectory get arbDirectory;

  String get language;

  Future<void> create({required Logger logger});

  void addTranslation({
    required String name,
    required String translation,
    required String description,
  });
}

/// {@template bloc}
/// Abstraction of a bloc of a platform custom feature package of a Rapid project.
/// {@endtemplate}
abstract class Bloc implements FileSystemEntityCollection {
  /// {@macro bloc}
  factory Bloc({
    required String name,
    required PlatformCustomizableFeaturePackage
        platformCustomizableFeaturePackage,
    GeneratorBuilder? generator,
  }) =>
      BlocImpl(
        name: name,
        platformCustomizableFeaturePackage: platformCustomizableFeaturePackage,
        generator: generator,
      );

  String get name;

  PlatformCustomizableFeaturePackage get platformCustomizableFeaturePackage;

  Future<void> create({required Logger logger});
}

/// {@template cubit}
/// Abstraction of a cubit of a platform custom feature package of a Rapid project.
/// {@endtemplate}
abstract class Cubit implements FileSystemEntityCollection {
  /// {@macro cubit}
  factory Cubit({
    required String name,
    required PlatformCustomizableFeaturePackage
        platformCustomizableFeaturePackage,
    GeneratorBuilder? generator,
  }) =>
      CubitImpl(
        name: name,
        platformCustomizableFeaturePackage: platformCustomizableFeaturePackage,
        generator: generator,
      );

  String get name;

  PlatformCustomizableFeaturePackage get platformCustomizableFeaturePackage;

  Future<void> create({required Logger logger});
}

/// {@template platform_app_feature_package}
/// Abstraction of a platform app feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_app`
/// {@endtemplate}
abstract class PlatformAppFeaturePackage
    implements PlatformCustomizableFeaturePackage {
  /// {@macro platform_app_feature_package}
  factory PlatformAppFeaturePackage(
    Platform platform, {
    //TODO  should not platform dir be passed instead of project?
    required Project project,
    PubspecFile? pubspecFile,
    L10nFile? l10nFile,
    ArbDirectory? arbDirectory,
    LanguageLocalizationsFileBuilder? languageLocalizationsFile,
    FlutterGenl10nCommand? flutterGenl10n,
    LocalizationsFile? localizationsFile,
    GeneratorBuilder? generator,
  }) =>
      PlatformAppFeaturePackageImpl(
        platform,
        project: project,
        pubspecFile: pubspecFile,
        l10nFile: l10nFile,
        arbDirectory: arbDirectory,
        languageLocalizationsFile: languageLocalizationsFile,
        flutterGenl10n: flutterGenl10n,
        localizationsFile: localizationsFile,
        generator: generator,
      );

  Future<void> create({
    required String defaultLanguage,
    required Set<String> languages,
    required Logger logger,
  });

  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  });

  Future<void> unregisterCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  });
}

/// {@template localizations_file}
/// Abstraction of the localizations file of an app feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_app/lib/src/presentation/localizations.dart`
/// {@endtemplate}
abstract class LocalizationsFile implements DartFile {
  /// {@macro localizations_file}
  factory LocalizationsFile({
    required PlatformAppFeaturePackage platformAppFeaturePackage,
  }) =>
      LocalizationsFileImpl(
        platformAppFeaturePackage: platformAppFeaturePackage,
      );

  PlatformAppFeaturePackage get platformAppFeaturePackage;

  void addLocalizationsDelegate(
    PlatformCustomFeaturePackage customFeaturePackage,
  );

  void removeLocalizationsDelegate(
    PlatformCustomFeaturePackage customFeaturePackage,
  );

  void addSupportedLanguage(String language);

  void removeSupportedLanguage(String language);
}

/// {@template platform_custom_feature_package}
/// Abstraction of a platform custom feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>`
/// {@endtemplate}
abstract class PlatformCustomFeaturePackage
    implements PlatformCustomizableFeaturePackage {
  /// {@macro platform_custom_feature_package}
  factory PlatformCustomFeaturePackage(
    String name,
    Platform platform, {
    required Project project,
    PubspecFile? pubspecFile,
    L10nFile? l10nFile,
    ArbDirectory? arbDirectory,
    LanguageLocalizationsFileBuilder? languageLocalizationsFile,
    FlutterGenl10nCommand? flutterGenl10n,
    GeneratorBuilder? generator,
  }) =>
      PlatformCustomFeaturePackageImpl(
        name,
        platform,
        project: project,
        pubspecFile: pubspecFile,
        l10nFile: l10nFile,
        arbDirectory: arbDirectory,
        languageLocalizationsFile: languageLocalizationsFile,
        flutterGenl10n: flutterGenl10n,
        generator: generator,
      );

  Future<void> create({
    String? description,
    required String defaultLanguage,
    required Set<String> languages,
    required Logger logger,
  });
}
