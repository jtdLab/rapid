import 'package:mason/mason.dart';
import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_directory_impl.dart';
import 'package:rapid_cli/src/project/domain_dir/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Signature for method that returns the [DomainDirectory] for [name] and [project].
typedef DomainDirectoryBuilder = DomainDirectory Function({
  required Project project,
});

/// {@template domain_directory}
/// Abstraction of the domain directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_domain`
/// {@endtemplate}
abstract class DomainDirectory extends Directory {
  /// {@macro domain_directory}
  factory DomainDirectory({
    required Project project,
  }) =>
      DomainDirectoryImpl(
        project: project,
      );

  @visibleForTesting
  DomainPackageBuilder? domainPackageOverrides;

  DomainPackage domainPackage({required String name});

  Future<void> addEntity({
    required String name,
    required String domainName,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeEntity({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  });

  Future<void> addServiceInterface({
    required String name,
    required String domainName,
    required String outputDir,
    required Logger logger,
  });

  Future<void> removeServiceInterface({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  });

  Future<void> addValueObject({
    required String name,
    required String domainName,
    required String outputDir,
    required String type,
    required String generics,
    required Logger logger,
  });

  Future<void> removeValueObject({
    required String name,
    required String domainName,
    required String dir,
    required Logger logger,
  });
}
