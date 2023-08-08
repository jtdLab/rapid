part of '../project.dart';

// TODO(jtdLab): doc nullable infrastructue name -> default.

/// {@template infrastructure_package}
/// Abstraction of an infrastructure package of a Rapid project.
///
// TODO(jtdLab): more docs.
/// {@endtemplate}
class InfrastructurePackage extends DartPackage
    implements Comparable<InfrastructurePackage> {
  /// {@macro infrastructure_package}
  InfrastructurePackage({
    required this.projectName,
    required String path,
    required this.name,
    required this.dataTransferObject,
    required this.serviceImplementation,
  }) : super(path);

  /// Returns a [InfrastructurePackage] with [name] from given [projectName]
  /// and [projectPath].
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

  /// The name of the project this package is part of.
  final String projectName;

  /// The name of this infrastructure package.
  final String? name;

  /// The data transfer object builder.
  final DataTransferObject Function({required String entityName})
      dataTransferObject;

  /// The service implementation builder.
  final ServiceImplementation Function({
    required String name,
    required String serviceInterfaceName,
  }) serviceImplementation;

  /// The `lib/<project-name>_infrastructure[_<name>].dart` file.
  DartFile get barrelFile => DartFile(
        p.join(
          path,
          'lib',
          '${projectName}_infrastructure${name != null ? '_$name' : ''}.dart',
        ),
      );

  /// Generate this package on disk.
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

  /// Returns `true` if this is the default infrastructure package.
  bool get isDefault => name == null;
}
