import '../../base.dart';
import '../../util/dart_package_name_rest.dart';

/// {@template domain_remove_sub_domain_command}
/// `rapid domain remove sub_domain` remove a subdomain from the domain part of a Rapid project.
/// {@endtemplate}
class DomainRemoveSubDomainCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  /// {@macro domain_remove_sub_domain_command}
  DomainRemoveSubDomainCommand(super.project);

  @override
  String get name => 'sub_domain';

  @override
  List<String> get aliases => ['sub', 'sd'];

  @override
  String get invocation => 'rapid domain remove sub_domain <name>';

  @override
  String get description =>
      'Remove a subdomain from the domain part of a Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;

    return rapid.domainRemoveSubDomain(name: name);
  }
}
