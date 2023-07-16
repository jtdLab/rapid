import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template domain_sub_domain_add_service_interface_command}
/// `rapid domain sub_domain add service_interface` command adds service_interface to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddServiceInterfaceCommand extends RapidLeafCommand
    with ClassNameGetter {
  /// {@macro domain_sub_domain_add_service_interface_command}
  DomainSubDomainAddServiceInterfaceCommand(this.subDomainName, super.project);
  final String subDomainName;

  @override
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain $subDomainName add service_interface <name> [arguments]';

  @override
  String get description =>
      'Add a service interface to the subdomain $subDomainName.';

  @override
  Future<void> run() {
    final name = super.className;
    final subDomainName =
        this.subDomainName == 'default' ? null : this.subDomainName;

    return rapid.domainSubDomainAddServiceInterface(
      name: name,
      subDomainName: subDomainName,
    );
  }
}
