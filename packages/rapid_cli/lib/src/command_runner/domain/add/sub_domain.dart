import '../../base.dart';
import '../../util/dart_package_name_rest.dart';

/// {@template domain_add_sub_domain_command}
/// `rapid domain add sub_domain` command add subdomains to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainAddSubDomainCommand extends RapidLeafCommand
    with DartPackageNameGetter {
  /// {@macro domain_add_sub_domain_command}
  DomainAddSubDomainCommand(super.project);

  @override
  String get name => 'sub_domain';

  @override
  List<String> get aliases => ['sub', 'sd'];

  @override
  String get invocation => 'rapid domain add sub_domain <name>';

  @override
  String get description =>
      'Add subdomains of the domain part of an existing Rapid project.';

  @override
  Future<void> run() {
    final name = super.dartPackageName;

    return rapid.domainAddSubDomain(name: name);
  }
}
