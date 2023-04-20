import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/directory_impl.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_features_directory/platform_features_directory.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_navigation_package/platform_navigation_package.dart';
import 'package:rapid_cli/src/project/platform_directory/platform_root_package/platform_root_package.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'platform_directory.dart';

abstract class PlatformDirectoryImpl extends DirectoryImpl
    implements PlatformDirectory {
  PlatformDirectoryImpl(
    this.platform, {
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_${platform.name}',
          ),
        );

  @override
  PlatformNavigationPackageBuilder? navigationPackageOverrides;

  @override
  PlatformFeaturesDirectoryBuilder? featuresDirectoryOverrides;

  @override
  final Platform platform;

  @override
  final Project project;

  @override
  PlatformNavigationPackage get navigationPackage =>
      (navigationPackageOverrides ?? PlatformNavigationPackage.new)(
        platform,
        project: project,
      );

  @override
  PlatformFeaturesDirectory get featuresDirectory =>
      (featuresDirectoryOverrides ?? PlatformFeaturesDirectory.new)(
        platform,
        project: project,
      );
}

class NoneIosDirectoryImpl extends PlatformDirectoryImpl
    implements NoneIosDirectory {
  NoneIosDirectoryImpl(
    super.platform, {
    required super.project,
  }) : assert(platform != Platform.ios);

  @override
  NoneIosRootPackageBuilder? rootPackageOverrides;

  @override
  NoneIosRootPackage get rootPackage =>
      (rootPackageOverrides ?? NoneIosRootPackage.new)(
        platform,
        project: project,
      );

  @override
  Future<void> create({
    String? description,
    String? orgName,
    required String language,
  }) async {
    await rootPackage.create(description: description, orgName: orgName);

    await navigationPackage.create();

    final appFeaturePackage = featuresDirectory.featurePackage(name: 'app');
    await appFeaturePackage.create(
      description: 'The App feature.', // TODO platform info
      defaultLanguage: language,
      languages: {language},
    );

    final homePageFeaturePackage =
        featuresDirectory.featurePackage(name: 'home_page');
    await homePageFeaturePackage.create(
      description: 'The Home Page feature.', // TODO platform info
      defaultLanguage: language,
      languages: {language},
    );
  }
}

class IosDirectoryImpl extends PlatformDirectoryImpl implements IosDirectory {
  IosDirectoryImpl({
    required super.project,
  }) : super(Platform.ios);

  @override
  IosRootPackageBuilder? rootPackageOverrides;

  @override
  IosRootPackage get rootPackage =>
      (rootPackageOverrides ?? IosRootPackage.new)(
        project: project,
      );

  @override
  Future<void> create({
    required String orgName,
    required String language,
  }) async {
    await rootPackage.create(orgName: orgName, language: language);

    await navigationPackage.create();

    final appFeaturePackage = featuresDirectory.featurePackage(name: 'app');
    await appFeaturePackage.create(
      description: 'The App feature.', // TODO platform info
      defaultLanguage: language,
      languages: {language},
    );

    final homePageFeaturePackage =
        featuresDirectory.featurePackage(name: 'home_page');
    await homePageFeaturePackage.create(
      description: 'The Home Page feature.', // TODO platform info
      defaultLanguage: language,
      languages: {language},
    );
  }
}
