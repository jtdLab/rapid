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

class FeatureDoesNotExist implements Exception {}

class FeatureAlreadyExists implements Exception {}

class NoFeaturesFound implements Exception {}

class FeaturesHaveDiffrentLanguages implements Exception {}

class FeaturesHaveDiffrentDefaultLanguage implements Exception {}

class FeaturesAlreadySupportLanguage implements Exception {}

class FeaturesDoNotSupportLanguage implements Exception {}

class UnableToRemoveDefaultLanguage implements Exception {}

class EntityAlreadyExists implements Exception {}

class EntityDoesNotExist implements Exception {}

class ServiceInterfaceAlreadyExists implements Exception {}

class ServiceInterfaceDoesNotExist implements Exception {}

class ValueObjectAlreadyExists implements Exception {}

class ValueObjectDoesNotExist implements Exception {}

class DataTransferObjectAlreadyExists implements Exception {}

class DataTransferObjectDoesNotExist implements Exception {}

class ServiceImplementationAlreadyExists implements Exception {}

class ServiceImplementationDoesNotExist implements Exception {}

class BlocAlreadyExists implements Exception {}

class CubitAlreadyExists implements Exception {}

class WidgetAlreadyExists implements Exception {}

class WidgetDoesNotExist implements Exception {}

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
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  })  : _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
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
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final DartFormatFixCommand _dartFormatFix;
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
    final generateProgress = logger.progress('Generating project files');

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

    generateProgress.complete();

    await _melosBootstrap(cwd: path, logger: logger);
    await _dartFormatFix(cwd: path, logger: logger);
  }

  Future<void> addPlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required Logger logger,
  }) async {
    final generateProgress = logger.progress(
      'Generating ${platform.prettyName} files',
    );

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

    generateProgress.complete();

    // TODO logg inside the metohd pls
    await _appPackage.addPlatform(
      platform,
      description: description,
      orgName: orgName,
      logger: logger,
    );

    // TODO logg inside the metohd pls
    await diPackage.registerCustomFeaturePackage(
      platformHomePagePackage,
      logger: logger,
    );

    await _melosBootstrap(
      cwd: path,
      scope: [
        _appPackage.packageName(),
        diPackage.packageName(),
        platformUiPackage.packageName(),
        platformAppPackage.packageName(),
        platformRoutingPackage.packageName(),
        platformHomePagePackage.packageName(),
      ],
      logger: logger,
    );

    await _flutterPubGet(
      cwd: diPackage.path,
      logger: logger,
    );

    await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
      cwd: diPackage.path,
      logger: logger,
    );

    await _dartFormatFix(cwd: path, logger: logger);
  }

  Future<void> removePlatform(
    Platform platform, {
    required Logger logger,
  }) async {
    final deleteProgress = logger.progress(
      'Deleting ${platform.prettyName} files',
    );

    await _appPackage.removePlatform(platform, logger: logger);
    final platformDirectory = this.platformDirectory(platform: platform);
    final customFeaturesPackages = platformDirectory.customFeaturePackages();
    final platformUiPackage = this.platformUiPackage(platform: platform);
    await platformUiPackage.delete(logger: logger);
    await diPackage.unregisterCustomFeaturePackages(
      customFeaturesPackages,
      logger: logger,
    );
    await platformDirectory.delete(logger: logger);

    deleteProgress.complete();

    await _melosBootstrap(
      cwd: path,
      scope: [
        _appPackage.packageName(),
        diPackage.packageName(),
      ],
      logger: logger,
    );

    await _flutterPubGet(
      cwd: diPackage.path,
      logger: logger,
    );

    await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
      cwd: diPackage.path,
      logger: logger,
    );

    await _dartFormatFix(cwd: path, logger: logger);
  }

  Future<void> addFeature({
    required String name,
    required String description,
    required bool routing,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final customFeaturePackage = platformDirectory.customFeaturePackage(
      name: name,
    );
    final customFeaturePackageExists = customFeaturePackage.exists();
    if (customFeaturePackageExists) {
      throw FeatureAlreadyExists();
    }

    if (!customFeaturePackageExists) {
      await customFeaturePackage.create(
        description: description,
        logger: logger,
      );

      final appFeaturePackage = platformDirectory.appFeaturePackage;
      await appFeaturePackage.registerCustomFeaturePackage(
        customFeaturePackage,
        logger: logger,
      );

      final routingFeaturePackage = platformDirectory.routingFeaturePackage;
      if (routing) {
        await routingFeaturePackage.registerCustomFeaturePackage(
          customFeaturePackage,
          logger: logger,
        );
      }

      await diPackage.registerCustomFeaturePackage(
        customFeaturePackage,
        logger: logger,
      );

      await _melosBootstrap(
        logger: logger,
        scope: [
          customFeaturePackage.packageName(),
          diPackage.packageName(),
          appFeaturePackage.packageName(),
          if (routing) routingFeaturePackage.packageName(),
        ],
      );

      await _flutterPubGet(
        cwd: diPackage.path,
        logger: logger,
      );

      await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
        cwd: diPackage.path,
        logger: logger,
      );

      await _dartFormatFix(logger: logger);
    }
  }

  Future<void> removeFeature({
    required String name,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final customFeaturePackage = platformDirectory.customFeaturePackage(
      name: name,
    );
    final customFeaturePackageExists = customFeaturePackage.exists();
    if (!customFeaturePackageExists) {
      throw FeatureDoesNotExist();
    }

    await diPackage.unregisterCustomFeaturePackages(
      [customFeaturePackage],
      logger: logger,
    );

    final appFeaturePackage = platformDirectory.appFeaturePackage;
    await appFeaturePackage.unregisterCustomFeaturePackage(
      customFeaturePackage,
      logger: logger,
    );

    final routingFeaturePackage = platformDirectory.routingFeaturePackage;
    await routingFeaturePackage.unregisterCustomFeaturePackage(
      customFeaturePackage,
      logger: logger,
    );

    final otherFeaturePackages = [
      platformDirectory.appFeaturePackage,
      routingFeaturePackage,
      ...platformDirectory.customFeaturePackages(),
    ]..removeWhere(
        (e) => e.packageName() == customFeaturePackage.packageName(),
      );

    for (final otherFeaturePackage in otherFeaturePackages) {
      otherFeaturePackage.pubspecFile.removeDependency(
        customFeaturePackage.packageName(),
      );
    }

    await customFeaturePackage.delete(logger: logger);

    await _melosBootstrap(
      logger: logger,
      scope: [
        diPackage.packageName(),
        appFeaturePackage.packageName(),
        routingFeaturePackage.packageName(),
        ...otherFeaturePackages.map((e) => e.packageName())
      ],
    );

    await _flutterPubGet(
      cwd: diPackage.path,
      logger: logger,
    );

    await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
      cwd: diPackage.path,
      logger: logger,
    );
  }

  Future<void> addLanguage(
    String language, {
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final customFeatures = platformDirectory.customFeaturePackages();

    if (customFeatures.isEmpty) {
      throw NoFeaturesFound();
    }

    if (!platformDirectory.allFeaturesHaveSameLanguages()) {
      throw FeaturesHaveDiffrentLanguages();
    }

    if (!platformDirectory.allFeaturesHaveSameDefaultLanguage()) {
      throw FeaturesHaveDiffrentDefaultLanguage();
    }

    if (customFeatures.first.supportsLanguage(language)) {
      throw FeaturesAlreadySupportLanguage();
    }

    for (final customFeature in customFeatures) {
      await customFeature.addLanguage(
        language: language,
        logger: logger,
      );
    }

    await _dartFormatFix(logger: logger);
  }

  Future<void> removeLanguage(
    String language, {
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final customFeatures = platformDirectory.customFeaturePackages();

    if (customFeatures.isEmpty) {
      throw NoFeaturesFound();
    }

    if (!platformDirectory.allFeaturesHaveSameLanguages()) {
      throw FeaturesHaveDiffrentLanguages();
    }

    if (!platformDirectory.allFeaturesHaveSameDefaultLanguage()) {
      throw FeaturesHaveDiffrentDefaultLanguage();
    }

    if (!customFeatures.first.supportsLanguage(language)) {
      throw FeaturesAlreadySupportLanguage();
    }

    if (customFeatures.first.defaultLanguage() == language) {
      throw UnableToRemoveDefaultLanguage();
    }

    for (final customFeature in customFeatures) {
      await customFeature.removeLanguage(
        language: language,
        logger: logger,
      );
    }
  }

  Future<void> addEntity({
    required String name,
    required String outputDir,
    required Logger logger,
  }) async {
    final entity = domainPackage.entity(name: name, dir: outputDir);
    if (entity.exists()) {
      throw EntityAlreadyExists();
    }

    await entity.create(logger: logger);
  }

  Future<void> removeEntity({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final entity = domainPackage.entity(name: name, dir: dir);
    if (!entity.exists()) {
      throw EntityDoesNotExist();
    }

    entity.delete();
  }

  Future<void> addServiceInterface({
    required String name,
    required String outputDir,
    required Logger logger,
  }) async {
    final serviceInterface = domainPackage.serviceInterface(
      name: name,
      dir: outputDir,
    );
    if (serviceInterface.exists()) {
      throw ServiceInterfaceAlreadyExists();
    }

    await serviceInterface.create(logger: logger);
  }

  Future<void> removeServiceInterface({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final serviceInterface = domainPackage.serviceInterface(
      name: name,
      dir: dir,
    );
    if (!serviceInterface.exists()) {
      throw ServiceInterfaceDoesNotExist();
    }

    serviceInterface.delete();
  }

  Future<void> addValueObject({
    required String name,
    required String outputDir,
    required String type,
    required String generics,
    required Logger logger,
  }) async {
    final valueObject = domainPackage.valueObject(
      name: name,
      dir: outputDir,
    );
    if (valueObject.exists()) {
      throw ValueObjectAlreadyExists();
    }

    await valueObject.create(type: type, generics: generics, logger: logger);
  }

  Future<void> removeValueObject({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final valueObject = domainPackage.valueObject(
      name: name,
      dir: dir,
    );
    if (!valueObject.exists()) {
      throw ValueObjectDoesNotExist();
    }

    valueObject.delete();
  }

  Future<void> addDataTransferObject({
    required String entityName,
    required String outputDir,
    required Logger logger,
  }) async {
    final entity = domainPackage.entity(name: entityName, dir: outputDir);

    if (!entity.exists()) {
      throw EntityDoesNotExist();
    }

    final dataTransferObject = infrastructurePackage.dataTransferObject(
      entityName: entityName,
      dir: outputDir,
    );

    if (dataTransferObject.exists()) {
      throw DataTransferObjectAlreadyExists();
    }

    await dataTransferObject.create(logger: logger);
  }

  Future<void> removeDataTransferObject({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    final dataTransferObject = infrastructurePackage.dataTransferObject(
      entityName: name.replaceAll('Dto', ''), // TODO good ?
      dir: dir,
    );
    if (!dataTransferObject.exists()) {
      throw ValueObjectDoesNotExist();
    }

    dataTransferObject.delete();
  }

  Future<void> addServiceImplementation({
    required String name,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  }) async {
    final serviceInterface =
        domainPackage.serviceInterface(name: serviceName, dir: outputDir);

    if (!serviceInterface.exists()) {
      throw ServiceInterfaceDoesNotExist();
    }

    final serviceImplementation = infrastructurePackage.serviceImplementation(
      name: name,
      serviceName: serviceName,
      dir: outputDir,
    );

    if (serviceImplementation.exists()) {
      throw ServiceImplementationAlreadyExists();
    }

    await serviceImplementation.create(logger: logger);
  }

  Future<void> removeServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
    required Logger logger,
  }) async {
    final serviceImplementation = infrastructurePackage.serviceImplementation(
      name: name,
      serviceName: serviceName,
      dir: dir,
    );
    if (!serviceImplementation.exists()) {
      throw ServiceImplementationDoesNotExist();
    }

    serviceImplementation.delete();
  }

  Future<void> addBloc({
    required String name,
    required String featureName,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final customFeaturePackage = platformDirectory.customFeaturePackage(
      name: featureName,
    );

    if (!customFeaturePackage.exists()) {
      throw FeatureDoesNotExist();
    }

    final bloc = customFeaturePackage.bloc(name: name);

    if (bloc.exists()) {
      throw BlocAlreadyExists();
    }

    await bloc.create(logger: logger);

    await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
      cwd: customFeaturePackage.path,
      logger: logger,
    );
  }

  Future<void> addCubit({
    required String name,
    required String featureName,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final customFeaturePackage = platformDirectory.customFeaturePackage(
      name: featureName,
    );

    if (!customFeaturePackage.exists()) {
      throw FeatureDoesNotExist();
    }

    final cubit = customFeaturePackage.cubit(name: name);

    if (cubit.exists()) {
      throw CubitAlreadyExists();
    }

    await cubit.create(logger: logger);

    await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
      cwd: customFeaturePackage.path,
      logger: logger,
    );
  }

  Future<void> addWidget({
    required String name,
    required String outputDir,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformUiPackage = this.platformUiPackage(platform: platform);
    final widget = platformUiPackage.widget(name: name, dir: outputDir);

    if (widget.exists()) {
      throw WidgetAlreadyExists();
    }

    await widget.create(logger: logger);
  }

  Future<void> removeWidget({
    required String name,
    required String dir,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformUiPackage = this.platformUiPackage(platform: platform);
    final widget = platformUiPackage.widget(name: name, dir: dir);

    if (!widget.exists()) {
      throw WidgetDoesNotExist();
    }

    widget.delete();
  }
}
