import '../../base.dart';
import 'remove/entity.dart';
import 'remove/service_interface.dart';
import 'remove/value_object.dart';

/// {@template domain_sub_domain_remove_command}
/// `rapid domain sub_domain remove` remove a component from the domain part of a Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveCommand extends RapidLeafCommand {
  /// {@macro domain_sub_domain_remove_command}
  DomainSubDomainRemoveCommand(this.subDomainName, super.project) {
    addSubcommand(DomainSubDomainRemoveEntityCommand(subDomainName, project));
    addSubcommand(
      DomainSubDomainRemoveServiceInterfaceCommand(subDomainName, project),
    );
    addSubcommand(
      DomainSubDomainRemoveValueObjectCommand(subDomainName, project),
    );
  }

  final String subDomainName;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid domain $subDomainName remove <component>';

  @override
  String get description =>
      'Remove a component from the subdomain $subDomainName.';
}
