import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/domain_package/service_interface_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'domain_package_bundle.dart';
import 'entity_bundle.dart';
import 'value_object_bundle.dart';

class DomainPackageImpl extends DartPackageImpl implements DomainPackage {
  DomainPackageImpl({
    required this.project,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_domain',
          ),
        );

  final GeneratorBuilder _generator;

  @override
  final Project project;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = project.name();

    final generator = await _generator(domainPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }

  @override
  Entity entity({required String name, required String dir}) =>
      Entity(name: name, dir: dir, domainPackage: this);

  @override
  ServiceInterface serviceInterface({
    required String name,
    required String dir,
  }) =>
      ServiceInterface(name: name, dir: dir, domainPackage: this);

  @override
  ValueObject valueObject({
    required String name,
    required String dir,
  }) =>
      ValueObject(
        name: name,
        dir: dir,
        domainPackage: this,
      );
}

// TODO normalize other paths 2 or overkill

class EntityImpl extends FileSystemEntityCollection implements Entity {
  EntityImpl({
    required this.name,
    required this.dir,
    required this.domainPackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  })  : _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.normalize(
              p.join(
                domainPackage.path,
                'lib',
                dir,
                name.snakeCase,
              ),
            ),
          ),
          Directory(
            path: p.normalize(
              p.join(
                domainPackage.path,
                'test',
                dir,
                name.snakeCase,
              ),
            ),
          ),
        ]);

  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  @override
  final String name;

  @override
  final String dir;

  @override
  final DomainPackage domainPackage;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = domainPackage.project.name();

    final generator = await _generator(entityBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': dir,
      },
      logger: logger,
    );

    await _dartFormatFix(cwd: domainPackage.path, logger: logger);
  }
}

class ServiceInterfaceImpl extends FileSystemEntityCollection
    implements ServiceInterface {
  ServiceInterfaceImpl({
    required this.name,
    required this.dir,
    required this.domainPackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  })  : _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.normalize(
              p.join(
                domainPackage.path,
                'lib',
                dir,
                name.snakeCase,
              ),
            ),
          ),
        ]);

  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  @override
  final String name;

  @override
  final String dir;

  @override
  final DomainPackage domainPackage;

  @override
  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = domainPackage.project.name();

    final generator = await _generator(serviceInterfaceBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': dir,
      },
      logger: logger,
    );

    await _dartFormatFix(cwd: domainPackage.path, logger: logger);
  }
}

class ValueObjectImpl extends FileSystemEntityCollection
    implements ValueObject {
  ValueObjectImpl({
    required this.name,
    required this.dir,
    required this.domainPackage,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  })  : _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle,
        super([
          Directory(
            path: p.normalize(
              p.join(
                domainPackage.path,
                'lib',
                dir,
                name.snakeCase,
              ),
            ),
          ),
          Directory(
            path: p.normalize(
              p.join(
                domainPackage.path,
                'test',
                dir,
                name.snakeCase,
              ),
            ),
          ),
        ]);

  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;
  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  @override
  final String name;

  @override
  final String dir;

  @override
  final DomainPackage domainPackage;

  @override
  Future<void> create({
    required String type,
    required String generics,
    required Logger logger,
  }) async {
    final projectName = domainPackage.project.name();

    final generator = await _generator(valueObjectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': dir,
        'type': type,
        'generics': generics,
      },
      logger: logger,
    );

    await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
      cwd: domainPackage.path,
      logger: logger,
    );
    await _dartFormatFix(cwd: domainPackage.path, logger: logger);
  }
}
