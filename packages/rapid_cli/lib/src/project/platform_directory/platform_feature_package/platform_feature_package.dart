import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
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

import 'arb_file_bundle.dart';
import 'bloc_bundle.dart';
import 'cubit_bundle.dart';
import 'platform_app_feature_package_bundle.dart';
import 'platform_custom_feature_package_bundle.dart';
import 'platform_routing_feature_package_bundle.dart';

/// {@template platform_feature_package}
/// Base class of a platform feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>`
/// {@endtemplate}
abstract class PlatformFeaturePackage extends DartPackage {
  /// {@macro platform_feature_package}
  PlatformFeaturePackage(
    this.name,
    this.platform, {
    required this.project,
    super.pubspecFile,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
            '${project.name()}_${platform.name}_$name',
          ),
        );

  final Project project;

  final String name;
  final Platform platform;
}

/// {@template platform_app_feature_package}
/// Abstraction of a platform app feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_app`
/// {@endtemplate}
class PlatformAppFeaturePackage extends PlatformFeaturePackage {
  /// {@macro platform_app_feature_package}
  PlatformAppFeaturePackage(
    Platform platform, {
    required super.project,
    super.pubspecFile,
    LocalizationsFile? localizationsFile,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super('app', platform) {
    this.localizationsFile =
        localizationsFile ?? LocalizationsFile(platformAppFeaturePackage: this);
  }

  final GeneratorBuilder _generator;

  late LocalizationsFile localizationsFile;

  Future<void> create({required Logger logger}) async {
    final projectName = project.name();

    final generator = await _generator(platformAppFeaturePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'android': platform == Platform.android,
        'ios': platform == Platform.ios,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
      },
      logger: logger,
    );
  }

  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.setDependency(customFeaturePackage.packageName());
    localizationsFile.addLocalizationsDelegate(customFeaturePackage);
  }

  Future<void> unregisterCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.removeDependency(customFeaturePackage.packageName());
    localizationsFile.removeLocalizationsDelegate(customFeaturePackage);
  }
}

class LocalizationsFile extends DartFile {
  LocalizationsFile({
    required this.platformAppFeaturePackage,
  }) : super(
          path: p.join(
            platformAppFeaturePackage.path,
            'lib',
            'src',
            'presentation',
          ),
          name: 'localizations',
        );

  final PlatformAppFeaturePackage platformAppFeaturePackage;

  void addLocalizationsDelegate(
    PlatformCustomFeaturePackage customFeaturePackage,
  ) {
    final packageName = customFeaturePackage.packageName();
    addImport('package:$packageName/$packageName.dart');

    final newDelegate = '${packageName.pascalCase}Localizations.delegate';
    final existingDelegates =
        readTopLevelListVar(name: 'localizationsDelegates');

    if (!existingDelegates.contains(newDelegate)) {
      setTopLevelListVar(
        name: 'localizationsDelegates',
        value: [
          newDelegate,
          ...existingDelegates,
        ],
      );
    }
  }

  void removeLocalizationsDelegate(
    PlatformCustomFeaturePackage customFeaturePackage,
  ) {
    final packageName = customFeaturePackage.packageName();
    removeImport('package:$packageName/$packageName.dart');

    final delegate = '${packageName.pascalCase}Localizations.delegate';
    final existingDelegates =
        readTopLevelListVar(name: 'localizationsDelegates');

    if (existingDelegates.contains(delegate)) {
      setTopLevelListVar(
        name: 'localizationsDelegates',
        value: existingDelegates..remove(delegate),
      );
    }
  }

  void addSupportedLanguage(String language) {
    final locale = 'Locale($language)';
    final existingLocales = readTopLevelListVar(name: 'supportedLocales');

    if (!existingLocales.contains(locale)) {
      setTopLevelListVar(
        name: 'supportedLocales',
        value: [locale, ...existingLocales],
      );
    }
  }

  void removeSupportedLanguage(String language) {
    final locale = 'Locale($language)';
    final existingLocales = readTopLevelListVar(name: 'supportedLocales');

    if (existingLocales.contains(locale)) {
      setTopLevelListVar(
        name: 'supportedLocales',
        value: existingLocales..remove(locale),
      );
    }
  }
}

