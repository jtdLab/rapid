part of '../project.dart';

class DomainPackage extends DartPackage implements Comparable<DomainPackage> {
  DomainPackage({
    required this.projectName,
    required String path,
    required this.name,
    required this.entity,
    required this.serviceInterface,
    required this.valueObject,
  }) : super(path);

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

  final String projectName;

  final String? name;

  final Entity Function({required String name}) entity;

  final ServiceInterface Function({required String name}) serviceInterface;

  final ValueObject Function({required String name}) valueObject;

  DartFile get barrelFile => DartFile(
        p.join(
          path,
          'lib',
          '${projectName}_domain${name != null ? '_$name' : ''}.dart',
        ),
      );

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
