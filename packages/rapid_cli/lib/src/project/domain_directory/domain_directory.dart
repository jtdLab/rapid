import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'domain_directory_impl.dart';
import 'domain_package/domain_package.dart';

/// Signature of [DomainDirectory.new].
typedef DomainDirectoryBuilder = DomainDirectory Function({
  required RapidProject project,
});

/// {@template domain_directory}
/// Abstraction of the domain directory of a Rapid project.
///
/// Location: `packages/<project name>/<project name>_domain`
/// {@endtemplate}
abstract class DomainDirectory extends Directory {
  /// {@macro domain_directory}
  factory DomainDirectory({
    required RapidProject project,
  }) =>
      DomainDirectoryImpl(
        project: project,
      );

  /// Use to override [domainPackage] for testing.
  @visibleForTesting
  DomainPackageBuilder? domainPackageOverrides;

  /// Use to override [domainPackages] for testing.
  @visibleForTesting
  List<DomainPackage>? domainPackagesOverrides;

  /// Returns the [DomainPackage] with [name].
  DomainPackage domainPackage({String? name});

  /// Returns all [DomainPackage]s.
  List<DomainPackage> domainPackages();
}
