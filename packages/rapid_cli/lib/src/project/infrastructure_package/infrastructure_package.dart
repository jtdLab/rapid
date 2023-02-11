import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/infrastructure_package/infrastructure_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_package}
/// Abstraction of the infrastructure package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_infrastructure`
/// {@endtemplate}
abstract class InfrastructurePackage implements DartPackage {
  /// {@macro infrastructure_package}
  factory InfrastructurePackage({
    required Project project,
    GeneratorBuilder? generator,
  }) =>
      InfrastructurePackageImpl(
        project: project,
        generator: generator,
      );

  Project get project;

  Future<void> create({required Logger logger});

  DataTransferObject dataTransferObject({
    required String entityName,
    required String dir,
  });

  ServiceImplementation serviceImplementation({
    required String name,
    required String serviceName,
    required String dir,
  });
}

/// {@template data_transfer_object}
/// Abstraction of a data transfer object of a infrastructure package of a Rapid project.
/// {@endtemplate}
abstract class DataTransferObject implements FileSystemEntityCollection {
  /// {@macro data_transfer_object}
  factory DataTransferObject({
    required String entityName,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
    DartFormatFixCommand? dartFormatFix, // TODO needed ?
    GeneratorBuilder? generator,
  }) =>
      DataTransferObjectImpl(
        entityName: entityName,
        dir: dir,
        infrastructurePackage: infrastructurePackage,
        dartFormatFix: dartFormatFix,
        generator: generator,
      );

  String get entityName;

  String get dir;

  InfrastructurePackage get infrastructurePackage;

  Future<void> create({required Logger logger});
}

/// {@template service_implementation}
/// Abstraction of a service implementation of a infrastructure package of a Rapid project.
/// {@endtemplate}
abstract class ServiceImplementation implements FileSystemEntityCollection {
  /// {@macro service_implementation}
  factory ServiceImplementation({
    required String name,
    required String serviceName,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  }) =>
      ServiceImplementationImpl(
        name: name,
        serviceName: serviceName,
        dir: dir,
        infrastructurePackage: infrastructurePackage,
        dartFormatFix: dartFormatFix,
        generator: generator,
      );

  String get name;

  String get serviceName;

  String get dir;

  InfrastructurePackage get infrastructurePackage;

  Future<void> create({required Logger logger});
}
