import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file.dart';
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

/// {@template platform_app_feature_package}
/// Abstraction of a platform app feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_app`
/// {@endtemplate}
abstract class PlatformAppFeaturePackage implements PlatformFeaturePackage {
  /// {@macro platform_app_feature_package}
  factory PlatformAppFeaturePackage(
    Platform platform, {
    //TODO  should not platform dir be passed instead of project?
    required Project project,
    PubspecFile? pubspecFile,
    LocalizationsFile? localizationsFile,
    GeneratorBuilder? generator,
  }) =>
      PlatformAppFeaturePackageImpl(
        platform,
        project: project,
        pubspecFile: pubspecFile,
        localizationsFile: localizationsFile,
        generator: generator,
      );

  late LocalizationsFile localizationsFile;

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

/// {@template platform_custom_feature_package}
/// Abstraction of a platform custom feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>`
/// {@endtemplate}
abstract class PlatformCustomFeaturePackage implements PlatformFeaturePackage {
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

  LanguageLocalizationsFileBuilder get languageLocalizationsFile;

  Set<String> supportedLanguages();

  bool supportsLanguage(String language);

  String defaultLanguage();

  Future<void> create({
    String? description,
    required Logger logger,
  });

  Bloc bloc({required String name});

  Cubit cubit({required String name});

  Future<void> addLanguage({
    required String language,
    required Logger logger,
  });

  Future<void> removeLanguage({
    required String language,
    required Logger logger,
  });
}

/// Thrown when [L10nFile.templateArbFile] fails to read the `template-arb-file` property.
class ReadTemplateArbFileFailure implements Exception {}

/// {@template l10n_file}
/// Abstraction of the l10n file of a platform custom feature package of an existing Rapid project.
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
  String templateArbFile();
}

/// {@template language_localizations_file}
// TODO doc update
/// Abstraction of the l10n file of a platform custom feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/l10n.yaml`
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

/// {@template arb_directory}
/// Abstraction of the arb directory of a platform custom feature package of a Rapid project.
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

  PlatformFeaturePackage get platformFeaturePackage;

  List<ArbFile> arbFiles();

  ArbFile arbFile({required String language});
}

/// {@template arb_file}
/// Abstraction of a arb file of a platform custom feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/arb/<feature name>_<language>.arb`
/// {@endtemplate}
abstract class ArbFile implements File {
  /// {@macro arb_file}
  factory ArbFile({
    required String language,
    required ArbDirectory arbDirectory,
    GeneratorBuilder? generator,
  }) =>
      ArbFileImpl(
        language: language,
        arbDirectory: arbDirectory,
        generator: generator,
      );

  ArbDirectory get arbDirectory;

  String get language;

  Future<void> create({required Logger logger});
}

/// {@template bloc}
/// Abstraction of a bloc of a platform custom feature package of a Rapid project.
/// {@endtemplate}
abstract class Bloc implements FileSystemEntityCollection {
  /// {@macro bloc}
  factory Bloc({
    required String name,
    required PlatformFeaturePackage platformFeaturePackage,
    GeneratorBuilder? generator,
  }) =>
      BlocImpl(
        name: name,
        platformFeaturePackage: platformFeaturePackage,
        generator: generator,
      );

  String get name;

  PlatformFeaturePackage get platformFeaturePackage;

  Future<void> create({required Logger logger});
}

/// {@template cubit}
/// Abstraction of a cubit of a platform custom feature package of a Rapid project.
/// {@endtemplate}
abstract class Cubit implements FileSystemEntityCollection {
  /// {@macro cubit}
  factory Cubit({
    required String name,
    required PlatformFeaturePackage platformFeaturePackage,
    GeneratorBuilder? generator,
  }) =>
      CubitImpl(
        name: name,
        platformFeaturePackage: platformFeaturePackage,
        generator: generator,
      );

  String get name;

  PlatformFeaturePackage get platformFeaturePackage;

  Future<void> create({required Logger logger});
}
