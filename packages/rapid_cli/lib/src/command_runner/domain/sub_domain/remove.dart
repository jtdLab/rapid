import '../../base.dart';
import 'remove/entity.dart';
import 'remove/service_interface.dart';
import 'remove/value_object.dart';

/// {@template domain_sub_domain_remove_command}
/// `rapid domain sub_domain remove` remove a component from the domain part
///  of a Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveCommand extends RapidSubDomainBranchCommand {
  /// {@macro domain_sub_domain_remove_command}
  DomainSubDomainRemoveCommand(super.project, {required super.subDomainName}) {
    addSubcommand(
      DomainSubDomainRemoveEntityCommand(
        project,
        subDomainName: subDomainName,
      ),
    );
    addSubcommand(
      DomainSubDomainRemoveServiceInterfaceCommand(
        project,
        subDomainName: subDomainName,
      ),
    );
    addSubcommand(
      DomainSubDomainRemoveValueObjectCommand(
        project,
        subDomainName: subDomainName,
      ),
    );
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid domain $subDomainName remove <component>';

  @override
  String get description =>
      'Remove a component from the subdomain $subDomainName.';
}
