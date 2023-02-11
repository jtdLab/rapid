import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_package}
/// Abstraction of the domain package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_domain`
/// {@endtemplate}
abstract class DomainPackage implements DartPackage {
  /// {@macro domain_package}
  factory DomainPackage({
    required Project project,
    GeneratorBuilder? generator,
  }) =>
      DomainPackageImpl(project: project, generator: generator);

  Project get project;

  Future<void> create({required Logger logger});

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
}

/// {@template entity}
/// Abstraction of an entity of a domain package of a Rapid project.
/// {@endtemplate}
abstract class Entity implements FileSystemEntityCollection {
  /// {@macro entity}
  factory Entity({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  }) =>
      EntityImpl(
        name: name,
        dir: dir,
        domainPackage: domainPackage,
        dartFormatFix: dartFormatFix,
        generator: generator,
      );

  String get name;

  String get dir;

  DomainPackage get domainPackage;

  Future<void> create({required Logger logger});
}

/// {@template service_interface}
/// Abstraction of an service interface of a domain package of a Rapid project.
/// {@endtemplate}
abstract class ServiceInterface implements FileSystemEntityCollection {
  /// {@macro service_interface}
  factory ServiceInterface({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  }) =>
      ServiceInterfaceImpl(
        name: name,
        dir: dir,
        domainPackage: domainPackage,
        dartFormatFix: dartFormatFix,
        generator: generator,
      );

  String get name;

  String get dir;

  DomainPackage get domainPackage;

  Future<void> create({required Logger logger});
}

/// {@template value_object}
/// Abstraction of an value object of a domain package of a Rapid project.
/// {@endtemplate}
abstract class ValueObject implements FileSystemEntityCollection {
  /// {@macro value_object}
  factory ValueObject({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  }) =>
      ValueObjectImpl(
        name: name,
        dir: dir,
        domainPackage: domainPackage,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs:
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
        dartFormatFix: dartFormatFix,
        generator: generator,
      );

  String get name;

  String get dir;

  DomainPackage get domainPackage;

  Future<void> create({
    required String type,
    required String generics,
    required Logger logger,
  });
}
