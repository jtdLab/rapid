import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/platform_x.dart';
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file_impl.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';

import 'app_package/app_package.dart';
import 'di_package/di_package.dart';
import 'infrastructure_package/infrastructure_package.dart';
import 'logging_package/logging_package.dart';
import 'platform_directory/platform_directory.dart';
import 'platform_ui_package/platform_ui_package.dart';
import 'project.dart';
import 'project_bundle.dart';
import 'ui_package/ui_package.dart';

class ProjectImpl extends DirectoryImpl implements Project {
  ProjectImpl({
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

  @override
  MelosFile get melosFile => _melosFile ?? MelosFile(project: this);

  @override
  AppPackage get appPackage => _appPackage ?? AppPackage(project: this);

  @override
  DiPackage get diPackage => _diPackage ?? DiPackage(project: this);

  @override
  DomainPackage get domainPackage =>
      _domainPackage ?? DomainPackage(project: this);

  @override
  InfrastructurePackage get infrastructurePackage =>
      _infrastructurePackage ?? InfrastructurePackage(project: this);

  @override
  LoggingPackage get loggingPackage =>
      _loggingPackage ?? LoggingPackage(project: this);

  @override
  late final PlatformDirectoryBuilder platformDirectory;

  @override
  UiPackage get uiPackage => _uiPackage ?? UiPackage(project: this);

  @override
  late final PlatformUiPackageBuilder platformUiPackage;

  @override
  String name() => melosFile.readName();

  @override
  bool existsAll() =>
      melosFile.exists() &&
      appPackage.exists() &&
      diPackage.exists() &&
      domainPackage.exists() &&
      infrastructurePackage.exists() &&
      loggingPackage.exists() &&
      uiPackage.exists();

  @override
  bool existsAny() =>
      melosFile.exists() ||
      appPackage.exists() ||
      diPackage.exists() ||
      domainPackage.exists() ||
      infrastructurePackage.exists() ||
      loggingPackage.exists() ||
      uiPackage.exists();

  @override
  bool platformIsActivated(Platform platform) {
    final platformDirectory = this.platformDirectory(platform: platform);
    final platformUiPackage = this.platformUiPackage(platform: platform);

    return platformDirectory.exists() || platformUiPackage.exists();
  }

  @override
  Future<void> create({
    required String projectName,
    required String description,
    required String orgName,
    required String language,
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
      language: language,
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
      await platformAppPackage.create(
        defaultLanguage: language,
        languages: {language},
        logger: logger,
      );

      final platformRoutingPackage = platformDirectory.routingFeaturePackage;
      await platformRoutingPackage.create(logger: logger);

      final platformHomePagePackage = platformDirectory.customFeaturePackage(
        name: 'home_page',
      );
      // TODO use description?
      await platformHomePagePackage.create(
        defaultLanguage: language,
        languages: {language},
        logger: logger,
      );

      final platformUiPackage = this.platformUiPackage(platform: platform);
      await platformUiPackage.create(logger: logger);
    }

    generateProgress.complete();

    await _melosBootstrap(cwd: path, logger: logger);
    await _dartFormatFix(cwd: path, logger: logger);
  }

  @override
  Future<void> addPlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required String language,
    required Logger logger,
  }) async {
    final generateProgress = logger.progress(
      'Generating ${platform.prettyName} files',
    );

    final platformDirectory = this.platformDirectory(platform: platform);

    final platformAppPackage = platformDirectory.appFeaturePackage;
    await platformAppPackage.create(
      defaultLanguage: language,
      languages: {language},
      logger: logger,
    );

    final platformRoutingPackage = platformDirectory.routingFeaturePackage;
    await platformRoutingPackage.create(logger: logger);

    final platformHomePagePackage = platformDirectory.customFeaturePackage(
      name: 'home_page',
    );
    // TODO use description?
    await platformHomePagePackage.create(
      defaultLanguage: language,
      languages: {language},
      logger: logger,
    );

    final platformUiPackage = this.platformUiPackage(platform: platform);
    await platformUiPackage.create(logger: logger);

    generateProgress.complete();

    // TODO log inside the metohd pls
    await appPackage.addPlatform(
      platform,
      description: description,
      orgName: orgName,
      logger: logger,
    );

    // TODO log inside the metohd pls
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

  @override
  Future<void> removePlatform(
    Platform platform, {
    required Logger logger,
  }) async {
    final deleteProgress = logger.progress(
      'Deleting ${platform.prettyName} files',
    );

    await appPackage.removePlatform(platform, logger: logger);
    final platformUiPackage = this.platformUiPackage(platform: platform);
    platformUiPackage.delete(logger: logger);
    final platformDirectory = this.platformDirectory(platform: platform);
    final customFeaturesPackages = platformDirectory.customFeaturePackages();
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

  @override
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
      final appFeaturePackage = platformDirectory.appFeaturePackage;

      await customFeaturePackage.create(
        description: description,
        defaultLanguage: appFeaturePackage.defaultLanguage(),
        languages: appFeaturePackage.supportedLanguages(),
        logger: logger,
      );

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
        cwd: path,
        logger: logger,
        scope: [
          appPackage.packageName(),
          diPackage.packageName(),
          appFeaturePackage.packageName(),
          ...platformDirectory
              .customFeaturePackages()
              .map((e) => e.packageName()),
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

      await _dartFormatFix(cwd: path, logger: logger);
    }
  }

  @override
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
      appFeaturePackage,
      ...platformDirectory.customFeaturePackages(),
      routingFeaturePackage,
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
      cwd: path,
      logger: logger,
      scope: [
        appPackage.packageName(),
        diPackage.packageName(),
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

  @override
  Future<void> addLanguage(
    String language, {
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final appFeaturePackage = platformDirectory.appFeaturePackage;
    final customFeatures = platformDirectory.customFeaturePackages();

    if (!appFeaturePackage.exists() && customFeatures.isEmpty) {
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

    await appFeaturePackage.addLanguage(
      language: language,
      logger: logger,
    );
    for (final customFeature in customFeatures) {
      await customFeature.addLanguage(
        language: language,
        logger: logger,
      );
    }

    await _dartFormatFix(cwd: path, logger: logger);
  }

  @override
  Future<void> removeLanguage(
    String language, {
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final appFeaturePackage = platformDirectory.appFeaturePackage;
    final customFeatures = platformDirectory.customFeaturePackages();

    if (!appFeaturePackage.exists() && customFeatures.isEmpty) {
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

    await appFeaturePackage.removeLanguage(
      language: language,
      logger: logger,
    );
    for (final customFeature in customFeatures) {
      await customFeature.removeLanguage(
        language: language,
        logger: logger,
      );
    }

    await _dartFormatFix(cwd: path, logger: logger);
  }

  @override
  Future<void> setDefaultLanguage(
    String newDefaultLanguage, {
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(
      platform: platform,
    );
    final appFeaturePackage = platformDirectory.appFeaturePackage;
    final customFeatures = platformDirectory.customFeaturePackages();

    if (!appFeaturePackage.exists() && customFeatures.isEmpty) {
      throw NoFeaturesFound();
    }

    if (!platformDirectory.allFeaturesHaveSameLanguages()) {
      throw FeaturesHaveDiffrentLanguages();
    }

    if (!platformDirectory.allFeaturesHaveSameDefaultLanguage()) {
      throw FeaturesHaveDiffrentDefaultLanguage();
    }

    if (!customFeatures.first.supportsLanguage(newDefaultLanguage)) {
      throw FeaturesDoNotSupportLanguage();
    }

    if (customFeatures.first.defaultLanguage() == newDefaultLanguage) {
      throw DefaultLanguageAlreadySetToRequestedLanguage();
    }

    await appFeaturePackage.setDefaultLanguage(
      newDefaultLanguage,
      logger: logger,
    );
    for (final customFeature in customFeatures) {
      await customFeature.setDefaultLanguage(
        newDefaultLanguage,
        logger: logger,
      );
    }

    await _dartFormatFix(cwd: path, logger: logger);
  }

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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
      throw DataTransferObjectDoesNotExist();
    }

    dataTransferObject.delete(logger: logger);
  }

  @override
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

  @override
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

  @override
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

  @override
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

  @override
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
    platformUiPackage.themeExtensionsFile.addThemeExtension(widget);
  }

  @override
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

    platformUiPackage.themeExtensionsFile.removeThemeExtension(widget);
    widget.delete(logger: logger);
  }
}

class MelosFileImpl extends YamlFileImpl implements MelosFile {
  MelosFileImpl({required this.project})
      : super(
          path: project.path,
          name: 'melos',
        );

  @override
  final Project project;

  @override
  String readName() {
    try {
      return readValue(['name']);
    } catch (_) {
      throw ReadNameFailure();
    }
  }
}
