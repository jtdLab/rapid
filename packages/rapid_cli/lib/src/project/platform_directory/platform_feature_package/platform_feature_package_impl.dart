import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/arb_file_impl.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/file.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file_impl.dart';
import 'package:rapid_cli/src/project/app_package/platform_native_directory/platform_native_directory.dart';
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

abstract class PlatformCustomizableFeaturePackageImpl
    extends PlatformFeaturePackageImpl
    implements PlatformCustomizableFeaturePackage {
  PlatformCustomizableFeaturePackageImpl(
    super.name,
    super.platform, {
    required super.project,
    super.pubspecFile,
    L10nFile? l10nFile,
    ArbDirectory? arbDirectory,
    LanguageLocalizationsFileBuilder? languageLocalizationsFile,
    FlutterGenl10nCommand? flutterGenl10n,
  }) : _flutterGenl10n = flutterGenl10n ?? Flutter.genl10n {
    _l10nFile = l10nFile ?? L10nFile(platformCustomizableFeaturePackage: this);
    _arbDirectory =
        arbDirectory ?? ArbDirectory(platformCustomizableFeaturePackage: this);
    this.languageLocalizationsFile = languageLocalizationsFile ??
        (({required String language}) => LanguageLocalizationsFile(language,
            platformCustomizableFeaturePackage: this));
  }

  late final L10nFile _l10nFile;
  late final ArbDirectory _arbDirectory;
  final FlutterGenl10nCommand _flutterGenl10n;

  @override
  late final LanguageLocalizationsFileBuilder languageLocalizationsFile;

  @override
  Set<String> supportedLanguages() =>
      _arbDirectory.languageArbFiles().map((e) => e.language).toSet();

  @override
  bool supportsLanguage(String language) =>
      supportedLanguages().contains(language);

  @override
  String defaultLanguage() {
    final l10nFile = _l10nFile;
    final templateArbFile = l10nFile.readTemplateArbFile();

    return templateArbFile.split('.').first.split('_').last;
  }

  @override
  Future<void> setDefaultLanguage(
    String newDefaultLanguage, {
    required Logger logger,
  }) async {
    final l10nFile = _l10nFile;
    final templateArbFile = l10nFile.readTemplateArbFile();
    final newTemplateArbFile = templateArbFile.replaceRange(
      templateArbFile.lastIndexOf('_') + 1,
      templateArbFile.lastIndexOf('.arb'),
      newDefaultLanguage,
    );

    l10nFile.setTemplateArbFile(newTemplateArbFile);
    await _flutterGenl10n(cwd: path, logger: logger);
  }

  @override
  Future<void> addLanguage({
    required String language,
    required Logger logger,
  }) async {
    final languageArbFile = _arbDirectory.languageArbFile(language: language);
    if (!languageArbFile.exists()) {
      await languageArbFile.create(logger: logger);

      await _flutterGenl10n(cwd: path, logger: logger);
    }

    if (platform == Platform.ios) {
      final appPackage = project.appPackage;
      final iosNativeDirectory = appPackage.platformNativeDirectory(
        platform: platform,
      ) as IosNativeDirectory;
      final infoPlistFile = iosNativeDirectory.infoPlistFile;
      infoPlistFile.addLanguage(language: language);
    }
  }

  @override
  Future<void> removeLanguage({
    required String language,
    required Logger logger,
  }) async {
    final languageArbFile = _arbDirectory.languageArbFile(language: language);
    if (languageArbFile.exists()) {
      languageArbFile.delete(logger: logger);
    }

    final languageLocalizationsFile =
        this.languageLocalizationsFile(language: language);
    if (languageLocalizationsFile.exists()) {
      languageLocalizationsFile.delete(logger: logger);
    }

    if (platform == Platform.ios) {
      final appPackage = project.appPackage;
      final iosNativeDirectory = appPackage.platformNativeDirectory(
        platform: platform,
      ) as IosNativeDirectory;
      final infoPlistFile = iosNativeDirectory.infoPlistFile;
      infoPlistFile.removeLanguage(language: language);
    }

    await _flutterGenl10n(cwd: path, logger: logger);
  }

  @override
  Bloc bloc({required String name}) => Bloc(
        name: name,
        platformCustomizableFeaturePackage: this,
      );

  @override
  Cubit cubit({required String name}) => Cubit(
        name: name,
        platformCustomizableFeaturePackage: this,
      );
}

