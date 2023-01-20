import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src2/cli/cli.dart';
import 'package:rapid_cli/src2/core/dart_package.dart';
import 'package:rapid_cli/src2/core/generator_builder.dart';
import 'package:rapid_cli/src2/core/platform.dart';
import 'package:rapid_cli/src2/project/domain_package/domain_package.dart';
import 'package:universal_io/io.dart';

import 'app_package/app_package.dart';
import 'di_package/di_package.dart';
import 'infrastructure_package/infrastructure_package.dart';
import 'logging_package/logging_package.dart';
import 'melos_file.dart';
import 'platform_directory/platform_directory.dart';
import 'platform_ui_package/platform_ui_package.dart';
import 'project_bundle.dart';
import 'ui_package/ui_package.dart';

abstract class ProjectEntity {
  String get path;

  bool exists();
}

abstract class ProjectDirectory extends ProjectEntity {
  @protected
  late final directory = Directory(path);

  @override
  bool exists() => directory.existsSync();

  Future<void> delete({required Logger logger}) async {
    directory.deleteSync(recursive: true);
    logger.detail('Deleted directory at $path');
  }
}

abstract class ProjectPackage extends ProjectEntity {
  @protected
  late final dartPackage = DartPackage(path: path);

  String packageName() => dartPackage.pubspecFile.name();

  @override
  bool exists() => dartPackage.exists();

  Future<void> delete({required Logger logger}) async {
    dartPackage.delete();
    logger.detail('Deleted dart package at $path');
  }
}

mixin BootstrapMixin on ProjectPackage {
  @protected
  MelosBootstrapCommand get melosBootstrap;

  Future<void> bootstrap({required Logger logger}) async {
    await melosBootstrap(cwd: path, scope: packageName(), logger: logger);
  }
}

mixin RebuildMixin on ProjectPackage {
  @protected
  FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      get flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  Future<void> rebuild({required Logger logger}) async {
    await flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
      cwd: path,
      logger: logger,
    );
  }
}

/// Signature for method that returns the [PlatformDirectory] for [platform].
typedef PlatformDirectoryBuilder = PlatformDirectory Function({
  required Platform platform,
});

/// Signature for method that returns the [PlatformUiPackage] for [platform].
typedef PlatformUiPackageBuilder = PlatformUiPackage Function({
  required Platform platform,
});

/// Signature for method that returns the [Project] for [path].
typedef ProjectBuilder = Project Function({String path});

