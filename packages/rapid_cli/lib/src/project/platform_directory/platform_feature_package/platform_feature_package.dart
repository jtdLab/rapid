import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_feature_package/bloc_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'cubit_bundle.dart';
import 'platform_app_feature_package_bundle.dart';
import 'platform_custom_feature_package_bundle.dart';
import 'platform_routing_feature_package_bundle.dart';

/// {@template platform_feature_package}
/// Base class of a platform feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>`
/// {@endtemplate}
abstract class PlatformFeaturePackage extends ProjectPackage {
  /// {@macro platform_feature_package}
  PlatformFeaturePackage(
    this.name,
    this.platform, {
    required this.project,
  });

  final Project project;

  final String name;
  final Platform platform;

  @override
  String get path => p.join(
        project.path,
        'packages',
        project.name(),
        '${project.name()}_${platform.name}',
        '${project.name()}_${platform.name}_$name',
      );
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
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super('app', platform) {
    localizationsFile = LocalizationsFile(platformAppFeaturePackage: this);
  }

  final GeneratorBuilder _generator;

  late LocalizationsFile localizationsFile;

  Future<void> create({required Logger logger}) async {
    final projectName = project.name();

    final generator = await _generator(platformAppFeaturePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
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

class LocalizationsFile extends ProjectEntity {
  LocalizationsFile({
    required this.platformAppFeaturePackage,
  }) : _dartFile = DartFile(
          path: p.join(
            platformAppFeaturePackage.path,
            'lib',
            'src',
            'presentation',
          ),
          name: 'localizations',
        );

  final DartFile _dartFile;

  final PlatformAppFeaturePackage platformAppFeaturePackage;

  @override
  String get path => _dartFile.path;

  @override
  bool exists() => _dartFile.exists();

  void addLocalizationsDelegate(
    PlatformCustomFeaturePackage customFeaturePackage,
  ) {
    final packageName = customFeaturePackage.packageName();
    _dartFile.addImport('package:$packageName/$packageName.dart');

    final newDelegate = '${packageName.pascalCase}Localizations.delegate';
    final existingDelegates =
        _dartFile.readTopLevelIterableVar(name: 'localizationsDelegates');

    if (!existingDelegates.contains(newDelegate)) {
      _dartFile.setTopLevelIterableVar(
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
    _dartFile.removeImport('package:$packageName/$packageName.dart');

    final delegate = '${packageName.pascalCase}Localizations.delegate';
    final existingDelegates =
        _dartFile.readTopLevelIterableVar(name: 'localizationsDelegates');

    if (existingDelegates.contains(delegate)) {
      _dartFile.setTopLevelIterableVar(
        name: 'localizationsDelegates',
        value: existingDelegates..remove(delegate),
      );
    }
  }

  void addSupportedLanguage(String language) {
    final locale = 'Locale($language)';
    final existingLocales =
        _dartFile.readTopLevelIterableVar(name: 'supportedLocales');

    if (!existingLocales.contains(locale)) {
      _dartFile.setTopLevelIterableVar(
        name: 'supportedLocales',
        value: [locale, ...existingLocales],
      );
    }
  }

  void removeSupportedLanguage(String language) {
    final locale = 'Locale($language)';
    final existingLocales =
        _dartFile.readTopLevelIterableVar(name: 'supportedLocales');

    if (existingLocales.contains(locale)) {
      _dartFile.setTopLevelIterableVar(
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
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super('routing', platform);

  final GeneratorBuilder _generator;

  Future<void> create({required Logger logger}) async {
    final projectName = project.name();

    final generator = await _generator(platformRoutingFeaturePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
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

  Future<void> registerFeature({
    required PlatformCustomFeaturePackage feature,
    required Logger logger,
  }) async {
    pubspecFile.setDependency(feature.packageName());
  }

  Future<void> unregisterFeature({
    required PlatformCustomFeaturePackage feature,
    required Logger logger,
  }) async {
    pubspecFile.removeDependency(feature.packageName());
  }
}

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
    FlutterGenl10nCommand? flutterGenl10n,
    GeneratorBuilder? generator,
  })  : _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _generator = generator ?? MasonGenerator.fromBundle {
    _l10nFile = L10nFile(platformFeaturePackage: this);
    _arbDirectory = ArbDirectory(platformFeaturePackage: this);
  }

  late final L10nFile _l10nFile;
  late final ArbDirectory _arbDirectory;
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
      DirectoryGeneratorTarget(Directory(path)),
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
    }
    await _flutterGenl10n(cwd: path, logger: logger);
  }

  Future<void> removeLanguage({
    required String language,
    required Logger logger,
  }) async {
    final arbFile = _arbDirectory.arbFile(language: language);
    if (arbFile.exists()) {
      arbFile.delete();
    }

    // TODO maybe manualy delete old generated dart files

    await _flutterGenl10n(cwd: path, logger: logger);
  }
}

/// Thrown when [L10nFile.templateArbFile] fails to read the `template-arb-file` property.
class ReadTemplateArbFileFailure implements Exception {}

/// {@template l10n_file}
/// Abstraction of the l10n file of a platform custom feature package of an existing Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/l10n.yaml`
/// {@endtemplate}
class L10nFile extends ProjectEntity {
  /// {@macro l10n_file}
  L10nFile({
    required PlatformFeaturePackage platformFeaturePackage,
  }) : _yamlFile = YamlFile(path: platformFeaturePackage.path, name: 'l10n');

  /// The underlying yaml file.
  final YamlFile _yamlFile;

  @override
  String get path => _yamlFile.path;

  @override
  bool exists() => _yamlFile.exists();

  /// The `template-arb-file` property.
  String templateArbFile() {
    try {
      return _yamlFile.readValue(['template-arb-file']);
    } catch (_) {
      throw ReadTemplateArbFileFailure();
    }
  }
}

/// {@template arb_directory}
/// Abstraction of the arb directory of a platform custom feature package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_<platform>/<project name>_<platform>_<feature name>/lib/src/presentation/l10n/arb`
/// {@endtemplate}
class ArbDirectory extends ProjectDirectory {
  /// {@macro arb_directory}
  ArbDirectory({
    required this.platformFeaturePackage,
  });

  final PlatformFeaturePackage platformFeaturePackage;

  @override
  String get path => p.join(
        platformFeaturePackage.path,
        'lib',
        'src',
        'presentation',
        'l10n',
        'arb',
      );

  List<ArbFile> arbFiles() {
    final arbFiles = directory
        .listSync()
        .whereType<File>()
        .where((e) => e.path.endsWith('.arb'))
        .map(
          (e) => ArbFile(
            language: e.path.split('.').first.split('_').last,
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
class ArbFile extends ProjectEntity {
  /// {@macro arb_file}
  ArbFile({
    required this.language,
    required this.arbDirectory,
  }) : _file = File(
          p.join(
            arbDirectory.path,
            '${arbDirectory.platformFeaturePackage.name}_$language.arb',
          ),
        );

  final File _file;

  final ArbDirectory arbDirectory;
  final String language;

  @override
  String get path => _file.path;

  @override
  bool exists() => _file.existsSync();

  Future<void> create({required Logger logger}) async {
    _file.createSync(recursive: true);
    _file.writeAsStringSync('''
{
  "@@locale": "$language"
}''');
  }

  void delete() => _file.deleteSync(recursive: true); // TODO logger ?
}

/// {@template bloc}
/// Abstraction of a bloc of a platform custom feature package of a Rapid project.
/// {@endtemplate}
class Bloc {
  /// {@macro bloc}
  Bloc({
    required this.name,
    required this.platformFeaturePackage,
    GeneratorBuilder? generator,
  })  : _blocDirectory = Directory(
          p.join(
            platformFeaturePackage.path,
            'lib',
            'src',
            'application',
            name,
          ),
        ),
        _blocTestDirectory = Directory(
          p.join(
            platformFeaturePackage.path,
            'test',
            'src',
            'application',
            name,
          ),
        ),
        _generator = generator ?? MasonGenerator.fromBundle;

  final Directory _blocDirectory;
  final Directory _blocTestDirectory;
  final GeneratorBuilder _generator;

  final String name;
  final PlatformFeaturePackage platformFeaturePackage;

  bool exists() =>
      _blocDirectory.existsSync() || _blocTestDirectory.existsSync();

  Future<void> create({required Logger logger}) async {
    final projectName = platformFeaturePackage.project.name();

    final generator = await _generator(blocBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(platformFeaturePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platformFeaturePackage.platform.name,
      },
      logger: logger,
    );
  }

  void delete() {
    _blocDirectory.deleteSync(recursive: true);
    _blocTestDirectory.deleteSync(recursive: true);
  }
}

/// {@template cubit}
/// Abstraction of a cubit of a platform custom feature package of a Rapid project.
/// {@endtemplate}
class Cubit {
  /// {@macro cubit}
  Cubit({
    required this.name,
    required this.platformFeaturePackage,
    GeneratorBuilder? generator,
  })  : _cubitDirectory = Directory(
          p.join(
            platformFeaturePackage.path,
            'lib',
            'src',
            'application',
            name,
          ),
        ),
        _cubitTestDirectory = Directory(
          p.join(
            platformFeaturePackage.path,
            'test',
            'src',
            'application',
            name,
          ),
        ),
        _generator = generator ?? MasonGenerator.fromBundle;

  final Directory _cubitDirectory;
  final Directory _cubitTestDirectory;
  final GeneratorBuilder _generator;

  final String name;
  final PlatformFeaturePackage platformFeaturePackage;

  bool exists() =>
      _cubitDirectory.existsSync() || _cubitTestDirectory.existsSync();

  Future<void> create({required Logger logger}) async {
    final projectName = platformFeaturePackage.project.name();

    final generator = await _generator(cubitBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(platformFeaturePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'platform': platformFeaturePackage.platform.name,
      },
      logger: logger,
    );
  }

  void delete() {
    _cubitDirectory.deleteSync(recursive: true);
    _cubitTestDirectory.deleteSync(recursive: true);
  }
}
