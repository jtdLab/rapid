import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src2/core/generator_builder.dart';
import 'package:rapid_cli/src2/project/project.dart';
import 'package:universal_io/io.dart';

import 'domain_package_bundle.dart';

/// {@template domain_package}
/// Abstraction of the domain package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_domain`
/// {@endtemplate}
class DomainPackage extends ProjectPackage {
  /// {@macro domain_package}
  DomainPackage({
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
        '${_project.name()}_domain',
      );

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _project.name();

    final generator = await _generator(domainPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }

  Future<void> addEntity({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> addServiceInterface({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> addValueObject({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> removeEntity({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> removeServiceInterface({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }

  Future<void> removeValueObject({
    required Logger logger,
  }) {
    // TODO implement
    throw UnimplementedError();
  }
}
