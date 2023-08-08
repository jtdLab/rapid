part of '../project.dart';

/// {@template platform_navigation_package}
/// Abstraction of a platform navigation package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformNavigationPackage extends DartPackage {
  /// {@macro platform_navigation_package}
  PlatformNavigationPackage({
    required this.projectName,
    required this.platform,
    required String path,
    required this.navigatorInterface,
  }) : super(path);

  /// Returns a [PlatformNavigationPackage] with [platform] from
  /// given [projectName] and [projectPath].
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
    NavigatorInterface navigatorInterface({required String name}) =>
        NavigatorInterface(
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

  /// The name of the project this package is part of.
  final String projectName;

  /// The platform.
  final Platform platform;

  /// The navigator interface builder.
  final NavigatorInterface Function({required String name}) navigatorInterface;

  /// The `lib/<project-name>_<platform>_navigation.dart` file.
  DartFile get barrelFile => DartFile(
        p.join(path, 'lib', '${projectName}_${platform.name}_navigation.dart'),
      );

  /// Generate this package on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: platformNavigationPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        ...platformVars(platform),
      },
    );
  }
}
