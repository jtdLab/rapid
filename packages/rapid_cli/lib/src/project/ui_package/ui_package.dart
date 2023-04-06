import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:rapid_cli/src/project/ui_package/ui_package_impl.dart';

typedef UiPackageBuilder = UiPackage Function({required Project project});

/// {@template ui_package}
/// Abstraction of the ui package of a Rapid project.
///
/// Location: `packages/<project name>_ui/<project name>_ui`
/// {@endtemplate}
abstract class UiPackage implements DartPackage, OverridableGenerator {
  /// {@macro ui_package}
  factory UiPackage({
    required Project project,
  }) =>
      UiPackageImpl(
        project: project,
      );

  /// Creates the ui package.
  Future<void> create();
}
