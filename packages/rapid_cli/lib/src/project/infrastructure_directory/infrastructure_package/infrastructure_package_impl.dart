import 'dart:io' as io;

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_file.dart';
import 'package:rapid_cli/src/core/dart_file_impl.dart';
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/file_system_entity_collection.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/data_transfer_object_bundle.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/service_implementation_bundle.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'infrastructure_package_bundle.dart';

class InfrastructurePackageImpl extends DartPackageImpl
    with OverridableGenerator, Generatable
    implements InfrastructurePackage {
  InfrastructurePackageImpl({
    this.name,
    required this.project,
  }) : super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_infrastructure',
            '${project.name()}_infrastructure${name != null ? '_$name' : ''}',
          ),
        );

  @override
  DataTransferObjectBuilder? dataTransferObjectOverrides;

  @override
  ServiceImplementationBuilder? serviceImplementationOverrides;

  @override
  InfrastructurePackageBarrelFileBuilder? barrelFileOverrides;

  @override
  final String? name;

  @override
  final Project project;

  @override
  InfrastructurePackageBarrelFile get barrelFile =>
      (barrelFileOverrides ?? InfrastructurePackageBarrelFile.new)(
        infrastructurePackage: this,
      );

  @override
  DataTransferObject dataTransferObject({
    required String name,
    required String dir,
  }) =>
      (dataTransferObjectOverrides ?? DataTransferObject.new)(
        name: name,
        dir: dir,
        infrastructurePackage: this,
      );

  @override
  ServiceImplementation serviceImplementation({
    required String name,
    required String serviceName,
    required String dir,
  }) =>
      (serviceImplementationOverrides ?? ServiceImplementation.new)(
        name: name,
        serviceName: serviceName,
        dir: dir,
        infrastructurePackage: this,
      );

  @override
  Future<void> create() async {
    final projectName = project.name();

    await generate(
      bundle: infrastructurePackageBundle,
      vars: <String, dynamic>{
        'project_name': projectName,
        'has_name': name != null,
        'name': name,
      },
    );
  }
}

class DataTransferObjectImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements DataTransferObject {
  DataTransferObjectImpl({
    required String name,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  })  : _infrastructurePackage = infrastructurePackage,
        _dir = dir,
        _name = name,
        super([
          DartFile(
            path: p.join(
              infrastructurePackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_dto',
          ),
          DartFile(
            path: p.join(
              infrastructurePackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_dto.freezed',
          ),
          DartFile(
            path: p.join(
              infrastructurePackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_dto.g',
          ),
          DartFile(
            path: p.join(
              infrastructurePackage.path,
              'test',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_dto_test',
          ),
        ]);

  final String _name;
  final String _dir;
  final InfrastructurePackage _infrastructurePackage;

  @override
  Future<void> create() async {
    final projectName = _infrastructurePackage.project.name();
    final subInfrastructureName = _infrastructurePackage.name;

    final generator = await super.generator(dataTransferObjectBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_infrastructurePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'entity_name': _name,
        'output_dir': _dir,
        'output_dir_is_cwd': _dir == '.',
        'has_subinfrastructure_name': subInfrastructureName != null,
        'subinfrastructure_name': subInfrastructureName,
      },
    );
  }
}

class ServiceImplementationImpl extends FileSystemEntityCollection
    with OverridableGenerator
    implements ServiceImplementation {
  ServiceImplementationImpl({
    required String name,
    required String serviceName,
    required String dir,
    required InfrastructurePackage infrastructurePackage,
  })  : _name = name,
        _serviceName = serviceName,
        _dir = dir,
        _infrastructurePackage = infrastructurePackage,
        super([
          DartFile(
            path: p.join(
              infrastructurePackage.path,
              'lib',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_${serviceName.snakeCase}_service',
          ),
          DartFile(
            path: p.join(
              infrastructurePackage.path,
              'test',
              'src',
              dir,
            ),
            name: '${name.snakeCase}_${serviceName.snakeCase}_service_test',
          ),
        ]);

  final String _name;
  final String _serviceName;
  final String _dir;
  final InfrastructurePackage _infrastructurePackage;

  @override
  Future<void> create() async {
    final projectName = _infrastructurePackage.project.name();
    final subInfrastructureName = _infrastructurePackage.name;

    final generator = await super.generator(serviceImplementationBundle);
    await generator.generate(
      DirectoryGeneratorTarget(io.Directory(_infrastructurePackage.path)),
      vars: <String, dynamic>{
        'project_name': projectName,
        'name': _name,
        'service_name': _serviceName,
        'output_dir': _dir,
        'output_dir_is_cwd': _dir == '.',
        'has_subinfrastructure_name': subInfrastructureName != null,
        'subinfrastructure_name': subInfrastructureName,
      },
    );
  }
}

class InfrastructurePackageBarrelFileImpl extends DartFileImpl
    implements InfrastructurePackageBarrelFile {
  InfrastructurePackageBarrelFileImpl({
    required InfrastructurePackage infrastructurePackage,
  }) : super(
          path: p.join(
            infrastructurePackage.path,
            'lib',
          ),
          name: infrastructurePackage.packageName(),
        );
}
