import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src2/core/generator_builder.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/core/yaml_file.dart';
import 'package:rapid_cli/src2/project/project.dart';
import 'package:universal_io/io.dart';

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
    required Project project,
  }) : _project = project;

  final Project _project;

  final String name;
  final Platform platform;

  @override
  String get path => p.join(
        _project.path,
        'packages',
        _project.name(),
        '${_project.name()}_${platform.name}',
        '${_project.name()}_${platform.name}_$name',
      );

  Future<void> create({required Logger logger});

  Future<void> addBloc({required Logger logger}) async {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> addCubit({required Logger logger}) async {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> removeBloc({required Logger logger}) async {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> removeCubit({required Logger logger}) async {
    // TODO implement
    throw UnimplementedError();
  }
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
        super('app', platform);

  final GeneratorBuilder _generator;

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = _project.name();

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

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = _project.name();

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
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> unregisterFeature({
    required PlatformCustomFeaturePackage feature,
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
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
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle;

  final GeneratorBuilder _generator;

  // TODO
  Set<String> supportedLanguages() =>
      _arbFiles().map((e) => e.language).toSet();

  // TODO
  String defaultLanguage() {
    final l10nFile = _l10nFile;
    final templateArbFile = l10nFile.templateArbFile();

    return templateArbFile.split('.').first.split('_').last;
  }

  @override
  Future<void> create({required Logger logger}) async {
    final projectName = _project.name();

    final generator = await _generator(platformCustomFeaturePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'name': name,
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
}

// TODO refactor

/// {@template arb_file}
/// Abstraction of a arb file of a platform custom feature package of a Rapid project.
/// {@endtemplate}
class ArbFile extends ProjectEntity {
  /// {@macro arb_file}
  ArbFile({
    required this.language,
    required Feature feature,
  }) : _file = File(
          p.join(
            feature.path,
            'lib',
            'src',
            'presentation',
            'l10n',
            'arb',
            '${feature.name}_$language.arb',
          ),
        );

  final File _file;

  final String language;

  String get path => _file.path;

  void delete() => _file.deleteSync(recursive: true);
}

/// Thrown when [L10nFile.templateArbFile] fails to read the `template-arb-file` property.
class ReadTemplateArbFileFailure implements Exception {}

/// {@template l10n_file}
/// Abstraction of the l10n file of a platform custom feature package of an existing Rapid project.
/// {@endtemplate}
class L10nFile extends ProjectEntity {
  /// {@macro l10n_file}
  L10nFile({String path = '.'}) : _file = YamlFile(path: path, name: 'l10n');

  /// The underlying yaml file.
  final YamlFile _file;

  String get path => _file.path;

  /// The `template-arb-file` property.
  String templateArbFile() {
    try {
      return _file.readValue(['template-arb-file']);
    } catch (_) {
      throw ReadTemplateArbFileFailure();
    }
  }
}