/// {@template platform_routing_feature_package}
/// Abstraction of a platform routing feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_routing`
/// {@endtemplate}
class PlatformRoutingFeaturePackage extends PlatformFeaturePackage {
  /// {@macro platform_routing_feature_package}
  PlatformRoutingFeaturePackage(
    Platform platform, {
    required super.project,
    super.pubspecFile,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super('routing', platform);

  final GeneratorBuilder _generator;

  Future<void> create({required Logger logger}) async {
    final projectName = project.name();

    final generator = await _generator(platformRoutingFeaturePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'android': platform == Platform.android,
        'ios': platform == Platform.ios,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
      },
      logger: logger,
    );
  }

  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.setDependency(customFeaturePackage.packageName());
  }

  Future<void> unregisterCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.removeDependency(customFeaturePackage.packageName());
  }
}

typedef LanguageLocalizationsFileBuilder = LanguageLocalizationsFile Function({
  required String language,
});

/// {@template platform_custom_feature_package}
/// Abstraction of a platform custom feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>`
/// {@endtemplate}
class PlatformCustomFeaturePackage extends PlatformFeaturePackage {
  /// {@macro platform_custom_feature_package}
  PlatformCustomFeaturePackage(
    super.name,
    super.platform, {
    required super.project,
    L10nFile? l10nFile,
    ArbDirectory? arbDirectory,
    LanguageLocalizationsFileBuilder? languageLocalizationsFile,
    FlutterGenl10nCommand? flutterGenl10n,
    GeneratorBuilder? generator,
  })  : _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _generator = generator ?? MasonGenerator.fromBundle {
    _l10nFile = l10nFile ?? L10nFile(platformFeaturePackage: this);
    _arbDirectory = arbDirectory ?? ArbDirectory(platformFeaturePackage: this);
    _languageLocalizationsFile = languageLocalizationsFile ??
        (({required String language}) =>
            LanguageLocalizationsFile(language, platformFeaturePackage: this));
  }

  late final L10nFile _l10nFile;
  late final ArbDirectory _arbDirectory;
  late final LanguageLocalizationsFileBuilder _languageLocalizationsFile;
  final FlutterGenl10nCommand _flutterGenl10n;
  final GeneratorBuilder _generator;

  Set<String> supportedLanguages() =>
      _arbDirectory.arbFiles().map((e) => e.language).toSet();

  bool supportsLanguage(String language) =>
      supportedLanguages().contains(language);

  String defaultLanguage() {
    final l10nFile = _l10nFile;
    final templateArbFile = l10nFile.templateArbFile();

    return templateArbFile.split('.').first.split('_').last;
  }

  Future<void> create({
    String? description,
    required Logger logger,
  }) async {
    final projectName = project.name();

    final generator = await _generator(platformCustomFeaturePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: <String, dynamic>{
        'name': name,
        'description': description ?? 'The ${name.titleCase} feature',
        'project_name': projectName,
        'android': platform == Platform.android,
        'ios': platform == Platform.ios,
        'linux': platform == Platform.linux,
        'macos': platform == Platform.macos,
        'web': platform == Platform.web,
        'windows': platform == Platform.windows,
      },
      logger: logger,
    );
  }

  Bloc bloc({required String name}) => Bloc(
        name: name,
        platformFeaturePackage: this,
      );

  Cubit cubit({required String name}) => Cubit(
        name: name,
        platformFeaturePackage: this,
      );

  Future<void> addLanguage({
    required String language,
    required Logger logger,
  }) async {
    final arbFile = _arbDirectory.arbFile(language: language);
    if (!arbFile.exists()) {
      await arbFile.create(logger: logger);
      await _flutterGenl10n(cwd: path, logger: logger);
    }
  }

  Future<void> removeLanguage({
    required String language,
    required Logger logger,
  }) async {
    final arbFile = _arbDirectory.arbFile(language: language);
    if (arbFile.exists()) {
      arbFile.delete(logger: logger);

      final languageLocalizationsFile =
          _languageLocalizationsFile(language: language);
      if (languageLocalizationsFile.exists()) {
        languageLocalizationsFile.delete(logger: logger);
      }
    }
  }
}

/// Thrown when [L10nFile.templateArbFile] fails to read the `template-arb-file` property.
class ReadTemplateArbFileFailure implements Exception {}

/// {@template l10n_file}
/// Abstraction of the l10n file of a platform custom feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/l10n.yaml`
/// {@endtemplate}
class L10nFile extends YamlFile {
  /// {@macro l10n_file}
  L10nFile({
    required PlatformFeaturePackage platformFeaturePackage,
  }) : super(
          path: platformFeaturePackage.path,
          name: 'l10n',
        );

