import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/project/infrastructure_dir/infrastructure_directory_impl.dart';
import 'package:rapid_cli/src/project/infrastructure_dir/infrastructure_package/infrastructure_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Signature for method that returns the [InfrastructureDirectory] for [name] and [project].
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

  @visibleForTesting
  InfrastructurePackageBuilder? infrastructurePackageOverrides;

  /// Returns the [InfrastructurePackage] with [name].
  InfrastructurePackage infrastructurePackage({String? name});

  // TODO consider required !

  /// Adds the [InfrastructurePackage] with [name] and returns it.
  ///
  /// Throws [SubInfrastructureAlreadyExists] when the [DomainPackage] already exists.
  Future<InfrastructurePackage> addInfrastructurePackage({
    required String name,
  });

  /// Removes the [InfrastructurePackage] with [name] and returns it.
  ///
  /// Throws [SubInfrastructureDoesNotExist] when the [InfrastructurePackage] does not exist.
  Future<InfrastructurePackage> removeInfrastructurePackage({
    required String name,
  });
}
