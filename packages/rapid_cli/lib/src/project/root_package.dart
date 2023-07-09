part of 'project.dart';

class RootPackage extends DartPackage {
  RootPackage({
    required this.projectName,
    required String path,
  }) : super(path);

  factory RootPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(projectPath);

    return RootPackage(
      projectName: projectName,
      path: path,
    );
  }

  final String projectName;

  Future<void> generate() async {
    await mason.generate(
      bundle: rootPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
    );
  }
}
