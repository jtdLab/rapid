import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/logging_package/logging_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

typedef LoggingPackageBuilder = LoggingPackage Function({
  required Project project,
});

/// {@template logging_package}
/// Abstraction of the logging package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_logging`
/// {@endtemplate}
abstract class LoggingPackage implements DartPackage, OverridableGenerator {
  /// {@macro logging_package}
  factory LoggingPackage({
    required Project project,
  }) =>
      LoggingPackageImpl(
        project: project,
      );

  /// Creates the logging package.
  Future<void> create();
}
