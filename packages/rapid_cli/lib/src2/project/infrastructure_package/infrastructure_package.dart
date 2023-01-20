import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src2/core/generator_builder.dart';
import 'package:rapid_cli/src2/project/project.dart';
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
    required Project project,
    GeneratorBuilder? generator,
  })  : _project = project,
        _generator = generator ?? MasonGenerator.fromBundle;

  final Project _project;
  final GeneratorBuilder _generator;

  @override
  String get path => p.join(
        _project.path,
        'packages',
        _project.name(),
        '${_project.name()}_infrastructure',
      );

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _project.name();

    final generator = await _generator(infrastructurePackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }

  Future<void> addServiceImplementation({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> addDataTransferObject({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> removeServiceImplementation({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> removeDataTransferObject({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }
}
