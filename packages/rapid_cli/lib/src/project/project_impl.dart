import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_directory.dart';
import 'package:rapid_cli/src/project/infrastructure_dir/infrastructure_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package.dart';

import 'di_package/di_package.dart';
import 'logging_package/logging_package.dart';
import 'project.dart';
import 'project_bundle.dart';
import 'ui_package/ui_package.dart';

class ProjectImpl extends DirectoryImpl
    with OverridableGenerator, Generatable
    implements Project {
  ProjectImpl({super.path});

  @override
  MelosFileBuilder? melosFileOverrides;

  @override
  DiPackageBuilder? diPackageOverrides;

  @override
  DomainDirectoryBuilder? domainDirectoryOverrides;

  @override
  InfrastructureDirectoryBuilder? infrastructureDirectoryOverrides;

  @override
  LoggingPackageBuilder? loggingPackageOverrides;

  @override
  PlatformDirectoryBuilder? platformDirectoryOverrides;

  @override
  UiPackageBuilder? uiPackageOverrides;

  @override
  PlatformUiPackageBuilder? platformUiPackageOverrides;

  @override
  MelosFile get melosFile =>
      (melosFileOverrides ?? MelosFile.new)(project: this);

  @override
  DiPackage get diPackage =>
      (diPackageOverrides ?? DiPackage.new)(project: this);

  @override
  DomainDirectory get domainDirectory =>
      (domainDirectoryOverrides ?? DomainDirectory.new)(
        project: this,
      );

  @override
  InfrastructureDirectory get infrastructureDirectory =>
      (infrastructureDirectoryOverrides ?? InfrastructureDirectory.new)(
        project: this,
      );

  @override
  LoggingPackage get loggingPackage =>
      (loggingPackageOverrides ?? LoggingPackage.new)(project: this);

  // TODO this sucks
  @override
  T platformDirectory<T extends PlatformDirectory>({
    required Platform platform,
  }) =>
      platformDirectoryOverrides?.call(platform: platform, project: this)
          as T? ??
      (platform == Platform.ios
          ? IosDirectory(project: this)
          : NoneIosDirectory(platform, project: this)) as T;

  @override
  UiPackage get uiPackage =>
      (uiPackageOverrides ?? UiPackage.new)(project: this);

  @override
  PlatformUiPackage platformUiPackage({required Platform platform}) =>
      (platformUiPackageOverrides ?? PlatformUiPackage.new)(
        platform,
        project: this,
      );

  @override
  String name() => melosFile.readName();

  @override
  bool existsAll() =>
      melosFile.exists() &&
      diPackage.exists() &&
      // TODO use domainDir.exists directly ?
      domainDirectory.domainPackage(name: '').exists() &&
      // TODO use infraDir.exists directly ?
      infrastructureDirectory.infrastructurePackage(name: '').exists() &&
      loggingPackage.exists() &&
      uiPackage.exists();

  @override
  bool existsAny() =>
      melosFile.exists() ||
      diPackage.exists() ||
      // TODO use domainDir.exists directly ?
      domainDirectory.domainPackage(name: '').exists() ||
      // TODO use infra.exists directly ?
      infrastructureDirectory.infrastructurePackage(name: '').exists() ||
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
    await generate(
      name: 'project',
      bundle: projectBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
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
    // TODO use domainDir.create directly
    await domainDirectory.domainPackage(name: '').create(logger: logger);
    // TODO use infraDir.create directly
    await infrastructureDirectory
        .infrastructurePackage(name: '')
        .create(logger: logger);
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
      // TODO use add platform method ?
      final platformUiPackage = this.platformUiPackage(platform: platform);
      await platformUiPackage.create(logger: logger);

      if (platform == Platform.ios) {
        final platformDirectory =
            this.platformDirectory<IosDirectory>(platform: platform);
        await platformDirectory.create(
          orgName: orgName,
          language: language,
          logger: logger,
        );
      } else {
        final platformDirectory =
            this.platformDirectory<NoneIosDirectory>(platform: platform);
        await platformDirectory.create(
          description: description,
          orgName: orgName,
          language: language,
          logger: logger,
        );
      }
    }
  }

  @override
  Future<void> addPlatform(
    Platform platform, {
    String? description,
    String? orgName,
    required String language,
    required Logger logger,
  }) async {
    if (platform == Platform.ios) {
      final platformDirectory =
          this.platformDirectory<IosDirectory>(platform: platform);
      await platformDirectory.create(
        orgName: orgName!, // TODO not good
        language: language,
        logger: logger,
      );
    } else {
      final platformDirectory =
          this.platformDirectory<NoneIosDirectory>(platform: platform);
      await platformDirectory.create(
        description: description,
        orgName: orgName,
        language: language,
        logger: logger,
      );
    }

    final platformUiPackage = this.platformUiPackage(platform: platform);
    await platformUiPackage.create(logger: logger);
  }

  @override
  Future<void> removePlatform(
    Platform platform, {
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    final platformUiPackage = this.platformUiPackage(platform: platform);
    platformDirectory.delete(logger: logger);
    platformUiPackage.delete(logger: logger);
  }

  @override
  Future<void> addFeature({
    required String name,
    required String description,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.addFeature(
      name: name,
      description: description,
      logger: logger,
    );
  }

  @override
  Future<void> removeFeature({
    required String name,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.removeFeature(name: name, logger: logger);
  }

  @override
  Future<void> addLanguage(
    String language, {
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.addLanguage(language, logger: logger);
  }

  @override
  Future<void> removeLanguage(
    String language, {
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.removeLanguage(language, logger: logger);
  }

  @override
  Future<void> setDefaultLanguage(
    String newDefaultLanguage, {
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.setDefaultLanguage(
      newDefaultLanguage,
      logger: logger,
    );
  }

  @override
  Future<void> addSubDomain({
    required String name,
    required Logger logger,
  }) async {
    final domainDirectory = this.domainDirectory;
    await domainDirectory.addDomainPackage(name: name);

    final infrastructureDirectory = this.infrastructureDirectory;
    await infrastructureDirectory.addInfrastructurePackage(name: name);
  }

  @override
  Future<void> removeSubDomain({
    required String name,
    required Logger logger,
  }) async {
    final domainDirectory = this.domainDirectory;
    await domainDirectory.removeDomainPackage(name: name);

    final infrastructureDirectory = this.infrastructureDirectory;
    await infrastructureDirectory.removenfrastructurePackage(name: name);
  }

  @override
  Future<void> addEntity({
    required String name,
    required String domainName,
    required String outputDir,
    required Logger logger,
  }) async {
    await domainDirectory.addEntity(
      name: name,
      domainName: domainName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeEntity({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  }) async {
    await domainDirectory.removeEntity(
      name: name,
      domainName: domainName,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> addServiceInterface({
    required String name,
    required String domainName,
    required String outputDir,
    required Logger logger,
  }) async {
    await domainDirectory.addServiceInterface(
      name: name,
      domainName: domainName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeServiceInterface({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  }) async {
    await domainDirectory.removeServiceInterface(
      name: name,
      domainName: domainName,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> addValueObject({
    required String name,
    required String domainName,
    required String outputDir,
    required String type,
    required String generics,
    required Logger logger,
  }) async {
    await domainDirectory.addValueObject(
      name: name,
      domainName: domainName,
      outputDir: outputDir,
      type: type,
      generics: generics,
      logger: logger,
    );
  }

  @override
  Future<void> removeValueObject({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  }) async {
    await domainDirectory.removeValueObject(
      name: name,
      domainName: domainName,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> addDataTransferObject({
    required String entityName,
    required String domainName,
    required String outputDir,
    required Logger logger,
  }) async {
    await infrastructureDirectory.addDataTransferObject(
      entityName: entityName,
      domainName: domainName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeDataTransferObject({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  }) async {
    await infrastructureDirectory.removeDataTransferObject(
      name: name,
      domainName: domainName,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> addServiceImplementation({
    required String name,
    required String domainName,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  }) async {
    await infrastructureDirectory.addServiceImplementation(
      name: name,
      domainName: domainName,
      serviceName: serviceName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeServiceImplementation({
    required String name,
    required String domainName,
    required String serviceName,
    required String dir,
    required Logger logger,
  }) async {
    await infrastructureDirectory.removeServiceImplementation(
      name: name,
      domainName: domainName,
      serviceName: serviceName,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> addBloc({
    required String name,
    required String featureName,
    required String outputDir,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.addBloc(
      name: name,
      featureName: featureName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeBloc({
    required String name,
    required String featureName,
    required String dir,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.removeBloc(
      name: name,
      featureName: featureName,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> addCubit({
    required String name,
    required String featureName,
    required String outputDir,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.addCubit(
      name: name,
      featureName: featureName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeCubit({
    required String name,
    required String featureName,
    required String dir,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformDirectory = this.platformDirectory(platform: platform);
    await platformDirectory.removeCubit(
      name: name,
      featureName: featureName,
      dir: dir,
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
    await platformUiPackage.addWidget(
      name: name,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeWidget({
    required String name,
    required String dir,
    required Platform platform,
    required Logger logger,
  }) async {
    final platformUiPackage = this.platformUiPackage(platform: platform);
    await platformUiPackage.removeWidget(name: name, dir: dir, logger: logger);
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
