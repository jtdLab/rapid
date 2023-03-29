import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/core/yaml_file_impl.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_directory.dart';
import 'package:rapid_cli/src/project/platform_ui_package/platform_ui_package.dart';

import 'di_package/di_package.dart';
import 'infrastructure_package/infrastructure_package.dart';
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
  DomainPackageBuilder? domainPackageOverrides;

  @override
  InfrastructurePackageBuilder? infrastructurePackageOverrides;

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
  DomainPackage get domainPackage =>
      (domainPackageOverrides ?? DomainPackage.new)(project: this);

  @override
  InfrastructurePackage get infrastructurePackage =>
      (infrastructurePackageOverrides ?? InfrastructurePackage.new)(
        project: this,
        domainPackage: domainPackage,
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
      domainPackage.exists() &&
      infrastructurePackage.exists() &&
      loggingPackage.exists() &&
      uiPackage.exists();

  @override
  bool existsAny() =>
      melosFile.exists() ||
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
  Future<void> addEntity({
    required String name,
    required String outputDir,
    required Logger logger,
  }) async {
    await domainPackage.addEntity(
      name: name,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeEntity({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    await domainPackage.removeEntity(name: name, dir: dir, logger: logger);
  }

  @override
  Future<void> addServiceInterface({
    required String name,
    required String outputDir,
    required Logger logger,
  }) async {
    await domainPackage.addServiceInterface(
      name: name,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeServiceInterface({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    await domainPackage.removeServiceInterface(
      name: name,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> addValueObject({
    required String name,
    required String outputDir,
    required String type,
    required String generics,
    required Logger logger,
  }) async {
    await domainPackage.addValueObject(
      name: name,
      outputDir: outputDir,
      type: type,
      generics: generics,
      logger: logger,
    );
  }

  @override
  Future<void> removeValueObject({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    await domainPackage.removeValueObject(name: name, dir: dir, logger: logger);
  }

  @override
  Future<void> addDataTransferObject({
    required String entityName,
    required String outputDir,
    required Logger logger,
  }) async {
    await infrastructurePackage.addDataTransferObject(
      entityName: entityName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeDataTransferObject({
    required String name,
    required String dir,
    required Logger logger,
  }) async {
    await infrastructurePackage.removeDataTransferObject(
      name: name,
      dir: dir,
      logger: logger,
    );
  }

  @override
  Future<void> addServiceImplementation({
    required String name,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  }) async {
    await infrastructurePackage.addServiceImplementation(
      name: name,
      serviceName: serviceName,
      outputDir: outputDir,
      logger: logger,
    );
  }

  @override
  Future<void> removeServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
    required Logger logger,
  }) async {
    await infrastructurePackage.removeServiceImplementation(
      name: name,
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
