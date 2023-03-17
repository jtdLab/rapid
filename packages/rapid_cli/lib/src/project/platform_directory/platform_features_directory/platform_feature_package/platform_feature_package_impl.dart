import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/arb_file_impl.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/file.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'arb_file_bundle.dart';
import 'bloc_bundle.dart';
import 'cubit_bundle.dart';
import 'platform_app_feature_package_bundle.dart';
import 'platform_feature_package.dart';
import 'platform_feature_package_bundle.dart';

class PlatformFeaturePackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements PlatformFeaturePackage {
  PlatformFeaturePackageImpl(
    this.name,
    this.platform, {
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
            '${project.name()}_${platform.name}_features',
            '${project.name()}_${platform.name}_$name',
          ),
        );

  L10nFile get _l10nFile =>
      (l10nFileOverrides ?? L10nFile.new)(platformFeaturePackage: this);
  ArbDirectory get _arbDirectory => (arbDirectoryOverrides ?? ArbDirectory.new)(
        platformFeaturePackage: this,
      );

  LanguageLocalizationsFile _languageLocalizationsFile(String language) =>
      (languageLocalizationsFileOverrides ?? LanguageLocalizationsFile.new)(
        language,
        platformFeaturePackage: this,
      );

  Bloc _bloc({required String name}) =>
      (blocOverrides ?? Bloc.new)(name: name, platformFeaturePackage: this);

  Cubit _cubit({required String name}) =>
      (cubitOverrides ?? Cubit.new)(name: name, platformFeaturePackage: this);

  @override
  L10nFileBuilder? l10nFileOverrides;

  @override
  LanguageLocalizationsFileBuilder? languageLocalizationsFileOverrides;

  @override
  ArbDirectoryBuilder? arbDirectoryOverrides;

  @override
  BlocBuilder? blocOverrides;

  @override
  CubitBuilder? cubitOverrides;

  @override
  final String name;

  @override
  final Platform platform;

  @override
  final Project project;

  @override
  Future<void> create({
    String? description,
    required String defaultLanguage,
    required Set<String> languages,
    required Logger logger,
  }) async {
    final projectName = project.name();

    await generate(
      name: '$name feature package (${platform.name})',
      bundle: platformFeaturePackageBundle,
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
        'routable': true, // TODO make customizable by user
        'route_name':
            name.pascalCase.replaceAll('Page', '').replaceAll('Screen', ''),
      },
      logger: logger,
    );

    await _arbDirectory.create(
      languages: languages,
      logger: logger,
      translations: (language) => [
        {
          'name': 'title',
          'translation': '${name.titleCase} title for $language',
          'description': 'Title text shown in the ${name.titleCase}',
        }
      ],
    );
  }

  @override
  Set<String> supportedLanguages() =>
      _arbDirectory.languageArbFiles().map((e) => e.language).toSet();

  @override
  bool supportsLanguage(String language) =>
      supportedLanguages().contains(language);

  @override
  String defaultLanguage() {
    final templateArbFile = _l10nFile.readTemplateArbFile();

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
    l10nFile.setValue(['template-arb-file'], newTemplateArbFile);
  }

  @override
  Future<void> addLanguage({
    required String language,
    required Logger logger,
  }) async {
    await _arbDirectory.addLanguageArbFile(language: language, logger: logger);
  }

  @override
  Future<void> removeLanguage({
    required String language,
    required Logger logger,
  }) async {
    await _arbDirectory.removeLanguageArbFile(
      language: language,
      logger: logger,
    );

    final languageLocalizationsFile = _languageLocalizationsFile(language);
    if (languageLocalizationsFile.exists()) {
      languageLocalizationsFile.delete(logger: logger);
    }
  }

  @override
  Future<void> addBloc({
    required String name,
    required Logger logger,
  }) async {
    final bloc = _bloc(name: name);
    if (bloc.existsAny()) {
      throw BlocAlreadyExists();
    }

    await bloc.create(logger: logger);
  }

  @override
  Future<void> removeBloc({
    required String name,
    required Logger logger,
  }) async {
    final bloc = _bloc(name: name);
    if (!bloc.existsAny()) {
      throw BlocDoesNotExist();
    }

    bloc.delete(logger: logger);
  }

  @override
  Future<void> addCubit({
    required String name,
    required Logger logger,
  }) async {
    final cubit = _cubit(name: name);
    if (cubit.existsAny()) {
      throw CubitAlreadyExists();
    }

    await cubit.create(logger: logger);
  }

  @override
  Future<void> removeCubit({
    required String name,
    required Logger logger,
  }) async {
    final cubit = _cubit(name: name);
    if (!cubit.existsAny()) {
      throw CubitDoesNotExist();
    }

    cubit.delete(logger: logger);
  }

  @override
  int compareTo(PlatformFeaturePackage other) => name.compareTo(other.name);
}

