import 'package:meta/meta.dart';
import 'package:rapid_cli/src/core/directory.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_directory_impl.dart';
import 'package:rapid_cli/src/project/domain_directory/domain_package/domain_package.dart';
import 'package:rapid_cli/src/project/project.dart';

/// Signature of [DomainDirectory.new].
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
