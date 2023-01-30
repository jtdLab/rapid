import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/infrastructure_package/data_transfer_object_bundle.dart';
import 'package:rapid_cli/src/project/infrastructure_package/service_implementation_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'infrastructure_package_bundle.dart';

/// {@template infrastructure_package}
/// Abstraction of the infrastructure package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_infrastructure`
/// {@endtemplate}
class InfrastructurePackage extends ProjectPackage {
  /// {@macro infrastructure_package}
  InfrastructurePackage({
    required this.project,
    GeneratorBuilder? generator,
  }) : _generator = generator ?? MasonGenerator.fromBundle;

  final Project project;
  final GeneratorBuilder _generator;

  @override
  String get path => p.join(
        project.path,
        'packages',
        project.name(),
        '${project.name()}_infrastructure',
      );

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = project.name();

    final generator = await _generator(infrastructurePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
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
class DataTransferObject {
  /// {@macro data_transfer_object}
  DataTransferObject({
    required this.entityName,
    required this.dir,
    required this.infrastructurePackage,
    DartFormatFixCommand? dartFormatFix, // TODO needed ?
    GeneratorBuilder? generator,
  })  : _dataTransferObjectDirectory = Directory(
          p.join(
            infrastructurePackage.path,
            'lib',
            'src',
            dir,
            entityName.snakeCase,
          ),
        ),
        _dataTransferObjectTestDirectory = Directory(
          p.join(
            infrastructurePackage.path,
            'test',
            'src',
            dir,
            entityName.snakeCase,
          ),
        ),
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle;

  final Directory _dataTransferObjectDirectory;
  final Directory _dataTransferObjectTestDirectory;
  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  final String entityName;
  final String dir;
  final InfrastructurePackage infrastructurePackage;

  bool exists() {
    return _dataTransferObjectDirectory.existsSync() ||
        _dataTransferObjectTestDirectory.existsSync();
  }

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = infrastructurePackage.project.name();

    final generator = await _generator(dataTransferObjectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(infrastructurePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'entity_name': entityName,
        'output_dir': dir,
      },
      logger: logger,
    );

    await _dartFormatFix(cwd: infrastructurePackage.path, logger: logger);
  }

  // TODO logger ?
  void delete() {
    _dataTransferObjectDirectory.deleteSync(recursive: true);
    _dataTransferObjectTestDirectory.deleteSync(recursive: true);

    final directoryParent = _dataTransferObjectDirectory.parent;
    if (directoryParent.listSync().isEmpty) {
      directoryParent.deleteSync();
    }

    final testDirectoryParent = _dataTransferObjectTestDirectory.parent;
    if (testDirectoryParent.listSync().isEmpty) {
      testDirectoryParent.deleteSync();
    }
  }
}

/// {@template service_implementation}
/// Abstraction of a service implementation of a infrastructure package of a Rapid project.
/// {@endtemplate}
class ServiceImplementation {
  /// {@macro service_implementation}
  ServiceImplementation({
    required this.name,
    required this.serviceName,
    required this.dir,
    required this.infrastructurePackage,
    DartFormatFixCommand? dartFormatFix,
    GeneratorBuilder? generator,
  })  : _serviceImplementationDirectory = Directory(
          p.join(
            infrastructurePackage.path,
            'lib',
            'src',
            dir,
            serviceName.snakeCase,
          ),
        ),
        _serviceImplementationTestDirectory = Directory(
          p.join(
            infrastructurePackage.path,
            'test',
            'src',
            dir,
            serviceName.snakeCase,
          ),
        ),
        _dartFormatFix = dartFormatFix ?? Dart.formatFix,
        _generator = generator ?? MasonGenerator.fromBundle;

  final Directory _serviceImplementationDirectory;
  final Directory _serviceImplementationTestDirectory;
  final DartFormatFixCommand _dartFormatFix;
  final GeneratorBuilder _generator;

  final String name;
  final String serviceName;
  final String dir;
  final InfrastructurePackage infrastructurePackage;

  bool exists() =>
      _serviceImplementationDirectory.existsSync() ||
      _serviceImplementationTestDirectory.existsSync();

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = infrastructurePackage.project.name();

    final generator = await _generator(serviceImplementationBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(infrastructurePackage.path)),
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

  // TODO logger ?
  void delete() {
    /// final deletedFiles = entity.delete();
    ///
    ///           for (final file in deletedFiles) {
    ///             _logger.info(file.path);
    ///           }
    ///
    ///           _logger.info('');
    ///           _logger.info('Deleted ${deletedFiles.length} item(s)');
    ///           _logger.info('');
    ///           _logger.success('Removed Entity $name.');
    _serviceImplementationDirectory.deleteSync(recursive: true);
    _serviceImplementationTestDirectory.deleteSync(recursive: true);

    final directoryParent = _serviceImplementationDirectory.parent;
    if (directoryParent.listSync().isEmpty) {
      directoryParent.deleteSync();
    }

    final testDirectoryParent = _serviceImplementationTestDirectory.parent;
    if (testDirectoryParent.listSync().isEmpty) {
      testDirectoryParent.deleteSync();
    }
  }
}
