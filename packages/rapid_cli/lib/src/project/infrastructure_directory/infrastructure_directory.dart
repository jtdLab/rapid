import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_directory_impl.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Signature of [InfrastructureDirectory.new].
typedef InfrastructureDirectoryBuilder = InfrastructureDirectory Function({
  required Project project,
});

/// {@template infrastructure_directory}
/// Abstraction of the infrastructure directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_infrastructure`
/// {@endtemplate}
abstract class InfrastructureDirectory extends Directory {
  /// {@macro infrastructure_directory}
  factory InfrastructureDirectory({
    required Project project,
  }) =>
      InfrastructureDirectoryImpl(
        project: project,
      );

  /// Use to override [infrastructurePackage] for testing.
  @visibleForTesting
  InfrastructurePackageBuilder? infrastructurePackageOverrides;

  /// Use to override [infrastructurePackages] for testing.
  @visibleForTesting
  List<InfrastructurePackage>? infrastructurePackagesOverrides;

  /// Returns the [InfrastructurePackage] with [name].
  InfrastructurePackage infrastructurePackage({String? name});

  /// Returns all [InfrastructurePackage]s.
  List<InfrastructurePackage> infrastructurePackages();
}