import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'logging_package_impl.dart';

/// Signature of [LoggingPackage.new].
typedef LoggingPackageBuilder = LoggingPackage Function({
  required RapidProject project,
});

/// {@template logging_package}
/// Abstraction of the logging package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_logging`
/// {@endtemplate}
abstract class LoggingPackage implements DartPackage, OverridableGenerator {
  /// {@macro logging_package}
  factory LoggingPackage({
    required RapidProject project,
  }) =>
      LoggingPackageImpl(
        project: project,
      );

  /// Creates this package on disk.
  Future<void> create();
}