class L10nFileImpl extends YamlFileImpl implements L10nFile {
  L10nFileImpl({
    required PlatformFeaturePackage platformFeaturePackage,
  }) : super(
          path: platformFeaturePackage.path,
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
  void setTemplateArbFile(String newTemplateArbFile) async {
    setValue(['template-arb-file'], newTemplateArbFile);
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

  LanguageArbFile _languageArbFile({required String language}) =>
      (languageArbFileOverrides ?? LanguageArbFile.new)(
        language: language,
        arbDirectory: this,
      );

  @override
  LanguageArbFileBuilder? languageArbFileOverrides;

  @override
  final PlatformFeaturePackage platformFeaturePackage;

  @override
  List<LanguageArbFile> languageArbFiles() => list()
      .whereType<File>()
      .where((e) => e.extension == 'arb')
      .where((e) => e.name != null)
      .map(
        (e) => LanguageArbFile(
          language: e.name!.split('_').last,
          arbDirectory: this,
        ),
      )
      .toList()
    ..sort();

  @override
  Future<void> create({
    required Set<String> languages,
    required Logger logger,
    List<Map<String, dynamic>> Function(String language)? translations,
  }) async {
    for (final language in languages) {
      final languageArbFile = _languageArbFile(language: language);

      await languageArbFile.create(logger: logger);
      if (translations != null) {
        final languageTranslation = translations(language);
        for (final t in languageTranslation) {
          languageArbFile.addTranslation(
            name: t['name'],
            translation: t['translation'],
            description: t['description'],
          );
        }
      }
    }
  }

  @override
  Future<void> addLanguageArbFile({
    required String language,
    required Logger logger,
  }) async {
    final languageArbFile = _languageArbFile(language: language);
    if (languageArbFile.exists()) {
      throw LanguageArbFileAlreadyExists();
    }

    await languageArbFile.create(logger: logger);
  }

  @override
  Future<void> removeLanguageArbFile({
    required String language,
    required Logger logger,
  }) async {
    final languageArbFile = _languageArbFile(language: language);
    if (!languageArbFile.exists()) {
      throw LanguageArbFileDoesNotExists();
    }

    languageArbFile.delete(logger: logger);
  }
}

class LanguageArbFileImpl extends ArbFileImpl
    with OverridableGenerator
    implements LanguageArbFile {
  LanguageArbFileImpl({
    required this.language,
    required ArbDirectory arbDirectory,
  })  : _arbDirectory = arbDirectory,
        super(
          path: arbDirectory.path,
          name: '${arbDirectory.platformFeaturePackage.name}_$language',
        );

  final ArbDirectory _arbDirectory;

  @override
  final String language;

  @override
  Future<void> create({required Logger logger}) async {
    final featureName = _arbDirectory.platformFeaturePackage.name;

    final generator = await super.generator(arbFileBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_arbDirectory.path)),
      vars: <String, dynamic>{
        'feature_name': featureName,
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

  @override
  int compareTo(LanguageArbFile other) => language.compareTo(other.language);
}

class BlocImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements Bloc {
  BlocImpl({
    required String name,
    required PlatformFeaturePackage platformFeaturePackage,
  })  : _platformFeaturePackage = platformFeaturePackage,
        _name = name,
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

  final String _name;
  final PlatformFeaturePackage _platformFeaturePackage;

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = _platformFeaturePackage.project.name();
    final platform = _platformFeaturePackage.platform.name;
    final featureName = _platformFeaturePackage.name;

    final generator = await super.generator(blocBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_platformFeaturePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'platform': platform,
        'feature_name': featureName,
      },
      logger: logger,
    );
  }
}

class CubitImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements Cubit {
  CubitImpl({
    required String name,
    required PlatformFeaturePackage platformFeaturePackage,
  })  : _name = name,
        _platformFeaturePackage = platformFeaturePackage,
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

  final String _name;
  final PlatformFeaturePackage _platformFeaturePackage;

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = _platformFeaturePackage.project.name();
    final platform = _platformFeaturePackage.platform.name;
    final featureName = _platformFeaturePackage.name;

    final generator = await super.generator(cubitBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_platformFeaturePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'platform': platform,
        'feature_name': featureName,
      },
      logger: logger,
    );
  }
}

class PlatformAppFeaturePackageImpl extends PlatformFeaturePackageImpl
    implements PlatformAppFeaturePackage {
  PlatformAppFeaturePackageImpl(
    Platform platform, {
    required super.project,
  }) : super('app', platform);

  @override
  Future<void> create({
    String? description,
    required String defaultLanguage,
    required Set<String> languages,
    required Logger logger,
  }) async {
    final projectName = project.name();

    await generate(
      name: 'app feature package (${platform.name})',
      bundle: platformAppFeaturePackageBundle,
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

    await _arbDirectory.create(languages: languages, logger: logger);
  }
}
