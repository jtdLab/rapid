part of '../../project.dart';

class DomainDirectory extends Directory {
  DomainDirectory({
    required this.projectName,
    required String path,
    required this.domainPackage,
  }) : super(path);

  factory DomainDirectory.resolve({
    required String projectName,
    required String projectPath,
  }) {
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_domain',
    );
    domainPackage({String? name}) => DomainPackage.resolve(
          projectName: projectName,
          projectPath: projectPath,
          name: name,
        );

    return DomainDirectory(
      projectName: projectName,
      path: path,
      domainPackage: domainPackage,
    );
  }

  final String projectName;

  final DomainPackage Function({String? name}) domainPackage;
}
