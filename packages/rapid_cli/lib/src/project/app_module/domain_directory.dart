part of '../project.dart';

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

  List<DomainPackage> domainPackages() {
    return (existsSync()
        ? listSync().whereType<Directory>().map(
            (e) {
              final basename = p.basename(e.path);
              if (!basename.startsWith('${projectName}_domain_')) {
                return domainPackage(name: null);
              }

              final name =
                  p.basename(e.path).replaceAll('${projectName}_domain_', '');
              return domainPackage(name: name);
            },
          ).toList()
        : [])
      ..sort();
  }
}
