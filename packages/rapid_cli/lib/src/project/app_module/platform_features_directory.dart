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
      } else {
        // TODO using else is wrong throw error in else and add else if clause for widget
        return PlatformWidgetFeaturePackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          platform: platform,
          name: name.replaceAll('_widget', ''),
        ) as T;
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
}