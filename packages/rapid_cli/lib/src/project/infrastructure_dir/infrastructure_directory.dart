import 'package:mason/mason.dart';
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

  InfrastructurePackage infrastructurePackage({required String name});

  Future<void> addDataTransferObject({
    required String entityName,
    required String domainName,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeDataTransferObject({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  });

  Future<void> addServiceImplementation({
    required String name,
    required String domainName,
    required String serviceName,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeServiceImplementation({
    required String name,
    required String domainName,
    required String serviceName,
    required String dir,
    required Logger logger,
  });
}
