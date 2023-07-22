part of '../project.dart';

class DiPackage extends DartPackage {
  DiPackage({
    required this.projectName,
    required String path,
  }) : super(path);

  factory DiPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path =
        p.join(projectPath, 'packages', projectName, '${projectName}_di');

    return DiPackage(
      projectName: projectName,
      path: path,
    );
  }

  Future<void> generate() async {
    await mason.generate(
      bundle: diPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
    );
  }

  final String projectName;
}
