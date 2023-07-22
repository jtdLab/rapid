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
