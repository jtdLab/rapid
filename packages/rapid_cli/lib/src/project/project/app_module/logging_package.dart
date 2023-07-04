part of '../../project.dart';

class LoggingPackage extends DartPackage {
  LoggingPackage({
    required this.projectName,
    required String path,
  }) : super(path);

  factory LoggingPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path =
        p.join(projectPath, 'packages', projectName, '${projectName}_logging');

    return LoggingPackage(
      projectName: projectName,
      path: path,
    );
  }

  final String projectName;

  Future<void> generate() async {
    await mason.generate(
      bundle: loggingPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
    );
  }
}
