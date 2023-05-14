import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/project/core/generator_mixins.dart';
import 'package:rapid_cli/src/project/di_package/di_package_impl.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Signature of [DiPackage.new].
typedef DiPackageBuilder = DiPackage Function({required Project project});

/// {@template di_package}
/// Abstraction of the di package of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_di`
/// {@endtemplate}
abstract class DiPackage implements DartPackage, OverridableGenerator {
  /// {@macro di_package}
  factory DiPackage({
    required Project project,
  }) =>
      DiPackageImpl(
        project: project,
      );

  /// Creates this package on disk.
  Future<void> create();
}
