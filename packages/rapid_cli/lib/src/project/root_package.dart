part of 'project.dart';

/// {@template root_package}
/// Abstraction of the root package of a Rapid project.
///
// TODO(jtdLab): more docs
/// {@endtemplate}
class RootPackage extends DartPackage {
  /// {@macro root_package}
  RootPackage({
    required this.projectName,
    required String path,
  }) : super(path);

  /// Returns a [RootPackage] from given [projectName] and [projectPath].
  factory RootPackage.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = projectPath;

    return RootPackage(
      projectName: projectName,
      path: path,
    );
  }

  /// The name of the project this package is part of.
  final String projectName;

  /// Generate this package on disk.
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
