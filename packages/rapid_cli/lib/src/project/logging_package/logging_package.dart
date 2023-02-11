import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/logging_package/logging_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template logging_package}
/// Abstraction of the logging package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_logging`
/// {@endtemplate}
abstract class LoggingPackage implements DartPackage {
  /// {@macro logging_package}
  factory LoggingPackage({
    required Project project,
    GeneratorBuilder? generator,
  }) =>
      LoggingPackageImpl(project: project, generator: generator);

  Project get project;

  Future<void> create({required Logger logger});
}
