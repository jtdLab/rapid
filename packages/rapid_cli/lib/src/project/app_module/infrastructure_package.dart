part of '../project.dart';

class InfrastructurePackage extends DartPackage
    implements Comparable<InfrastructurePackage> {
  InfrastructurePackage({
    required this.projectName,
    required String path,
    required this.name,
    required this.dataTransferObject,
    required this.serviceImplementation,
  }) : super(path);

  factory InfrastructurePackage.resolve({
    required String projectName,
    required String projectPath,
    required String? name,
  }) {
    final selfName = name;
    final path = p.join(
      projectPath,
      'packages',
      projectName,
      '${projectName}_infrastructure',
      '${projectName}_infrastructure${name != null ? '_$name' : ''}',
    );
    DataTransferObject dataTransferObject({required String entityName}) =>
        DataTransferObject(
          projectName: projectName,
          path: path,
          entityName: entityName,
          subInfrastructureName: selfName,
        );
    ServiceImplementation serviceImplementation({
      required String name,
      required String serviceInterfaceName,
    }) =>
        ServiceImplementation(
          projectName: projectName,
          path: path,
          name: name,
          serviceInterfaceName: serviceInterfaceName,
          subInfrastructureName: selfName,
        );

    return InfrastructurePackage(
      projectName: projectName,
      path: path,
      name: selfName,
      dataTransferObject: dataTransferObject,
      serviceImplementation: serviceImplementation,
    );
  }

  final String projectName;

  final String? name;

  final DataTransferObject Function({required String entityName})
      dataTransferObject;

  final ServiceImplementation Function({
    required String name,
    required String serviceInterfaceName,
  }) serviceImplementation;

  DartFile get barrelFile => DartFile(
        p.join(
          path,
          'lib',
          '${projectName}_infrastructure${name != null ? '_$name' : ''}.dart',
        ),
      );

  Future<void> generate() async {
    await mason.generate(
      bundle: infrastructurePackageBundle,
      target: this,
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'has_name': name != null,
      },
    );
  }

  @override
  int compareTo(InfrastructurePackage other) {
    if (name == null) {
      if (other.name == null) return 0;
      return -1;
    } else if (other.name == null) {
      if (name == null) return 0;
      return 1;
    }

    return name!.compareTo(other.name!);
  }

  bool get isDefault => name == null;
}
