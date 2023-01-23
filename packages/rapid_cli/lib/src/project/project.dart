import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
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

// TODO think about introduceing ProjectEntityCollection

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

  PubspecFile get pubspecFile => dartPackage.pubspecFile;

  String packageName() => dartPackage.pubspecFile.name();

  @override
  bool exists() => dartPackage.exists();

  Future<void> delete({required Logger logger}) async {
    dartPackage.delete();
    logger.detail('Deleted dart package at $path');
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
  })  : _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterFormatFix = flutterFormatFix ?? Flutter.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle {
    _melosFile = melosFile ?? MelosFile(project: this);
    _appPackage = appPackage ?? AppPackage(project: this);
    this.diPackage = diPackage ?? DiPackage(project: this);
    this.domainPackage = domainPackage ?? DomainPackage(project: this);
    this.infrastructurePackage =
        infrastructurePackage ?? InfrastructurePackage(project: this);
    _loggingPackage = loggingPackage ?? LoggingPackage(project: this);
    this.platformDirectory = platformDirectory ??
        (({required platform}) => PlatformDirectory(platform, project: this));
    _uiPackage = uiPackage ?? UiPackage(project: this);
    this.platformUiPackage = platformUiPackage ??
        (({required platform}) => PlatformUiPackage(platform, project: this));
  }

  late final MelosFile _melosFile;
  late final AppPackage _appPackage;
  late final DiPackage diPackage;
  late final DomainPackage domainPackage;
  late final InfrastructurePackage infrastructurePackage;
  late final LoggingPackage _loggingPackage;
  late final PlatformDirectoryBuilder platformDirectory;
  late final UiPackage _uiPackage;
  late final PlatformUiPackageBuilder platformUiPackage;
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
      diPackage.exists() &&
      domainPackage.exists() &&
      infrastructurePackage.exists() &&
      _loggingPackage.exists() &&
      _uiPackage.exists();

  bool platformIsActivated(Platform platform) {
    final platformDirectory = this.platformDirectory(platform: platform);
    final platformUiPackage = this.platformUiPackage(platform: platform);

    return platformDirectory.exists() || platformUiPackage.exists();
  }

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
    logger.info('Creating ...');

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
    await diPackage.create(
      android: android,
      ios: ios,
      linux: linux,
      macos: macos,
      web: web,
      windows: windows,
      logger: logger,
    );
    await domainPackage.create(logger: logger);
    await infrastructurePackage.create(logger: logger);
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
      final platformDirectory = this.platformDirectory(platform: platform);

      final platformAppPackage = platformDirectory.appFeaturePackage;
      await platformAppPackage.create(logger: logger);

      final platformRoutingPackage = platformDirectory.routingFeaturePackage;
      await platformRoutingPackage.create(logger: logger);

      final platformHomePagePackage = platformDirectory.customFeaturePackage(
        name: 'home_page',
      );
      await platformHomePagePackage.create(logger: logger);

      final platformUiPackage = this.platformUiPackage(platform: platform);
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
    final platformDirectory = this.platformDirectory(platform: platform);

    final platformAppPackage = platformDirectory.appFeaturePackage;
    await platformAppPackage.create(logger: logger);

    final platformRoutingPackage = platformDirectory.routingFeaturePackage;
    await platformRoutingPackage.create(logger: logger);

    final platformHomePagePackage = platformDirectory.customFeaturePackage(
      name: 'home_page',
    );
    await platformHomePagePackage.create(logger: logger);
    final platformUiPackage = this.platformUiPackage(platform: platform);
    await platformUiPackage.create(logger: logger);

    await diPackage.registerCustomFeaturePackage(
      platformHomePagePackage,
      logger: logger,
    );

    await _appPackage.addPlatform(
      platform,
      description: description,
      orgName: orgName,
      logger: logger,
    );

    await _melosBootstrap(
      cwd: path,
      scope:
          '${_appPackage.packageName()},${diPackage.packageName()},${platformUiPackage.packageName()},'
          '${platformAppPackage.packageName()},${platformRoutingPackage.packageName()},${platformHomePagePackage.packageName()}',
      logger: logger,
    );
    await _flutterFormatFix(cwd: path, logger: logger);
  }

  Future<void> deactivatePlatform(
    Platform platform, {
    required Logger logger,
  }) async {
    await _appPackage.removePlatform(platform, logger: logger);

    final platformDirectory = this.platformDirectory(platform: platform);
    final customFeaturesPackages = platformDirectory.customFeaturePackages();
    await diPackage.unregisterCustomFeaturePackages(
      customFeaturesPackages,
      logger: logger,
    );
    await platformDirectory.delete(logger: logger);

    final platformUiPackage = this.platformUiPackage(platform: platform);
    await platformUiPackage.delete(logger: logger);

    await _melosBootstrap(
      cwd: path,
      scope: '${_appPackage.packageName()},${diPackage.packageName()}',
      logger: logger,
    );
    await _flutterFormatFix(cwd: path, logger: logger);
  }
}
