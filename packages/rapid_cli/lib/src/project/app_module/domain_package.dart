part of '../project.dart';

// TODO(jtdLab): doc nullable domain name -> default.

/// {@template domain_package}
/// Abstraction of a domain package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class DomainPackage extends DartPackage implements Comparable<DomainPackage> {
  /// {@macro domain_package}
  DomainPackage({
    required this.projectName,
    required String path,
    required this.name,
    required this.entity,
    required this.serviceInterface,
    required this.valueObject,
  }) : super(path);

  /// Returns a [DomainPackage] with [name] from given [projectName]
  /// and [projectPath].
  factory DomainPackage.resolve({
    required String projectName,
    required String projectPath,
    required String? name,
  }) {
    final selfName = name;
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_domain',
      '${projectName}_domain${name != null ? '_$name' : ''}',
    );
    Entity entity({required String name}) => Entity(
          projectName: projectName,
          path: path,
          name: name,
          subDomainName: selfName,
        );
    ServiceInterface serviceInterface({required String name}) =>
        ServiceInterface(projectName: projectName, path: path, name: name);
    ValueObject valueObject({required String name}) => ValueObject(
          projectName: projectName,
          path: path,
          name: name,
          subDomainName: selfName,
        );

    return DomainPackage(
      projectName: projectName,
      path: path,
      name: name,
      entity: entity,
      serviceInterface: serviceInterface,
      valueObject: valueObject,
    );
  }

  /// The name of the project this package is part of.
  final String projectName;

  /// The name of this domain package.
  final String? name;

  /// The entity builder.
  final Entity Function({required String name}) entity;

  /// The service interface builder.
  final ServiceInterface Function({required String name}) serviceInterface;

  /// The value object builder.
  final ValueObject Function({required String name}) valueObject;

  /// The `lib/<project-name>_domain[_<name>].dart` file.
  DartFile get barrelFile => DartFile(
        p.join(
          path,
          'lib',
          '${projectName}_domain${name != null ? '_$name' : ''}.dart',
        ),
      );

  /// Generate this package on disk.
  Future<void> generate() async {
    await mason.generate(
      bundle: domainPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'has_name': name != null,
      },
    );
  }

  @override
  int compareTo(DomainPackage other) {
    if (name == null) {
      if (other.name == null) return 0;
      return -1;
    } else if (other.name == null) {
      if (name == null) return 0;
      return 1;
    }

    return name!.compareTo(other.name!);
  }
}
