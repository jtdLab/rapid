import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template domain_sub_domain_remove_service_interface_command}
/// `rapid domain sub_domain remove service_interface` remove a service interface from the domain part of a Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveServiceInterfaceCommand extends RapidLeafCommand
    with ClassNameGetter {
  /// {@macro domain_sub_domain_remove_service_interface_command}
  DomainSubDomainRemoveServiceInterfaceCommand(
    this.subDomainName,
    super.project,
  );

  final String subDomainName;

  @override
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain $subDomainName remove service_interface <name> [arguments]';

  @override
  String get description =>
      'Remove a service interface from the subdomain $subDomainName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subDomainName =
        this.subDomainName == 'default' ? null : this.subDomainName;

    return rapid.domainSubDomainRemoveServiceInterface(
      name: name,
      subDomainName: subDomainName,
    );
  }
}
