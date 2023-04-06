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

  /// Returns the [DomainPackage] with [name].
  DomainPackage domainPackage({String? name});

  // TODO consider required !

  /// Adds the [DomainPackage] with [name] and returns it.
  ///
  /// Throws [SubDomainAlreadyExists] when the [DomainPackage] already exists.
  Future<DomainPackage> addDomainPackage({required String name});

  /// Removes the [DomainPackage] with [name] and returns it.
  ///
  /// Throws [SubDomainDoesNotExist] when the [DomainPackage] does not exist.
  Future<DomainPackage> removeDomainPackage({required String name});
}
