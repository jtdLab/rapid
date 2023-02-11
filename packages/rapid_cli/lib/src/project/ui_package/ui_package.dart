import 'package:mason/mason.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/generator_builder.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project/ui_package/ui_package_impl.dart';

/// {@template ui_package}
/// Abstraction of the ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui`
/// {@endtemplate}
abstract class UiPackage implements DartPackage {
  /// {@macro ui_package}
  factory UiPackage({
    required Project project,
    GeneratorBuilder? generator,
  }) =>
      UiPackageImpl(project: project, generator: generator);

  Project get project;

  Future<void> create({required Logger logger});
}
