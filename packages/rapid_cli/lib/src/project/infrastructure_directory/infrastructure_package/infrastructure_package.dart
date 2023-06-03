import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'infrastructure_package_impl.dart';

/// Signature of [InfrastructurePackage.new].
typedef InfrastructurePackageBuilder = InfrastructurePackage Function({
  String? name,
  required RapidProject project,
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
    required RapidProject project,
  }) =>
      InfrastructurePackageImpl(
        name: name,
        project: project,
      );

  /// Use to override [dataTransferObject] for testing.
  @visibleForTesting
  DataTransferObjectBuilder? dataTransferObjectOverrides;

  /// Use to override [serviceImplementation] for testing.
  @visibleForTesting
  ServiceImplementationBuilder? serviceImplementationOverrides;

  /// Use to override [barrelFile] for testing.
  @visibleForTesting
  InfrastructurePackageBarrelFileBuilder? barrelFileOverrides;

  /// Returns the name of this package, or null if it has no name.
  String? get name;

  /// Returns the project associated with this package.
  RapidProject get project;

  /// Returns the barrel file of this package.
  InfrastructurePackageBarrelFile get barrelFile;

  /// Returns the Data Transfer Object with the given [name] and [dir].
  ///
  /// The [name] parameter specifies the name of the Data Transfer Object.
  ///
  /// The [dir] parameter specifies the directory where the Data Transfer Object is stored,
  /// relative to the `lib/src` directory of the package.
  DataTransferObject dataTransferObject({
    required String name,
    required String dir,
  });

  /// Returns the Service Implementation with the given [name], [serviceName], [dir].
  ///
  /// The [name] parameter specifies the name of the Service Implementation.
  ///
  /// The [serviceName] parameter specifies the name of the Service Interface the Service Implementation is associated with.
  ///
  /// The [dir] parameter specifies the directory where the Service Implementation is stored,
  /// relative to the `lib/src` directory of the package.
  ServiceImplementation serviceImplementation({
    required String name,
    required String serviceName,
    required String dir,
  });

  /// Creates this package on disk.
  Future<void> create();
}

/// Signature of [DataTransferObject.new].
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

  /// Creates this data transfer object on disk.
  Future<void> create();
}

/// Signature of [ServiceImplementation.new].
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

  /// Creates this service implementation on disk.
  Future<void> create();
}

/// Signature of [InfrastructurePackageBarrelFile.new].
typedef InfrastructurePackageBarrelFileBuilder = InfrastructurePackageBarrelFile
    Function({
  required InfrastructurePackage infrastructurePackage,
});

/// {@template infrastructure_package_barrel_file}
/// Abstraction of the barrel file of a infrastructure package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_infrastructure/<project name>_infrastructure_<name>/lib/<project name>_infrastructure_<name>.dart`
/// {@endtemplate}
abstract class InfrastructurePackageBarrelFile implements DartFile {
  /// {@macro infrastructure_package_barrel_file}
  factory InfrastructurePackageBarrelFile({
    required InfrastructurePackage infrastructurePackage,
  }) =>
      InfrastructurePackageBarrelFileImpl(
        infrastructurePackage: infrastructurePackage,
      );
}
