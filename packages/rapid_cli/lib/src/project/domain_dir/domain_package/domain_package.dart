import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_directory.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_package/domain_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

typedef DomainPackageBuilder = DomainPackage Function({
  required String name,
  required DomainDirectory domainDirectory,
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
    required String name,
    required Project project,
  }) =>
      DomainPackageImpl(
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
  ValueObjectBuilder? valueObjectOverrides;

  String get name;

  Project get project;

  Future<void> create({required Logger logger});

  Future<void> addEntity({
    required String name,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeEntity({
    required String name,
    required String dir,
    required Logger logger,
  });

  Future<void> addServiceInterface({
    required String name,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeServiceInterface({
    required String name,
    required String dir,
    required Logger logger,
  });

  Future<void> addValueObject({
    required String name,
    required String outputDir,
    required String type,
    required String generics,
    required Logger logger,
  });

  Future<void> removeValueObject({
    required String name,
    required String dir,
    required Logger logger,
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

  Future<void> create({required Logger logger});
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

  Future<void> create({required Logger logger});
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
    required Logger logger,
  });
}
