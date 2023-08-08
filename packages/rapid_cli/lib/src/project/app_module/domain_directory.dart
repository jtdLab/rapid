part of '../project.dart';

/// {@template domain_directory}
/// Abstraction of the domain directory of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class DomainDirectory extends Directory {
  /// {@macro domain_directory}
  DomainDirectory({
    required this.projectName,
    required String path,
    required this.domainPackage,
  }) : super(path);

  /// Returns a [DomainDirectory] from given [projectName] and [projectPath].
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
    DomainPackage domainPackage({String? name}) => DomainPackage.resolve(
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

  /// The name of the project this directory is part of.
  final String projectName;

  /// The domain package builder.
  final DomainPackage Function({String? name}) domainPackage;

  /// Returns all domain packages of this domain directory.
  ///
  /// This function interprets every direct sub directory as a domain package
  /// and expects it to have the following name pattern
  /// `<project-name>_domain[_<domain-name>]`.
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
