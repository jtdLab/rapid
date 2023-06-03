import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_package/service_interface_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'domain_package.dart';
import 'domain_package_bundle.dart';
import 'entity_bundle.dart';
import 'value_object_bundle.dart';

class DomainPackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements DomainPackage {
  DomainPackageImpl({
    this.name,
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name,
            '${project.name}_domain',
            '${project.name}_domain${name != null ? '_$name' : ''}',
          ),
        );

  @override
  EntityBuilder? entityOverrides;

  @override
  ServiceInterfaceBuilder? serviceInterfaceOverrides;

  @override
  ValueObjectBuilder? valueObjectOverrides;

  @override
  DomainPackageBarrelFileBuilder? barrelFileOverrides;

  @override
  final String? name;

  @override
  final RapidProject project;

  @override
  DomainPackageBarrelFile get barrelFile =>
      (barrelFileOverrides ?? DomainPackageBarrelFile.new)(
        domainPackage: this,
      );

  @override
  Entity entity({
    required String name,
    required String dir,
  }) =>
      (entityOverrides?.call ?? Entity.new)(
        name: name,
        dir: dir,
        domainPackage: this,
      );

  @override
  ServiceInterface serviceInterface({
    required String name,
    required String dir,
  }) =>
      (serviceInterfaceOverrides?.call ?? ServiceInterface.new)(
        name: name,
        dir: dir,
        domainPackage: this,
      );

  @override
  ValueObject valueObject({
    required String name,
    required String dir,
  }) =>
      (valueObjectOverrides?.call ?? ValueObject.new)(
        name: name,
        dir: dir,
        domainPackage: this,
      );

  @override
  Future<void> create() async {
    final projectName = project.name;

    await generate(
      bundle: domainPackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'has_name': name != null,
        'name': name,
      },
    );
  }
}

class EntityImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements Entity {
  EntityImpl({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _name = name,
        _dir = dir,
        _domainPackage = domainPackage,
        super([
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: name.snakeCase,
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}.freezed',
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'test',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  @override
  Future<void> create() async {
    final projectName = _domainPackage.project.name;
    final subDomainName = _domainPackage.name;

    final generator = await super.generator(entityBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
        'output_dir_is_cwd': _dir == '.',
        'has_subdomain_name': subDomainName != null,
        'subdomain_name': subDomainName,
      },
    );
  }
}

class ServiceInterfaceImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements ServiceInterface {
  ServiceInterfaceImpl({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _domainPackage = domainPackage,
        _dir = dir,
        _name = name,
        super([
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: 'i_${name.snakeCase}_service',
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: 'i_${name.snakeCase}_service.freezed',
          ),
        ]);

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  @override
  Future<void> create() async {
    final projectName = _domainPackage.project.name;

    final generator = await super.generator(serviceInterfaceBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
      },
    );
  }
}

class ValueObjectImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements ValueObject {
  ValueObjectImpl({
    required String name,
    required String dir,
    required DomainPackage domainPackage,
  })  : _domainPackage = domainPackage,
        _dir = dir,
        _name = name,
        super([
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: name.snakeCase,
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}.freezed',
          ),
          DartFile(
            path: p.join(
              domainPackage.path,
              'test',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final DomainPackage _domainPackage;

  @override
  Future<void> create({
    required String type,
    required String generics,
  }) async {
    final projectName = _domainPackage.project.name;
    final subDomainName = _domainPackage.name;

    final generator = await super.generator(valueObjectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_domainPackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'output_dir': _dir,
        'output_dir_is_cwd': _dir == '.',
        'type': type,
        'generics': generics,
        'has_subdomain_name': subDomainName != null,
        'subdomain_name': subDomainName,
      },
    );
  }
}

class DomainPackageBarrelFileImpl extends DartFileImpl
    implements DomainPackageBarrelFile {
  DomainPackageBarrelFileImpl({
    required DomainPackage domainPackage,
  }) : super(
          path: p.join(
            domainPackage.path,
            'lib',
          ),
          name: domainPackage.packageName(),
        );
}
