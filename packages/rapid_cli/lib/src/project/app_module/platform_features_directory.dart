part of '../project.dart';

class PlatformFeaturesDirectory extends Directory {
  PlatformFeaturesDirectory({
    required this.projectName,
    required this.platform,
    required String path,
    required this.appFeaturePackage,
    required this.featurePackage,
  }) : super(path);

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
    featurePackage<T extends PlatformFeaturePackage>({required String name}) {
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
        throw FeaturePackageParseError._('${projectName}_$name');
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

  final String projectName;

  final Platform platform;

  final PlatformAppFeaturePackage appFeaturePackage;

  T Function<T extends PlatformFeaturePackage>({required String name})
      featurePackage;

  Future<void> generate() async {
    await appFeaturePackage.generate();
    await featurePackage<PlatformPageFeaturePackage>(name: 'home').generate();
  }

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

class FeaturePackageParseError extends Error {
  FeaturePackageParseError._(this.name);

  final String name;

  @override
  String toString() => 'Could not resolve feature package $name.';
}
