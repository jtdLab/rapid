import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_package/domain_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

typedef DomainPackageBuilder = DomainPackage Function({
  String? name,
  required Project project,
});

/// {@template domain_package}
/// Abstraction of a domain package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_domain/<project name>_domain_<name>`
/// {@endtemplate}
abstract class DomainPackage implements DartPackage, OverridableGenerator {
  /// {@macro domain_package}
  factory DomainPackage({
    String? name,
    required Project project,
  }) =>
      DomainPackageImpl(
        name: name,
        project: project,
      );

  @visibleForTesting
  EntityBuilder? entityOverrides;

  @visibleForTesting
  ServiceInterfaceBuilder? serviceInterfaceOverrides;

  @visibleForTesting
  ValueObjectBuilder? valueObjectOverrides;

  @visibleForTesting
  DomainPackageBarrelFileBuilder? barrelFileOverrides;

  String? get name;

  Project get project;

  Entity entity({
    required String name,
    required String dir,
  });

  ServiceInterface serviceInterface({
    required String name,
    required String dir,
  });

  ValueObject valueObject({
    required String name,
    required String dir,
  });

  DomainPackageBarrelFile get barrelFile;

  Future<void> create();

  // TODO consider required !

  Future<Entity> addEntity({
    required String name,
    required String outputDir,
  });

  Future<Entity> removeEntity({
    required String name,
    required String dir,
  });

  Future<ServiceInterface> addServiceInterface({
    required String name,
    required String outputDir,
  });

  Future<ServiceInterface> removeServiceInterface({
    required String name,
    required String dir,
  });

  Future<ValueObject> addValueObject({
    required String name,
    required String outputDir,
    required String type,
    required String generics,
  });

  Future<ValueObject> removeValueObject({
    required String name,
    required String dir,
  });
}

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

  Future<void> create();
}

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

  Future<void> create();
}

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

  Future<void> create({
    required String type,
    required String generics,
  });
}

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
