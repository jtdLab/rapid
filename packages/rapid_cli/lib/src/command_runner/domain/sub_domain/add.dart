import '../../base.dart';
import 'add/entity.dart';
import 'add/service_interface.dart';
import 'add/value_object.dart';

/// {@template domain_sub_domain_add_command}
/// `rapid domain sub_domain add` command add components to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddCommand extends RapidBranchCommand {
  /// {@macro domain_sub_domain_add_command}
  DomainSubDomainAddCommand(this.subDomainName, super.project) {
    addSubcommand(DomainSubDomainAddEntityCommand(subDomainName, project));
    addSubcommand(
      DomainSubDomainAddServiceInterfaceCommand(subDomainName, project),
    );
    addSubcommand(DomainSubDomainAddValueObjectCommand(subDomainName, project));
  }

  final String subDomainName;

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid domain $subDomainName add <component>';

  @override
  String get description => 'Add a component to the subdomain $subDomainName.';
}
