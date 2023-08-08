part of '../project.dart';

/// {@template platform_ui_package}
/// Abstraction of a platform ui package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class PlatformUiPackage extends UiPackage {
  /// {@macro platform_ui_package}
  PlatformUiPackage({
    required super.projectName,
    required this.platform,
    required super.path,
    required super.widget,
    required super.themedWidget,
  });

  /// Returns a [PlatformUiPackage] with [platform] from
  /// given [projectName] and [projectPath].
  factory PlatformUiPackage.resolve({
    required String projectName,
    required String projectPath,
    required Platform platform,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      '${projectName}_ui',
      '${projectName}_ui_${platform.name}',
    );
    Widget widget({required String name}) => Widget(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
        );
    ThemedWidget themedWidget({required String name}) => ThemedWidget(
          projectName: projectName,
          platform: platform,
          name: name,
          path: path,
        );

    return PlatformUiPackage(
      projectName: projectName,
      platform: platform,
      path: path,
      widget: widget,
      themedWidget: themedWidget,
    );
  }

  /// The platform.
  final Platform platform;

  @override
  DartFile get barrelFile =>
      DartFile(p.join(path, 'lib', '${projectName}_ui_${platform.name}.dart'));

  @override
  Future<void> generate() async {
    await mason.generate(
      bundle: platformUiPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        ...platformVars(platform),
      },
    );
  }
}
