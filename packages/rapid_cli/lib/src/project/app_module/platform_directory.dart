part of '../project.dart';

/// {@template platform_directory}
/// Abstraction of a platform directory of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformDirectory extends Directory {
  /// {@macro platform_directory}
  PlatformDirectory({
    required this.platform,
    required String path,
    required this.rootPackage,
    required this.localizationPackage,
    required this.navigationPackage,
    required this.featuresDirectory,
  }) : super(path);

  /// Returns a [PlatformDirectory] with [platform] from given [projectName]
  /// and [projectPath].
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

  /// The platform.
  final Platform platform;

  /// The platform root package.
  final PlatformRootPackage rootPackage;

  /// The platform localization package.
  final PlatformLocalizationPackage localizationPackage;

  /// The platform navigation package.
  final PlatformNavigationPackage navigationPackage;

  /// The platform features directory.
  final PlatformFeaturesDirectory featuresDirectory;
}
