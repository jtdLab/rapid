part of '../project.dart';

class DomainPackage extends DartPackage {
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
    entity({required String name}) => Entity(
          projectName: projectName,
          path: path,
          name: name,
          subDomainName: selfName,
        );
    serviceInterface({required String name}) =>
        ServiceInterface(projectName: projectName, path: path, name: name);
    valueObject({required String name}) => ValueObject(
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

  DartFile get barrelFile => DartFile(p.join(path, 'lib',
      '${projectName}_domain${name != null ? '_$name' : ''}.dart'));

  Future<void> generate() async {
    await mason.generate(
      bundle: domainPackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
      },
    );
  }
}
