import '../../../base.dart';
import '../../../util/class_name_rest.dart';

/// {@template domain_sub_domain_add_service_interface_command}
/// `rapid domain sub_domain add service_interface` add a service_interface
/// to the domain part of a Rapid project.
/// {@endtemplate}
class DomainSubDomainAddServiceInterfaceCommand
    extends RapidSubDomainLeafCommand with ClassNameGetter {
  /// {@macro domain_sub_domain_add_service_interface_command}
  DomainSubDomainAddServiceInterfaceCommand(
    super.project, {
    required super.subDomainName,
  });

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
