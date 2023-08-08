part of '../project.dart';

/// {@template di_package}
/// Abstraction of the di package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class DiPackage extends DartPackage {
  /// {@macro di_package}
  DiPackage({
    required this.projectName,
    required String path,
  }) : super(path);

  /// Returns a [DiPackage] from given [projectName] and [projectPath].
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

  /// Generate this package on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: diPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
      },
    );
  }

  /// The name of the project this package is part of.
  final String projectName;
}
