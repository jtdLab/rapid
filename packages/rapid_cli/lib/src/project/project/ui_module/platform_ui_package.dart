part of '../../project.dart';

class PlatformUiPackage extends UiPackage {
  PlatformUiPackage({
    required super.projectName,
    required this.platform,
    required super.path,
    required super.widget,
    required super.themedWidget,
  });

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
    widget({required String name}) => Widget(
        projectName: projectName, platform: platform, name: name, path: path);
    themedWidget({required String name}) => ThemedWidget(
        projectName: projectName, platform: platform, name: name, path: path);

    return PlatformUiPackage(
      projectName: projectName,
      platform: platform,
      path: path,
      widget: widget,
      themedWidget: themedWidget,
    );
  }

  final Platform platform;

  @override
  Future<void> generate() async {
    await mason.generate(
      bundle: platformUiPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'platform': platform.name,
      },
    );
  }
}
