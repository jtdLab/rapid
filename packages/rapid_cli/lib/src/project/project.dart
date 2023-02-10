import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';

import 'app_package/app_package.dart';
import 'di_package/di_package.dart';
import 'infrastructure_package/infrastructure_package.dart';
import 'logging_package/logging_package.dart';
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
class Project extends Directory {
  /// {@macro project}
  Project({
    super.path,
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
  })  : _melosFile = melosFile,
        _appPackage = appPackage,
        _diPackage = diPackage,
        _domainPackage = domainPackage,
        _infrastructurePackage = infrastructurePackage,
        _loggingPackage = loggingPackage,
        _uiPackage = uiPackage,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle {
    this.platformDirectory = platformDirectory ??
        (({required platform}) => PlatformDirectory(platform, project: this));
    this.platformUiPackage = platformUiPackage ??
        (({required platform}) => PlatformUiPackage(platform, project: this));
  }

  final MelosFile? _melosFile;
  final AppPackage? _appPackage;
  final DiPackage? _diPackage;
  final DomainPackage? _domainPackage;
  final InfrastructurePackage? _infrastructurePackage;
  final LoggingPackage? _loggingPackage;
  final UiPackage? _uiPackage;
  final MelosBootstrapCommand _melosBootstrap;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  MelosFile get melosFile => _melosFile ?? MelosFile(project: this);
  AppPackage get appPackage => _appPackage ?? AppPackage(project: this);
  DiPackage get diPackage => _diPackage ?? DiPackage(project: this);
  DomainPackage get domainPackage =>
      _domainPackage ?? DomainPackage(project: this);
  InfrastructurePackage get infrastructurePackage =>
      _infrastructurePackage ?? InfrastructurePackage(project: this);
  LoggingPackage get loggingPackage =>
      _loggingPackage ?? LoggingPackage(project: this);
  late final PlatformDirectoryBuilder platformDirectory;
  UiPackage get uiPackage => _uiPackage ?? UiPackage(project: this);
  late final PlatformUiPackageBuilder platformUiPackage;

  String name() => melosFile.readName();

  @override
  bool exists() =>
      melosFile.exists() &&
      appPackage.exists() &&
      diPackage.exists() &&
      domainPackage.exists() &&
      infrastructurePackage.exists() &&
      loggingPackage.exists() &&
      uiPackage.exists();

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
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
    await appPackage.create(
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
    await loggingPackage.create(logger: logger);
    await uiPackage.create(logger: logger);

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
    await appPackage.addPlatform(
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
        appPackage.packageName(),
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

    await appPackage.removePlatform(platform, logger: logger);
    final platformDirectory = this.platformDirectory(platform: platform);
    final customFeaturesPackages = platformDirectory.customFeaturePackages();
    final platformUiPackage = this.platformUiPackage(platform: platform);
    platformUiPackage.delete(logger: logger);
    await diPackage.unregisterCustomFeaturePackages(
      customFeaturesPackages,
      logger: logger,
    );
    platformDirectory.delete(logger: logger);

    deleteProgress.complete();

    await _melosBootstrap(
      cwd: path,
      scope: [
        appPackage.packageName(),
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

    customFeaturePackage.delete(logger: logger);

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
      throw FeaturesDoNotSupportLanguage();
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
    if (entity.existsAny()) {
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
    if (!entity.existsAny()) {
      throw EntityDoesNotExist();
    }

    entity.delete(logger: logger);
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
    if (serviceInterface.existsAny()) {
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
    if (!serviceInterface.existsAny()) {
      throw ServiceInterfaceDoesNotExist();
    }

    serviceInterface.delete(logger: logger);
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
    if (valueObject.existsAny()) {
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
    if (!valueObject.existsAny()) {
      throw ValueObjectDoesNotExist();
    }

    valueObject.delete(logger: logger);
  }

  Future<void> addDataTransferObject({
    required String entityName,
    required String outputDir,
    required Logger logger,
  }) async {
    final entity = domainPackage.entity(name: entityName, dir: outputDir);

    if (!entity.existsAny()) {
      throw EntityDoesNotExist();
    }

    final dataTransferObject = infrastructurePackage.dataTransferObject(
      entityName: entityName,
      dir: outputDir,
    );

    if (dataTransferObject.existsAny()) {
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
    if (!dataTransferObject.existsAny()) {
      throw ValueObjectDoesNotExist();
    }

    dataTransferObject.delete(logger: logger);
  }

  Future<void> addServiceImplementation({
    required String name,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  }) async {
    final serviceInterface =
        domainPackage.serviceInterface(name: serviceName, dir: outputDir);

    if (!serviceInterface.existsAny()) {
      throw ServiceInterfaceDoesNotExist();
    }

    final serviceImplementation = infrastructurePackage.serviceImplementation(
      name: name,
      serviceName: serviceName,
      dir: outputDir,
    );

    if (serviceImplementation.existsAny()) {
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
    if (!serviceImplementation.existsAny()) {
      throw ServiceImplementationDoesNotExist();
    }

    serviceImplementation.delete(logger: logger);
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

    if (bloc.existsAny()) {
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

    if (cubit.existsAny()) {
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

    if (widget.existsAny()) {
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

    if (!widget.existsAny()) {
      throw WidgetDoesNotExist();
    }

    widget.delete(logger: logger);
  }
}

/// Thrown when [MelosFile.readName] fails to read the `name` property.
class ReadNameFailure implements Exception {}

/// {@template melos_file}
/// Abstraction of the melos file of a Rapid project.
///
/// Location: `melos.yaml`
/// {@endtemplate}
class MelosFile extends YamlFile with YamlFileProtectedMixin {
  /// {@macro melos_file}
  MelosFile({required Project project})
      : super(
          path: project.path,
          name: 'melos',
        );

  String readName() {
    try {
      return readValue(['name']);
    } catch (_) {
      throw ReadNameFailure();
    }
  }
}
