import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package_impl.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/logging_package/logging_package.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'logging_package_bundle.dart';

class LoggingPackageImpl extends DartPackageImpl implements LoggingPackage {
  LoggingPackageImpl({
    required this.project,
    GeneratorBuilder? generator,
  })  : _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_logging',
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

    final generator = await _generator(loggingPackageBundle);
    await generator.generate(
      DirectoryGeneratorTarget(Directory(path)),
      vars: <String, dynamic>{
        'project_name': projectName,
      },
      logger: logger,
    );
  }
}
