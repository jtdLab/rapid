import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/file.dart';
import 'package:rapid_cli/src/core/file_impl.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'arb_file_bundle.dart';
import 'bloc_bundle.dart';
import 'cubit_bundle.dart';
import 'platform_app_feature_package_bundle.dart';
import 'platform_custom_feature_package_bundle.dart';
import 'platform_feature_package.dart';
import 'platform_routing_feature_package_bundle.dart';

abstract class PlatformFeaturePackageImpl extends DartPackageImpl
    implements PlatformFeaturePackage {
  PlatformFeaturePackageImpl(
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

  @override
  final Project project;

  @override
  final String name;

  @override
  final Platform platform;
}

class PlatformAppFeaturePackageImpl extends PlatformFeaturePackageImpl
    implements PlatformAppFeaturePackage {
  PlatformAppFeaturePackageImpl(
    Platform platform, {
    required super.project, //TODO  should not platform dir be passed instead of project?
    super.pubspecFile,
    LocalizationsFile? localizationsFile,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super('app', platform) {
    this.localizationsFile =
        localizationsFile ?? LocalizationsFile(platformAppFeaturePackage: this);
  }

  final GeneratorBuilder _generator;

  @override
  late LocalizationsFile localizationsFile;

  @override
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

  @override
  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.setDependency(customFeaturePackage.packageName());
    localizationsFile.addLocalizationsDelegate(customFeaturePackage);
  }

  @override
  Future<void> unregisterCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.removeDependency(customFeaturePackage.packageName());
    localizationsFile.removeLocalizationsDelegate(customFeaturePackage);
  }
}

class LocalizationsFileImpl extends DartFileImpl implements LocalizationsFile {
  LocalizationsFileImpl({
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

  @override
  final PlatformAppFeaturePackage platformAppFeaturePackage;

  @override
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
        ]..sort(),
      );
    }
  }

  @override
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

  @override
  void addSupportedLanguage(String language) {
    final locale = 'Locale(\'$language\')';
    final existingLocales = readTopLevelListVar(name: 'supportedLocales');

    if (!existingLocales.contains(locale)) {
      setTopLevelListVar(
        name: 'supportedLocales',
        value: [locale, ...existingLocales]..sort(),
      );
    }
  }

  @override
  void removeSupportedLanguage(String language) {
    final locale = 'Locale(\'$language\')';
    final existingLocales = readTopLevelListVar(name: 'supportedLocales');

    if (existingLocales.contains(locale)) {
      setTopLevelListVar(
        name: 'supportedLocales',
        value: existingLocales..remove(locale),
      );
    }
  }
}

class PlatformRoutingFeaturePackageImpl extends PlatformFeaturePackageImpl
    implements PlatformRoutingFeaturePackage {
  PlatformRoutingFeaturePackageImpl(
    Platform platform, {
    required super.project,
    super.pubspecFile,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super('routing', platform);

  final GeneratorBuilder _generator;

  @override
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

  @override
  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.setDependency(customFeaturePackage.packageName());
  }

  @override
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

class PlatformCustomFeaturePackageImpl extends PlatformFeaturePackageImpl
    implements PlatformCustomFeaturePackage {
  PlatformCustomFeaturePackageImpl(
    super.name,
    super.platform, {
    required super.project,
    super.pubspecFile,
    L10nFile? l10nFile,
    ArbDirectory? arbDirectory,
    LanguageLocalizationsFileBuilder? languageLocalizationsFile,
    FlutterGenl10nCommand? flutterGenl10n,
    GeneratorBuilder? generator,
  })  : _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n,
        _generator = generator ?? MasonGenerator.fromBundle {
    _l10nFile = l10nFile ?? L10nFile(platformFeaturePackage: this);
    _arbDirectory = arbDirectory ?? ArbDirectory(platformFeaturePackage: this);
    this.languageLocalizationsFile = languageLocalizationsFile ??
        (({required String language}) =>
            LanguageLocalizationsFile(language, platformFeaturePackage: this));
  }

  late final L10nFile _l10nFile;
  late final ArbDirectory _arbDirectory;
  final FlutterGenl10nCommand _flutterGenl10n;
  final GeneratorBuilder _generator;

  @override
  late final LanguageLocalizationsFileBuilder languageLocalizationsFile;

  @override
  Set<String> supportedLanguages() =>
      _arbDirectory.arbFiles().map((e) => e.language).toSet();

  @override
  bool supportsLanguage(String language) =>
      supportedLanguages().contains(language);

  @override
  String defaultLanguage() {
    final l10nFile = _l10nFile;
    final templateArbFile = l10nFile.templateArbFile();

    return templateArbFile.split('.').first.split('_').last;
  }

  @override
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

  @override
  Bloc bloc({required String name}) => Bloc(
        name: name,
        platformFeaturePackage: this,
      );

  @override
  Cubit cubit({required String name}) => Cubit(
        name: name,
        platformFeaturePackage: this,
      );

  @override
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

  @override
  Future<void> removeLanguage({
    required String language,
    required Logger logger,
  }) async {
    final arbFile = _arbDirectory.arbFile(language: language);
    if (arbFile.exists()) {
      arbFile.delete(logger: logger);

      final languageLocalizationsFile =
          this.languageLocalizationsFile(language: language);
      if (languageLocalizationsFile.exists()) {
        languageLocalizationsFile.delete(logger: logger);
      }
    }
  }
}

class L10nFileImpl extends YamlFileImpl implements L10nFile {
  L10nFileImpl({
    required PlatformFeaturePackage platformFeaturePackage,
  }) : super(
          path: platformFeaturePackage.path,
          name: 'l10n',
        );

  /// The `template-arb-file` property.
  @override
  String templateArbFile() {
    try {
      return readValue(['template-arb-file']);
    } catch (_) {
      throw ReadTemplateArbFileFailure();
    }
  }
}

class LanguageLocalizationsFileImpl extends DartFileImpl
    implements LanguageLocalizationsFile {
  LanguageLocalizationsFileImpl(
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

class ArbDirectoryImpl extends DirectoryImpl implements ArbDirectory {
  ArbDirectoryImpl({
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

  @override
  final PlatformFeaturePackage platformFeaturePackage;

  @override
  List<ArbFile> arbFiles() {
    try {
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
    } catch (_) {
      return [];
    }
  }

  @override
  ArbFile arbFile({required String language}) =>
      ArbFile(language: language, arbDirectory: this);
}

class ArbFileImpl extends FileImpl implements ArbFile {
  ArbFileImpl({
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

  @override
  final ArbDirectory arbDirectory;

  @override
  final String language;

  @override
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

class BlocImpl extends FileSystemEntityCollection implements Bloc {
  BlocImpl({
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
              name.snakeCase,
            ),
          ),
          Directory(
            path: p.join(
              platformFeaturePackage.path,
              'test',
              'src',
              'application',
              name.snakeCase,
            ),
          ),
        ]);

  final GeneratorBuilder _generator;

  @override
  final String name;

  @override
  final PlatformFeaturePackage platformFeaturePackage;

  @override
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

class CubitImpl extends FileSystemEntityCollection implements Cubit {
  CubitImpl({
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
              name.snakeCase,
            ),
          ),
          Directory(
            path: p.join(
              platformFeaturePackage.path,
              'test',
              'src',
              'application',
              name.snakeCase,
            ),
          ),
        ]);

  final GeneratorBuilder _generator;

  @override
  final String name;

  @override
  final PlatformFeaturePackage platformFeaturePackage;

  @override
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
