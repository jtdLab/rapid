import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:universal_io/io.dart';

import 'logging_package_bundle.dart';

/// {@template logging_package}
/// Abstraction of the logging package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_logging`
/// {@endtemplate}
class LoggingPackage extends DartPackage {
  /// {@macro logging_package}
  LoggingPackage({
    required Project project,
    GeneratorBuilder? generator,
  })  : _project = project,
        _generator = generator ?? MasonGenerator.fromBundle,
        super(
          path: p.join(
            project.path,
            'packages',
            project.name(),
            '${project.name()}_logging',
          ),
        );

  final Project _project;
  final GeneratorBuilder _generator;

  Future<void> create({
    required Logger logger,
  }) async {
    final projectName = _project.name();

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
