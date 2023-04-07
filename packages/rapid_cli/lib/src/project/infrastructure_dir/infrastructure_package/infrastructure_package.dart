import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_dir/infrastructure_package/infrastructure_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

typedef InfrastructurePackageBuilder = InfrastructurePackage Function({
  String? name,
  required Project project,
});

/// {@template infrastructure_package}
/// Abstraction of a infrastructure package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_infrastructure/<project name>_infrastructure_<name>`
/// {@endtemplate}
abstract class InfrastructurePackage
    implements DartPackage, OverridableGenerator {
  /// {@macro infrastructure_package}
  factory InfrastructurePackage({
    String? name,
    required Project project,
  }) =>
      InfrastructurePackageImpl(
        name: name,
        project: project,
      );

  @visibleForTesting
  DomainPackageBuilder? domainPackageOverrides;

  @visibleForTesting
  EntityBuilder? entityOverrides;

  @visibleForTesting
  ServiceInterfaceBuilder? serviceInterfaceOverrides;

  @visibleForTesting
  DataTransferObjectBuilder? dataTransferObjectOverrides;

  @visibleForTesting
  ServiceImplementationBuilder? serviceImplementationOverrides;

  String? get name;

  Project get project;

  DataTransferObject dataTransferObject({
    required String name,
    required String dir,
  });

  ServiceImplementation serviceImplementation({
    required String name,
    required String serviceName,
    required String dir,
  });

  Future<void> create();

  // TODO consider required !

  Future<DataTransferObject> addDataTransferObject({
    required String name,
    required String dir,
  });

  Future<DataTransferObject> removeDataTransferObject({
    required String name,
    required String dir,
  });

  Future<ServiceImplementation> addServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
  });

  Future<ServiceImplementation> removeServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
  });
}

typedef DataTransferObjectBuilder = DataTransferObject Function({
  required String name,
  required String dir,
  required InfrastructurePackage infrastructurePackage,
});

/// {@template data_transfer_object}
/// Abstraction of a data transfer object of a infrastructure package of a Rapid project.
/// {@endtemplate}
abstract class DataTransferObject
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro data_transfer_object}
  factory DataTransferObject({
    required String name,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  }) =>
      DataTransferObjectImpl(
        name: name,
        dir: dir,
        infrastructurePackage: infrastructurePackage,
      );

  Future<void> create();
}

typedef ServiceImplementationBuilder = ServiceImplementation Function({
  required String name,
  required String serviceName,
  required String dir,
  required InfrastructurePackage infrastructurePackage,
});

/// {@template service_implementation}
/// Abstraction of a service implementation of a infrastructure package of a Rapid project.
/// {@endtemplate}
abstract class ServiceImplementation
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro service_implementation}
  factory ServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  }) =>
      ServiceImplementationImpl(
        name: name,
        serviceName: serviceName,
        dir: dir,
        infrastructurePackage: infrastructurePackage,
      );

  Future<void> create();
}