import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

typedef InfrastructurePackageBuilder = InfrastructurePackage Function({
  required Project project,
  required DomainPackage domainPackage,
});

/// {@template infrastructure_package}
/// Abstraction of the infrastructure package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_infrastructure`
/// {@endtemplate}
abstract class InfrastructurePackage
    implements DartPackage, OverridableGenerator {
  /// {@macro infrastructure_package}
  factory InfrastructurePackage({
    required Project project,
    required DomainPackage domainPackage,
  }) =>
      InfrastructurePackageImpl(
        project: project,
        domainPackage: domainPackage,
      );

  @visibleForTesting
  EntityBuilder? entityOverrides;

  @visibleForTesting
  ServiceInterfaceBuilder? serviceInterfaceOverrides;

  @visibleForTesting
  DataTransferObjectBuilder? dataTransferObjectOverrides;

  @visibleForTesting
  ServiceImplementationBuilder? serviceImplementationOverrides;

  Project get project;

  Future<void> create({required Logger logger});

  Future<void> addDataTransferObject({
    required String entityName,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeDataTransferObject({
    required String name,
    required String dir,
    required Logger logger,
  });

  Future<void> addServiceImplementation({
    required String name,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
    required Logger logger,
  });
}

typedef DataTransferObjectBuilder = DataTransferObject Function({
  required String entityName,
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
    required String entityName,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  }) =>
      DataTransferObjectImpl(
        entityName: entityName,
        dir: dir,
        infrastructurePackage: infrastructurePackage,
      );

  Future<void> create({required Logger logger});
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

  Future<void> create({required Logger logger});
}
