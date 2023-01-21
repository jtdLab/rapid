import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/domain_package/service_interface_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'domain_package_bundle.dart';
import 'entity_bundle.dart';
import 'value_object_bundle.dart';

/// {@template domain_package}
/// Abstraction of the domain package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_domain`
/// {@endtemplate}
class DomainPackage extends ProjectPackage {
  /// {@macro domain_package}
  DomainPackage({
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
        '${project.name()}_domain',
      );

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = project.name();

    final generator = await _generator(domainPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }

  Entity entity({required String name, required String dir}) =>
      Entity(name: name, dir: dir, domainPackage: this);

  ServiceInterface serviceInterface({
    required String name,
    required String dir,
  }) =>
      ServiceInterface(name: name, dir: dir, domainPackage: this);

  ValueObject valueObject({required String name, required String dir}) =>
      ValueObject(name: name, dir: dir, domainPackage: this);
}

/// {@template entity}
/// Abstraction of an entity of a domain package of a Rapid project.
/// {@endtemplate}
class Entity {
  /// {@macro entity}
  Entity({
    required this.name,
    required this.dir,
    required this.domainPackage,
    GeneratorBuilder? generator,
  })  : _entityDirectory = Directory(
          p.join(
            domainPackage.path,
            'lib',
            'src',
            dir,
            name,
          ),
        ),
        _entityTestDirectory = Directory(
          p.join(
            domainPackage.path,
            'test',
            'src',
            dir,
            name,
          ),
        ),
        _generator = generator ?? MasonGenerator.fromBundle;

  final Directory _entityDirectory;
  final Directory _entityTestDirectory;
  final GeneratorBuilder _generator;

  final String name;
  final String dir;
  final DomainPackage domainPackage;

  bool exists() =>
      _entityDirectory.existsSync() || _entityTestDirectory.existsSync();

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = domainPackage.project.name();

    final generator = await _generator(entityBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': dir,
      },
      logger: logger,
    );
  }

  // TODO logger ?
  void delete() {
    _entityDirectory.deleteSync(recursive: true);
    _entityTestDirectory.deleteSync(recursive: true);
  }
}

/// {@template service_interface}
/// Abstraction of an service interface of a domain package of a Rapid project.
/// {@endtemplate}
class ServiceInterface {
  /// {@macro service_interface}
  ServiceInterface({
    required this.name,
    required this.dir,
    required this.domainPackage,
    GeneratorBuilder? generator,
  })  : _serviceInterfaceDirectory = Directory(
          p.join(
            domainPackage.path,
            'lib',
            'src',
            dir,
            name,
          ),
        ),
        _generator = generator ?? MasonGenerator.fromBundle;

  final Directory _serviceInterfaceDirectory;
  final GeneratorBuilder _generator;

  final String name;
  final String dir;
  final DomainPackage domainPackage;

  bool exists() => _serviceInterfaceDirectory.existsSync();

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = domainPackage.project.name();

    final generator = await _generator(serviceInterfaceBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': dir,
      },
      logger: logger,
    );
  }

  // TODO logger ?
  void delete() {
    _serviceInterfaceDirectory.deleteSync(recursive: true);
  }
}

/// {@template value_object}
/// Abstraction of an value object of a domain package of a Rapid project.
/// {@endtemplate}
class ValueObject {
  /// {@macro value_object}
  ValueObject({
    required this.name,
    required this.dir,
    required this.domainPackage,
    GeneratorBuilder? generator,
  })  : _valueObjectDirectory = Directory(
          p.join(
            domainPackage.path,
            'lib',
            'src',
            dir,
            name,
          ),
        ),
        _valueObjectTestDirectory = Directory(
          p.join(
            domainPackage.path,
            'test',
            'src',
            dir,
            name,
          ),
        ),
        _generator = generator ?? MasonGenerator.fromBundle;

  final Directory _valueObjectDirectory;
  final Directory _valueObjectTestDirectory;
  final GeneratorBuilder _generator;

  final String name;
  final String dir;
  final DomainPackage domainPackage;

  bool exists() =>
      _valueObjectDirectory.existsSync() ||
      _valueObjectTestDirectory.existsSync();

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = domainPackage.project.name();

    final generator = await _generator(valueObjectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': name,
        'output_dir': dir,
        //'type': 88, // TODO
        // 'generics': 88,
      },
      logger: logger,
    );
  }

  // TODO logger ?
  void delete() {
    _valueObjectDirectory.deleteSync(recursive: true);
    _valueObjectTestDirectory.deleteSync(recursive: true);
  }
}
