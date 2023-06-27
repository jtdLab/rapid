import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_feature_package/platform_feature_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_root_package/platform_root_package.dart';
import 'package:rapid_cli/src/project/project.dart';

import '../project_config.dart';
import 'core/generator_mixins.dart';
import 'di_package/di_package.dart';
import 'domain_directory/domain_directory.dart';
import 'infrastructure_directory/infrastructure_directory.dart';
import 'logging_package/logging_package.dart';
import 'platform_directory/platform_directory.dart';
import 'platform_ui_package/platform_ui_package.dart';
import 'project_bundle.dart';
import 'ui_package/ui_package.dart';

/// {@template rapid_project_impl}
/// Abstraction of a Rapid project.
/// {@endtemplate}
class RapidProjectImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements RapidProject {
  /// {@macro rapid_project_impl}
  RapidProjectImpl({
    required this.config,
  })  : name = config.name,
        super(path: config.path);

  @override
  final String name;

  @override
  final RapidProjectConfig config;

  @override
  late final DiPackage diPackage = DiPackage(project: this);

  @override
  late final DomainDirectory domainDirectory = DomainDirectory(project: this);

  @override
  late final InfrastructureDirectory infrastructureDirectory =
      InfrastructureDirectory(project: this);

  @override
  late final LoggingPackage loggingPackage = LoggingPackage(project: this);

  @override
  T platformDirectory<T extends PlatformDirectory>({
    required Platform platform,
  }) =>
      (platform == Platform.ios
          ? IosDirectory(project: this)
          : platform == Platform.mobile
              ? MobileDirectory(project: this)
              : NoneIosDirectory(platform, project: this)) as T;

  @override
  late final UiPackage uiPackage = UiPackage(project: this);

  @override
  PlatformUiPackage platformUiPackage({required Platform platform}) =>
      PlatformUiPackage(
        platform,
        project: this,
      );

  @override
  bool platformIsActivated(Platform platform) {
    final platformDirectory = this.platformDirectory(platform: platform);
    final platformUiPackage = this.platformUiPackage(platform: platform);

    return platformDirectory.exists() || platformUiPackage.exists();
  }

  @override
  List<DartPackage> get packages {
    final activePlatforms =
        Platform.values.where((platform) => platformIsActivated(platform));

    return [
      diPackage,
      loggingPackage,
      ...domainDirectory.domainPackages(),
      ...infrastructureDirectory.infrastructurePackages(),
      ...activePlatforms.map(
        (platform) => platformDirectory(platform: platform).navigationPackage,
      ),
      ...activePlatforms.map(
        (platform) => platformDirectory(platform: platform).rootPackage,
      ),
      ...activePlatforms
          .map((platform) => platformDirectory(platform: platform)
              .featuresDirectory
              .featurePackages())
          .fold<List<DartPackage>>([], (p, e) => p + e),
      ...activePlatforms.map(
        (platform) => platformUiPackage(platform: platform),
      ),
      uiPackage,
    ];
  }

  @override
  List<PlatformFeaturePackage> get featurePackages {
    final activePlatforms =
        Platform.values.where((platform) => platformIsActivated(platform));

    return activePlatforms
        .map((platform) => platformDirectory(platform: platform)
            .featuresDirectory
            .featurePackages())
        .fold<List<PlatformFeaturePackage>>([], (p, e) => p + e).toList();
  }

  @override
  List<PlatformRootPackage> get rootPackages {
    final activePlatforms =
        Platform.values.where((platform) => platformIsActivated(platform));

    return activePlatforms
        .map(
          (platform) => platformDirectory(platform: platform).rootPackage,
        )
        .toList();
  }

  @override
  Future<void> create({
    required String projectName,
    required String description,
    required String orgName,
    required Language language,
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
      } else if (platform == Platform.mobile) {
        final platformDirectory =
            this.platformDirectory<MobileDirectory>(platform: platform);
        await platformDirectory.create(
          orgName: orgName,
          language: language,
          description: description,
        );
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
