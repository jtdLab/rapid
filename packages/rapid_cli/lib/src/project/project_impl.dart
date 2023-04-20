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
      domainDirectory.domainPackage().exists() &&
      infrastructureDirectory.infrastructurePackage().exists() &&
      loggingPackage.exists() &&
      uiPackage.exists();

  @override
  bool existsAny() =>
      melosFile.exists() ||
      diPackage.exists() ||
      domainDirectory.domainPackage().exists() ||
      infrastructureDirectory.infrastructurePackage().exists() ||
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
    required Set<Platform> platforms,
  }) async {
    await generate(
      bundle: projectBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
    );

    await diPackage.create();

    // TODO use domainDir.create directly
    final domainPackage = domainDirectory.domainPackage();
    await domainPackage.create();

    // TODO use infraDir.create directly
    final infrastructurePackage =
        infrastructureDirectory.infrastructurePackage();
    infrastructurePackage.create();

    await loggingPackage.create();

    await uiPackage.create();

    for (final platform in platforms) {
      // TODO use add platform method ?
      final platformUiPackage = this.platformUiPackage(platform: platform);
      await platformUiPackage.create();

      if (platform == Platform.ios) {
        final platformDirectory =
            this.platformDirectory<IosDirectory>(platform: platform);
        await platformDirectory.create(orgName: orgName, language: language);
      } else {
        final platformDirectory =
            this.platformDirectory<NoneIosDirectory>(platform: platform);
        await platformDirectory.create(
          description: description,
          orgName: orgName,
          language: language,
        );
      }
    }
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
