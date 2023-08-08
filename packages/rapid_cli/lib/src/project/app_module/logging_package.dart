part of '../project.dart';

/// {@template logging_package}
/// Abstraction of the logging package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class LoggingPackage extends DartPackage {
  /// {@macro logging_package}
  LoggingPackage({
    required this.projectName,
    required String path,
  }) : super(path);

  /// Returns a [LoggingPackage] from given [projectName] and [projectPath].
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

  /// The name of the project this package is part of.
  final String projectName;

  /// Generate this package on disk.
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
