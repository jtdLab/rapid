part of '../../project.dart';

class PlatformDirectory extends Directory {
  PlatformDirectory({
    required this.platform,
    required String path,
    required this.rootPackage,
    required this.localizationPackage,
    required this.navigationPackage,
    required this.featuresDirectory,
  }) : super(path);

  factory PlatformDirectory.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
    );
    final featuresDirectory = PlatformFeaturesDirectory.resolve(
      projectName: projectName,
      projectPath: projectPath,
      platform: platform,
    );
    final localizationPackage = PlatformLocalizationPackage.resolve(
      projectName: projectName,
      projectPath: projectPath,
      platform: platform,
    );
    final navigationPackage = PlatformNavigationPackage.resolve(
      projectName: projectName,
      projectPath: projectPath,
      platform: platform,
    );
    final rootPackage = switch (platform) {
      Platform.ios => IosRootPackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
        ),
      Platform.macos => MacosRootPackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
        ),
      Platform.mobile => MobileRootPackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
        ),
      _ => NoneIosRootPackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          platform: platform,
        ),
    };

    return PlatformDirectory(
      platform: platform,
      path: path,
      featuresDirectory: featuresDirectory,
      localizationPackage: localizationPackage,
      navigationPackage: navigationPackage,
      rootPackage: rootPackage,
    );
  }

  final Platform platform;

  final PlatformRootPackage rootPackage;

  final PlatformLocalizationPackage localizationPackage;

  final PlatformNavigationPackage navigationPackage;

  final PlatformFeaturesDirectory featuresDirectory;
}