/// {@template project}
/// Abstraction of a Rapid project.
/// {@endtemplate}
class Project implements ProjectEntity {
  /// {@macro project}
  Project({
    this.path = '.',
    MelosFile? melosFile,
    AppPackage? appPackage,
    DiPackage? diPackage,
    DomainPackage? domainPackage,
    InfrastructurePackage? infrastructurePackage,
    LoggingPackage? loggingPackage,
    PlatformDirectoryBuilder? platformDirectory,
    UiPackage? uiPackage,
    PlatformUiPackageBuilder? platformUiPackage,
    MelosBootstrapCommand? melosBootstrap,
    FlutterFormatFixCommand? flutterFormatFix,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterFormatFix = flutterFormatFix ?? Flutter.formatFix {
    _melosFile = melosFile ?? MelosFile(project: this);
    _appPackage = appPackage ?? AppPackage(project: this);
    _diPackage = diPackage ?? DiPackage(project: this);
    _domainPackage = domainPackage ?? DomainPackage(project: this);
    _infrastructurePackage =
        infrastructurePackage ?? InfrastructurePackage(project: this);
    _loggingPackage = loggingPackage ?? LoggingPackage(project: this);
    _platformDirectory = platformDirectory ??
        (({required platform}) => PlatformDirectory(platform, project: this));
    _uiPackage = uiPackage ?? UiPackage(project: this);
    _platformUiPackage = platformUiPackage ??
        (({required platform}) => PlatformUiPackage(platform, project: this));
  }

  late final MelosFile _melosFile;
  late final AppPackage _appPackage;
  late final DiPackage _diPackage;
  late final DomainPackage _domainPackage;
  late final InfrastructurePackage _infrastructurePackage;
  late final LoggingPackage _loggingPackage;
  late final PlatformDirectoryBuilder _platformDirectory;
  late final UiPackage _uiPackage;
  late final PlatformUiPackageBuilder _platformUiPackage;
  final MelosBootstrapCommand _melosBootstrap;
  final FlutterFormatFixCommand _flutterFormatFix;
  final GeneratorBuilder _generator;

  @override
  final String path;

  String name() => _melosFile.name();

  @override
  bool exists() =>
      _melosFile.exists() &&
      _appPackage.exists() &&
      _diPackage.exists() &&
      _domainPackage.exists() &&
      _infrastructurePackage.exists() &&
      _loggingPackage.exists() &&
      _uiPackage.exists();

  Future<void> create({
    required String projectName,
    required String description,
    required String orgName,
    required bool example,
    required bool android,
    required bool ios,
    required bool linux,
    required bool macos,
    required bool web,
    required bool windows,
    required Logger logger,
  }) async {
    final generator = await _generator(projectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
    await _appPackage.create(
      description: description,
      orgName: orgName,
      android: android,
      ios: ios,
      linux: linux,
      macos: macos,
      web: web,
      windows: windows,
      logger: logger,
    );
    await _diPackage.create(
      android: android,
      ios: ios,
      linux: linux,
      macos: macos,
      web: web,
      windows: windows,
      logger: logger,
    );
    await _domainPackage.create(logger: logger);
    await _infrastructurePackage.create(logger: logger);
    await _loggingPackage.create(logger: logger);
    await _uiPackage.create(logger: logger);

    final platforms = [
      if (android) Platform.android,
      if (ios) Platform.ios,
      if (linux) Platform.linux,
      if (macos) Platform.macos,
      if (web) Platform.web,
      if (windows) Platform.windows,
    ];

    for (final platform in platforms) {
      final platformDirectory = _platformDirectory(platform: platform);

      final platformAppPackage = platformDirectory.appFeaturePackage;
      await platformAppPackage.create(logger: logger);

      final platformRoutingPackage = platformDirectory.routingFeaturePackage;
      await platformRoutingPackage.create(logger: logger);

      final platformHomePagePackage = platformDirectory.customFeaturePackage(
        name: 'home_page',
      );
      await platformHomePagePackage.create(logger: logger);

      final platformUiPackage = _platformUiPackage(platform: platform);
      await platformUiPackage.create(logger: logger);
    }

    await _melosBootstrap(cwd: path, logger: logger);
    await _flutterFormatFix(cwd: path, logger: logger);
  }

  Future<void> activatePlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required Logger logger,
  }) async {
    await _appPackage.addPlatform(
      platform,
      description: description,
      orgName: orgName,
      logger: logger,
    );

    final platformDirectory = _platformDirectory(platform: platform);

    final platformAppPackage = platformDirectory.appFeaturePackage;
    await platformAppPackage.create(logger: logger);

    final platformRoutingPackage = platformDirectory.routingFeaturePackage;
    await platformRoutingPackage.create(logger: logger);

    final platformHomePagePackage = platformDirectory.customFeaturePackage(
      name: 'home_page',
    );
    await platformHomePagePackage.create(logger: logger);

    final platformUiPackage = _platformUiPackage(platform: platform);
    await platformUiPackage.create(logger: logger);
  }

  Future<void> deactivatePlatform(
    Platform platform, {
    required Logger logger,
  }) async {
    await _appPackage.removePlatform(platform, logger: logger);

    final platformDirectory = _platformDirectory(platform: platform);

    final platformAppPackage = platformDirectory.appFeaturePackage;
    await platformAppPackage.delete(logger: logger);

    final platformRoutingPackage = platformDirectory.routingFeaturePackage;
    await platformRoutingPackage.delete(logger: logger);

    final platformFeaturePackages = platformDirectory.customFeaturePackages();
    for (final platformFeaturePackage in platformFeaturePackages) {
      await platformFeaturePackage.delete(logger: logger);
    }

    await _diPackage.unregisterCustomFeaturePackagesByPlatform(
      platform,
      logger: logger,
    );

    final platformUiPackage = _platformUiPackage(platform: platform);
    await platformUiPackage.delete(logger: logger);
  }
}
