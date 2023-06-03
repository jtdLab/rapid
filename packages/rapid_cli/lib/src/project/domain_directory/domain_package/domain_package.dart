import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'domain_package_impl.dart';

// TODO: DomainPackageBarrelFile is unused

/// Signature of [DomainPackage.new].
typedef DomainPackageBuilder = DomainPackage Function({
  String? name,
  required RapidProject project,
});

/// {@template domain_package}
/// Abstraction of a domain package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_domain/<project name>_domain_<name?>`
/// {@endtemplate}
abstract class DomainPackage implements DartPackage, OverridableGenerator {
  /// {@macro domain_package}
  factory DomainPackage({
    String? name,
    required RapidProject project,
  }) =>
      DomainPackageImpl(
        name: name,
        project: project,
      );

  /// Use to override [entity] for testing.
  @visibleForTesting
  EntityBuilder? entityOverrides;

  /// Use to override [serviceInterface] for testing.
  @visibleForTesting
  ServiceInterfaceBuilder? serviceInterfaceOverrides;

  /// Use to override [valueObject] for testing.
  @visibleForTesting
  ValueObjectBuilder? valueObjectOverrides;

  /// Use to override [barrelFile] for testing.
  @visibleForTesting
  DomainPackageBarrelFileBuilder? barrelFileOverrides;

  /// Returns the name of this package, or null if it has no name.
  String? get name;

  /// Returns the project associated with this package.
  RapidProject get project;

  /// Returns the barrel file of this package.
  DomainPackageBarrelFile get barrelFile;

  /// Returns the Entity with the given [name] and [dir].
  ///
  /// The [name] parameter specifies the name of the Entity.
  ///
  /// The [dir] parameter specifies the directory where the Entity is stored,
  /// relative to the `lib/src` directory of the package.
  Entity entity({
    required String name,
    required String dir,
  });

  /// Returns the Service Interface with the given [name] and [dir].
  ///
  /// The [name] parameter specifies the name of the Service Interface.
  ///
  /// The [dir] parameter specifies the directory where the Service Interface is stored,
  /// relative to the `lib/src` directory of the package.
  ServiceInterface serviceInterface({
    required String name,
    required String dir,
  });

  /// Returns the Value Object with the given [name] and [dir].
  ///
  /// The [name] parameter specifies the name of the Value Object.
  ///
  /// The [dir] parameter specifies the directory where the Value Object is stored,
  /// relative to the `lib/src` directory of the package.
  ValueObject valueObject({
    required String name,
    required String dir,
  });

  /// Creates this package on disk.
  Future<void> create();
}

/// Signature of [Entity.new].
typedef EntityBuilder = Entity Function({
  required String name,
  required String dir,
  required DomainPackage domainPackage,
});

/// {@template entity}
/// Abstraction of an entity of a domain package of a Rapid project.
/// {@endtemplate}
abstract class Entity
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro entity}
  factory Entity({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  }) =>
      EntityImpl(
        name: name,
        dir: dir,
        domainPackage: domainPackage,
      );

  /// Creates this entity on disk.
  Future<void> create();
}

/// Signature of [ServiceInterface.new].
typedef ServiceInterfaceBuilder = ServiceInterface Function({
  required String name,
  required String dir,
  required DomainPackage domainPackage,
});

/// {@template service_interface}
/// Abstraction of an service interface of a domain package of a Rapid project.
/// {@endtemplate}
abstract class ServiceInterface
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro service_interface}
  factory ServiceInterface({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  }) =>
      ServiceInterfaceImpl(
        name: name,
        dir: dir,
        domainPackage: domainPackage,
      );

  /// Creates this service interface on disk.
  Future<void> create();
}

/// Signature of [ValueObject.new].
typedef ValueObjectBuilder = ValueObject Function({
  required String name,
  required String dir,
  required DomainPackage domainPackage,
});

/// {@template value_object}
/// Abstraction of an value object of a domain package of a Rapid project.
/// {@endtemplate}
abstract class ValueObject
    implements FileSystemEntityCollection, OverridableGenerator {
  /// {@macro value_object}
  factory ValueObject({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  }) =>
      ValueObjectImpl(
        name: name,
        dir: dir,
        domainPackage: domainPackage,
      );

  /// Creates this value object on disk.
  Future<void> create({
    required String type,
    required String generics,
  });
}

/// Signature of [DomainPackageBarrelFile.new].
typedef DomainPackageBarrelFileBuilder = DomainPackageBarrelFile Function({
  required DomainPackage domainPackage,
});

/// {@template barrel_file}
/// Abstraction of the barrel file of a domain package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_domain/<project name>_domain_<name>/lib/<project name>_domain_<name>.dart`
/// {@endtemplate}
abstract class DomainPackageBarrelFile implements DartFile {
  /// {@macro barrel_file}
  factory DomainPackageBarrelFile({
    required DomainPackage domainPackage,
  }) =>
      DomainPackageBarrelFileImpl(
        domainPackage: domainPackage,
      );
}
