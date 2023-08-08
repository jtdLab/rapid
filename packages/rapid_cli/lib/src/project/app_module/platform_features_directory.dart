part of '../project.dart';

/// {@template platform_features_directory}
/// Abstraction of a platform features directory of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformFeaturesDirectory extends Directory {
  /// {@macro platform_features_directory}
  PlatformFeaturesDirectory({
    required this.projectName,
    required this.platform,
    required String path,
    required this.appFeaturePackage,
    required this.featurePackage,
  }) : super(path);

  /// Returns a [PlatformFeaturesDirectory] with [platform] from
  /// given [projectName] and [projectPath].
  factory PlatformFeaturesDirectory.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_features',
    );
    final appFeaturePackage = PlatformAppFeaturePackage.resolve(
      projectName: projectName,
      projectPath: projectPath,
      platform: platform,
    );
    T featurePackage<T extends PlatformFeaturePackage>({required String name}) {
      if (name.endsWith('page')) {
        return PlatformPageFeaturePackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          platform: platform,
          name: name.replaceAll('_page', ''),
        ) as T;
      } else if (name.endsWith('tab_flow')) {
        return PlatformTabFlowFeaturePackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          platform: platform,
          name: name.replaceAll('_tab_flow', ''),
        ) as T;
      } else if (name.endsWith('flow')) {
        return PlatformFlowFeaturePackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          platform: platform,
          name: name.replaceAll('_flow', ''),
        ) as T;
      } else if (name.endsWith('widget')) {
        return PlatformWidgetFeaturePackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          platform: platform,
          name: name.replaceAll('_widget', ''),
        ) as T;
      } else {
        throw ArgumentError.value(name, 'name', 'is invalid');
      }
    }

    return PlatformFeaturesDirectory(
      projectName: projectName,
      platform: platform,
      path: path,
      appFeaturePackage: appFeaturePackage,
      featurePackage: featurePackage,
    );
  }

  /// The name of the project this directory is part of.
  final String projectName;

  /// The platform.
  final Platform platform;

  /// The platform app feature package.
  final PlatformAppFeaturePackage appFeaturePackage;

  /// The platform feature package builder.
  T Function<T extends PlatformFeaturePackage>({required String name})
      featurePackage;

  /// Returns all platform feature packages of this platform features directory.
  ///
  /// This function interprets every direct sub directory as a platform feature
  /// package and expects it to have the following name pattern
  /// `<project-name>_<platform>_[_<feature-name>_[page|flow|tab_flow|widget]]`.
  List<PlatformFeaturePackage> featurePackages() {
    return (existsSync()
        ? listSync()
            .whereType<Directory>()
            .map((dir) => p.basename(dir.path))
            .where(
              (basename) =>
                  basename.endsWith('page') ||
                  basename.endsWith('flow') ||
                  basename.endsWith('widget'),
            )
            .map(
              (basename) => featurePackage(
                name:
                    basename.replaceAll('${projectName}_${platform.name}_', ''),
              ),
            )
            .toList()
        : [])
      ..sort();
  }
}
