import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/infrastructure_package/data_transfer_object_bundle.dart';
import 'package:rapid_cli/src/project/infrastructure_package/service_implementation_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'infrastructure_package_bundle.dart';

/// {@template infrastructure_package}
/// Abstraction of the infrastructure package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_infrastructure`
/// {@endtemplate}
class InfrastructurePackage extends DartPackage {
  /// {@macro infrastructure_package}
  InfrastructurePackage({
    required this.project,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_infrastructure',
          ),
        );

  final Project project;
  final GeneratorBuilder _generator;

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = project.name();

    final generator = await _generator(infrastructurePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }

  DataTransferObject dataTransferObject({
    required String entityName,
    required String dir,
  }) =>
      DataTransferObject(
        entityName: entityName,
        dir: dir,
        infrastructurePackage: this,
      );

  ServiceImplementation serviceImplementation({
    required String name,
    required String serviceName,
    required String dir,
  }) =>
      ServiceImplementation(
        name: name,
        serviceName: serviceName,
        dir: dir,
        infrastructurePackage: this,
      );
}

/// {@template data_transfer_object}
/// Abstraction of a data transfer object of a infrastructure package of a Rapid project.
/// {@endtemplate}
class DataTransferObject extends FileSystemEntityCollection {
  /// {@macro data_transfer_object}
  DataTransferObject({
    required this.entityName,
    required this.dir,
    required this.infrastructurePackage,
    DartFormatFixCommand? dartFormatFix, // TODO needed ?
    GeneratorBuilder? generator,
  })  : _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.normalize(
              p.join(
                infrastructurePackage.path,
                'lib',
                'src',
                dir,
                entityName.snakeCase,
              ),
            ),
          ),
          Directory(
            path: p.normalize(
              p.join(
                infrastructurePackage.path,
                'test',
                'src',
                dir,
                entityName.snakeCase,
              ),
            ),
          ),
        ]);

  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  final String entityName;
  final String dir;
  final InfrastructurePackage infrastructurePackage;

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = infrastructurePackage.project.name();

    final generator = await _generator(dataTransferObjectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(infrastructurePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'entity_name': entityName,
        'output_dir': dir,
      },
      logger: logger,
    );

    await _dartFormatFix(cwd: infrastructurePackage.path, logger: logger);
  }
}

/// {@template service_implementation}
/// Abstraction of a service implementation of a infrastructure package of a Rapid project.
/// {@endtemplate}
class ServiceImplementation extends FileSystemEntityCollection {
  /// {@macro service_implementation}
  ServiceImplementation({
    required this.name,
    required this.serviceName,
    required this.dir,
    required this.infrastructurePackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  })  : _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.normalize(
              p.join(
                infrastructurePackage.path,
                'lib',
                'src',
                dir,
                serviceName.snakeCase,
              ),
            ),
          ),
          Directory(
            path: p.normalize(
              p.join(
                infrastructurePackage.path,
                'test',
                'src',
                dir,
                serviceName.snakeCase,
              ),
            ),
          ),
        ]);

  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  final String name;
  final String serviceName;
  final String dir;
  final InfrastructurePackage infrastructurePackage;

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = infrastructurePackage.project.name();

    final generator = await _generator(serviceImplementationBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(infrastructurePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'service_name': serviceName,
        'output_dir': dir,
      },
      logger: logger,
    );

    await _dartFormatFix(cwd: infrastructurePackage.path, logger: logger);
  }
}
