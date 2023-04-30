import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/arb_file_impl.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
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
  PlatformFeaturePackageApplicationBarrelFileBuilder?
      applicationBarrelFileOverrides;

  @override
  PlatformFeaturePackageBarrelFileBuilder? barrelFileOverrides;

  @override
  final String name;

  @override
  final Platform platform;

  @override
  final Project project;

  @override
  Bloc bloc({required String name, required String dir}) =>
      (blocOverrides ?? Bloc.new)(
        name: name,
        dir: dir,
        platformFeaturePackage: this,
      );

  @override
  Cubit cubit({required String name, required String dir}) =>
      (cubitOverrides ?? Cubit.new)(
        name: name,
        dir: dir,
        platformFeaturePackage: this,
      );

  @override
  PlatformFeaturePackageApplicationBarrelFile get applicationBarrelFile =>
      (applicationBarrelFileOverrides ??
          PlatformFeaturePackageApplicationBarrelFile.new)(
        platformFeaturePackage: this,
      );

  @override
  PlatformFeaturePackageBarrelFile get barrelFile => (barrelFileOverrides ??
      PlatformFeaturePackageBarrelFile.new)(platformFeaturePackage: this);

  @override
  Future<void> create({
    String? description,
    bool routing = true,
    required String defaultLanguage,
    required Set<String> languages,
  }) async {
    final projectName = project.name();

    await generate(
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
        'routable': routing,
        'route_name':
            name.pascalCase.replaceAll('Page', '').replaceAll('Screen', ''),
      },
    );

    await _arbDirectory.create(
      languages: languages,
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
  String defaultLanguage() {
    final templateArbFile = _l10nFile.readTemplateArbFile();

    return templateArbFile.split('.').first.split('_').last;
  }

  @override
  Future<void> setDefaultLanguage(String newDefaultLanguage) async {
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
  Future<void> addLanguage(String language) async {
    await _arbDirectory.addLanguageArbFile(language: language);
  }

  @override
  Future<void> removeLanguage(String language) async {
    await _arbDirectory.removeLanguageArbFile(language: language);

    final languageLocalizationsFile = _languageLocalizationsFile(language);
    if (languageLocalizationsFile.exists()) {
      languageLocalizationsFile.delete();
    }
  }

  @override
  Future<Bloc> addBloc({
    required String name,
    required String dir,
  }) async {
    final bloc = this.bloc(name: name, dir: dir);
    if (bloc.existsAny()) {
      throw RapidException('The ${name}Bloc at $dir already exists');
    }

    await bloc.create();

    return bloc;
  }

  @override
  Future<Bloc> removeBloc({
    required String name,
    required String dir,
  }) async {
    final bloc = this.bloc(name: name, dir: dir);
    if (!bloc.existsAny()) {
      throw RapidException('The ${name}Bloc at $dir does not exist');
    }

    bloc.delete();

    return bloc;
  }

  @override
  Future<Cubit> addCubit({
    required String name,
    required String dir,
  }) async {
    final cubit = this.cubit(name: name, dir: dir);
    if (cubit.existsAny()) {
      throw RapidException('The ${name}Cubit at $dir already exists');
    }

    await cubit.create();

    return cubit;
  }

  @override
  Future<Cubit> removeCubit({
    required String name,
    required String dir,
  }) async {
    final cubit = this.cubit(name: name, dir: dir);
    if (!cubit.existsAny()) {
      throw RapidException('The ${name}Cubit at $dir does not exist');
    }

    cubit.delete();

    return cubit;
  }

  @override
  int compareTo(PlatformFeaturePackage other) => name.compareTo(other.name);

  @override
  bool operator ==(Object other) =>
      other is PlatformFeaturePackage &&
      name == other.name &&
      platform == other.platform &&
      project == other.project;

  @override
  int get hashCode => Object.hash(name, platform, project);
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
    bool routing = false,
    required String defaultLanguage,
    required Set<String> languages,
  }) async {
    final projectName = project.name();

    await generate(
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
        'routable': routing,
        'route_name':
            name.pascalCase.replaceAll('Page', '').replaceAll('Screen', ''),
      },
    );

    await _arbDirectory.create(languages: languages);
  }
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

  @override
  LanguageArbFileBuilder? languageArbFileOverrides;

  @override
  final PlatformFeaturePackage platformFeaturePackage;

  @override
  LanguageArbFile languageArbFile({required String language}) =>
      (languageArbFileOverrides ?? LanguageArbFile.new)(
        language: language,
        arbDirectory: this,
      );

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
    List<Map<String, dynamic>> Function(String language)? translations,
  }) async {
    for (final language in languages) {
      final languageArbFile = this.languageArbFile(language: language);

      await languageArbFile.create();
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
  Future<LanguageArbFile> addLanguageArbFile({
    required String language,
  }) async {
    final languageArbFile = this.languageArbFile(language: language);
    if (languageArbFile.exists()) {
      throw RapidException('The file $language.arb already exists');
    }

    await languageArbFile.create();

    return languageArbFile;
  }

  @override
  Future<LanguageArbFile> removeLanguageArbFile({
    required String language,
  }) async {
    final languageArbFile = this.languageArbFile(language: language);
    if (!languageArbFile.exists()) {
      throw RapidException('The file $language.arb does not exist');
    }

    languageArbFile.delete();

    return languageArbFile;
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
  Future<void> create() async {
    final featureName = _arbDirectory.platformFeaturePackage.name;

    final generator = await super.generator(arbFileBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_arbDirectory.path)),
      vars: <String, dynamic>{
        'feature_name': featureName,
        'language': language,
      },
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
    required String dir,
    required PlatformFeaturePackage platformFeaturePackage,
  })  : _platformFeaturePackage = platformFeaturePackage,
        _name = name,
        _dir = dir,
        super([
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_bloc',
          ),
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_bloc.freezed',
          ),
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_event',
          ),
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_state',
          ),
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'test',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_bloc_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final PlatformFeaturePackage _platformFeaturePackage;

  @override
  Future<void> create() async {
    final projectName = _platformFeaturePackage.project.name();
    final platform = _platformFeaturePackage.platform.name;
    final featureName = _platformFeaturePackage.name;

    final generator = await super.generator(blocBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_platformFeaturePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
        'platform': platform,
        'feature_name': featureName,
      },
    );
  }
}

class CubitImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements Cubit {
  CubitImpl({
    required String name,
    required String dir,
    required PlatformFeaturePackage platformFeaturePackage,
  })  : _name = name,
        _dir = dir,
        _platformFeaturePackage = platformFeaturePackage,
        super([
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_cubit',
          ),
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_cubit.freezed',
          ),
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'lib',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_state',
          ),
          DartFile(
            path: p.join(
              platformFeaturePackage.path,
              'test',
              'src',
              'application',
              dir,
            ),
            name: '${name.snakeCase}_cubit_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final PlatformFeaturePackage _platformFeaturePackage;

  @override
  Future<void> create() async {
    final projectName = _platformFeaturePackage.project.name();
    final platform = _platformFeaturePackage.platform.name;
    final featureName = _platformFeaturePackage.name;

    final generator = await super.generator(cubitBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_platformFeaturePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
        'platform': platform,
        'feature_name': featureName,
      },
    );
  }
}

class PlatformFeaturePackageApplicationBarrelFileImpl extends DartFileImpl
    implements PlatformFeaturePackageApplicationBarrelFile {
  PlatformFeaturePackageApplicationBarrelFileImpl({
    required PlatformFeaturePackage platformFeaturePackage,
  }) : super(
          path: p.join(
            platformFeaturePackage.path,
            'lib',
            'src',
            'application',
          ),
          name: 'application',
        );

  @override
  Future<void> create() => io.File(path).create();
}

class PlatformFeaturePackageBarrelFileImpl extends DartFileImpl
    implements PlatformFeaturePackageBarrelFile {
  PlatformFeaturePackageBarrelFileImpl({
    required PlatformFeaturePackage platformFeaturePackage,
  }) : super(
          path: p.join(
            platformFeaturePackage.path,
            'lib',
          ),
          name: platformFeaturePackage.packageName(),
        );
}
