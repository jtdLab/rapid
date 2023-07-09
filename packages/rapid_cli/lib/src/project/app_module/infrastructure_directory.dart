part of '../project.dart';

class InfrastructureDirectory extends Directory {
  InfrastructureDirectory({
    required this.projectName,
    required String path,
    required this.infrastructurePackage,
  }) : super(path);

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
    infrastructurePackage({String? name}) => InfrastructurePackage.resolve(
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

  final String projectName;

  final InfrastructurePackage Function({String? name}) infrastructurePackage;
}