class L10nFileImpl extends YamlFileImpl implements L10nFile {
  L10nFileImpl({
    required PlatformFeaturePackage platformCustomizableFeaturePackage,
  }) : super(
          path: platformCustomizableFeaturePackage.path,
          name: 'l10n',
        );

  @override
  String readTemplateArbFile() {
    try {
      return readValue(['template-arb-file']);
    } catch (_) {
      throw ReadTemplateArbFileFailure();
    }
  }

  @override
  void setTemplateArbFile(String newTemplateArbFile) {
    return setValue(['template-arb-file'], newTemplateArbFile);
  }
}

class LanguageLocalizationsFileImpl extends DartFileImpl
    implements LanguageLocalizationsFile {
  LanguageLocalizationsFileImpl(
    String language, {
    required PlatformFeaturePackage platformCustomizableFeaturePackage,
  }) : super(
          path: p.join(
            platformCustomizableFeaturePackage.path,
            'lib',
            'src',
            'presentation',
            'l10n',
          ),
          name:
              '${platformCustomizableFeaturePackage.packageName()}_localizations_$language',
        );
}

class ArbDirectoryImpl extends DirectoryImpl implements ArbDirectory {
  ArbDirectoryImpl({
    required this.platformCustomizableFeaturePackage,
  }) : super(
          path: p.join(
            platformCustomizableFeaturePackage.path,
            'lib',
            'src',
            'presentation',
            'l10n',
            'arb',
          ),
        );

  @override
  final PlatformCustomizableFeaturePackage platformCustomizableFeaturePackage;

