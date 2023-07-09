part of '../project.dart';

class PlatformNavigationPackage extends DartPackage {
  PlatformNavigationPackage({
    required this.projectName,
    required this.platform,
    required String path,
    required this.navigatorInterface,
  }) : super(path);

  factory PlatformNavigationPackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_${platform.name}',
      '${projectName}_${platform.name}_navigation',
    );
    navigatorInterface({required String name}) => NavigatorInterface(
          path: path,
          name: name,
        );

    return PlatformNavigationPackage(
      projectName: projectName,
      path: path,
      platform: platform,
      navigatorInterface: navigatorInterface,
    );
  }

  final String projectName;

  final Platform platform;

  final NavigatorInterface Function({required String name}) navigatorInterface;

  DartFile get barrelFile => DartFile(
      p.join(path, 'lib', '${projectName}_${platform.name}_navigation.dart'));

  Future<void> generate() async {
    await mason.generate(
      bundle: platformNavigationPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'platform': platform.name,
      },
    );
  }
}