  /// The `template-arb-file` property.
  String templateArbFile() {
    try {
      return readValue(['template-arb-file']);
    } catch (_) {
      throw ReadTemplateArbFileFailure();
    }
  }
}

/// {@template language_localizations_file}
// TODO doc update
/// Abstraction of the l10n file of a platform custom feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/l10n.yaml`
/// {@endtemplate}
class LanguageLocalizationsFile extends DartFile {
  /// {@macro language_localizations_file}
  LanguageLocalizationsFile(
    String language, {
    required PlatformFeaturePackage platformFeaturePackage,
  }) : super(
          path: p.join(
            platformFeaturePackage.path,
            'lib',
            'src',
            'presentation',
            'l10n',
          ),
          name:
              '${platformFeaturePackage.packageName()}_localizations_$language',
        );
}

/// {@template arb_directory}
/// Abstraction of the arb directory of a platform custom feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/arb`
/// {@endtemplate}
class ArbDirectory extends Directory {
  /// {@macro arb_directory}
  ArbDirectory({
    required this.platformFeaturePackage,
  }) : super(
          path: p.join(
            platformFeaturePackage.path,
            'lib',
            'src',
            'presentation',
            'l10n',
            'arb',
          ),
        );

  final PlatformFeaturePackage platformFeaturePackage;

  List<ArbFile> arbFiles() {
    final arbFiles = list()
        .whereType<File>()
        .where((e) => e.extension == 'arb')
        .where((e) => e.name != null)
        .map(
          (e) => ArbFile(
            language: e.name!.split('_').last,
            arbDirectory: this,
          ),
        )
        .toList();
    arbFiles.sort((a, b) => a.language.compareTo(b.language));

    return arbFiles;
  }

  ArbFile arbFile({required String language}) =>
      ArbFile(language: language, arbDirectory: this);
}

/// {@template arb_file}
/// Abstraction of a arb file of a platform custom feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/arb/<feature name>_<language>.arb`
/// {@endtemplate}
class ArbFile extends File {
  /// {@macro arb_file}
  ArbFile({
    required this.language,
    required this.arbDirectory,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: arbDirectory.path,
          name: '${arbDirectory.platformFeaturePackage.name}_$language',
          extension: 'arb',
        );

  final GeneratorBuilder _generator;

  final ArbDirectory arbDirectory;
  final String language;

  Future<void> create({required Logger logger}) async {
    final generator = await _generator(arbFileBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(arbDirectory.path)),
      vars: <String, dynamic>{
        'feature_name': arbDirectory.platformFeaturePackage.name,
        'language': language,
      },
      logger: logger,
    );
  }
}

/// {@template bloc}
/// Abstraction of a bloc of a platform custom feature package of a Rapid project.
/// {@endtemplate}
class Bloc extends FileSystemEntityCollection {
  /// {@macro bloc}
  Bloc({
    required this.name,
    required this.platformFeaturePackage,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              name,
            ),
          ),
          Directory(
            path: p.join(
              platformFeaturePackage.path,
              'test',
              'src',
              'application',
              name,
            ),
          ),
        ]);

  final GeneratorBuilder _generator;

  final String name;
  final PlatformFeaturePackage platformFeaturePackage;

  Future<void> create({required Logger logger}) async {
    final projectName = platformFeaturePackage.project.name();
    final platform = platformFeaturePackage.platform.name;
    final featureName = platformFeaturePackage.name;

    final generator = await _generator(blocBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(platformFeaturePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platform,
        'feature_name': featureName,
      },
      logger: logger,
    );
  }
}

/// {@template cubit}
/// Abstraction of a cubit of a platform custom feature package of a Rapid project.
/// {@endtemplate}
class Cubit extends FileSystemEntityCollection {
  /// {@macro cubit}
  Cubit({
    required this.name,
    required this.platformFeaturePackage,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              name,
            ),
          ),
          Directory(
            path: p.join(
              platformFeaturePackage.path,
              'test',
              'src',
              'application',
              name,
            ),
          ),
        ]);

  final GeneratorBuilder _generator;

  final String name;
  final PlatformFeaturePackage platformFeaturePackage;

  Future<void> create({required Logger logger}) async {
    final projectName = platformFeaturePackage.project.name();
    final platform = platformFeaturePackage.platform.name;
    final featureName = platformFeaturePackage.name;

    final generator = await _generator(cubitBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(platformFeaturePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platform,
        'feature_name': featureName,
      },
      logger: logger,
    );
  }
}