  @override
  List<LanguageArbFile> languageArbFiles() {
    try {
      final arbFiles = list()
          .whereType<File>()
          .where((e) => e.extension == 'arb')
          .where((e) => e.name != null)
          .map(
            (e) => LanguageArbFile(
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
  LanguageArbFile languageArbFile({required String language}) =>
      LanguageArbFile(language: language, arbDirectory: this);
}

class LanguageArbFileImpl extends ArbFileImpl implements LanguageArbFile {
  LanguageArbFileImpl({
    required this.language,
    required this.arbDirectory,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: arbDirectory.path,
          name:
              '${arbDirectory.platformCustomizableFeaturePackage.name}_$language',
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
        'feature_name': arbDirectory.platformCustomizableFeaturePackage.name,
        'language': language,
      },
      logger: logger,
    );
  }

  @override
  void addTranslation({
    required String name,
    required String translation,
    required String description,
  }) {
    setValue([name], translation);
    setValue(['@$name'], {'description': description});
  }
}

class BlocImpl extends FileSystemEntityCollection implements Bloc {
  BlocImpl({
    required this.name,
    required this.platformCustomizableFeaturePackage,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.join(
              platformCustomizableFeaturePackage.path,
              'lib',
              'src',
              'application',
              name.snakeCase,
            ),
          ),
          Directory(
            path: p.join(
              platformCustomizableFeaturePackage.path,
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
  final PlatformCustomizableFeaturePackage platformCustomizableFeaturePackage;

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = platformCustomizableFeaturePackage.project.name();
    final platform = platformCustomizableFeaturePackage.platform.name;
    final featureName = platformCustomizableFeaturePackage.name;

    final generator = await _generator(blocBundle);
    await generator.generate(
      DirectoryGeneratorTarget(
          io.Directory(platformCustomizableFeaturePackage.path)),
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
    required this.platformCustomizableFeaturePackage,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.join(
              platformCustomizableFeaturePackage.path,
              'lib',
              'src',
              'application',
              name.snakeCase,
            ),
          ),
          Directory(
            path: p.join(
              platformCustomizableFeaturePackage.path,
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
  final PlatformCustomizableFeaturePackage platformCustomizableFeaturePackage;

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = platformCustomizableFeaturePackage.project.name();
    final platform = platformCustomizableFeaturePackage.platform.name;
    final featureName = platformCustomizableFeaturePackage.name;

    final generator = await _generator(cubitBundle);
    await generator.generate(
      DirectoryGeneratorTarget(
          io.Directory(platformCustomizableFeaturePackage.path)),
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

class PlatformAppFeaturePackageImpl
    extends PlatformCustomizableFeaturePackageImpl
    implements PlatformAppFeaturePackage {
  PlatformAppFeaturePackageImpl(
    Platform platform, {
    //TODO  should not platform dir be passed instead of project?
    required super.project,
    super.pubspecFile,
    super.l10nFile,
    super.arbDirectory,
    super.languageLocalizationsFile,
    super.flutterGenl10n,
    LocalizationsDelegatesFile? localizationsDelegatesFile,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super('app', platform) {
    _localizationsDelegatesFile = localizationsDelegatesFile ??
        LocalizationsDelegatesFile(platformAppFeaturePackage: this);
  }

  late final LocalizationsDelegatesFile _localizationsDelegatesFile;
  final GeneratorBuilder _generator;

  @override
  Future<void> create({
    required String defaultLanguage,
    required Set<String> languages,
    required Logger logger,
  }) async {
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
        'default_language': defaultLanguage,
      },
      logger: logger,
    );

    for (final language in languages) {
      final languageArbFile = _arbDirectory.languageArbFile(language: language);
      await languageArbFile.create(logger: logger);
    }

    await _flutterGenl10n(cwd: path, logger: logger);
  }

  @override
  Future<void> registerCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.setDependency(customFeaturePackage.packageName());
    _localizationsDelegatesFile.addLocalizationsDelegate(customFeaturePackage);
  }

  @override
  Future<void> unregisterCustomFeaturePackage(
    PlatformCustomFeaturePackage customFeaturePackage, {
    required Logger logger,
  }) async {
    pubspecFile.removeDependency(customFeaturePackage.packageName());
    _localizationsDelegatesFile
        .removeLocalizationsDelegate(customFeaturePackage);
  }
}

class LocalizationsDelegatesFileImpl extends DartFileImpl
    implements LocalizationsDelegatesFile {
  LocalizationsDelegatesFileImpl({
    required this.platformAppFeaturePackage,
  }) : super(
          path: p.join(
            platformAppFeaturePackage.path,
            'lib',
            'src',
            'presentation',
          ),
          name: 'localizations_delegates',
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
}

class PlatformCustomFeaturePackageImpl
    extends PlatformCustomizableFeaturePackageImpl
    implements PlatformCustomFeaturePackage {
  PlatformCustomFeaturePackageImpl(
    super.name,
    super.platform, {
    required super.project,
    super.pubspecFile,
    super.l10nFile,
    super.arbDirectory,
    super.languageLocalizationsFile,
    super.flutterGenl10n,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle;

  final GeneratorBuilder _generator;

  @override
  Future<void> create({
    String? description,
    required String defaultLanguage,
    required Set<String> languages,
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
        'default_language': defaultLanguage,
      },
      logger: logger,
    );

    for (final language in languages) {
      final languageArbFile = _arbDirectory.languageArbFile(language: language);
      await languageArbFile.create(logger: logger);
      languageArbFile.addTranslation(
        name: 'title',
        translation: '${name.titleCase} title for $language',
        description: 'Title text shown in the ${name.titleCase}',
      );
    }

    await _flutterGenl10n(cwd: path, logger: logger); // TODO test
  }
}
