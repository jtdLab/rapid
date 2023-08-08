part of '../project.dart';

/// {@template infrastructure_directory}
/// Abstraction of the infrastructure directory of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class InfrastructureDirectory extends Directory {
  /// {@macro infrastructure_directory}
  InfrastructureDirectory({
    required this.projectName,
    required String path,
    required this.infrastructurePackage,
  }) : super(path);

  /// Returns a [InfrastructureDirectory] from given [projectName]
  /// and [projectPath].
  factory InfrastructureDirectory.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_infrastructure',
    );
    InfrastructurePackage infrastructurePackage({String? name}) =>
        InfrastructurePackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          name: name,
        );

    return InfrastructureDirectory(
      projectName: projectName,
      path: path,
      infrastructurePackage: infrastructurePackage,
    );
  }

  /// The name of the project this directory is part of.
  final String projectName;

  /// The infrastructure package builder.
  final InfrastructurePackage Function({String? name}) infrastructurePackage;

  /// Returns all infrastructure packages of this infrastructure directory.
  ///
  /// This function interprets every direct sub directory as a infrastructure
  /// package and expects it to have the following name pattern
  /// `<project-name>_infrastructure[_<infrastructure-name>]`.
  List<InfrastructurePackage> infrastructurePackages() {
    return (existsSync()
        ? listSync().whereType<Directory>().map(
            (e) {
              final basename = p.basename(e.path);
              if (!basename.startsWith('${projectName}_infrastructure_')) {
                return infrastructurePackage(name: null);
              }

              final name = p
                  .basename(e.path)
                  .replaceAll('${projectName}_infrastructure_', '');
              return infrastructurePackage(name: name);
            },
          ).toList()
        : [])
      ..sort();
  }
}
