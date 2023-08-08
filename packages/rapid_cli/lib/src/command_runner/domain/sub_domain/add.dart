import '../../base.dart';
import 'add/entity.dart';
import 'add/service_interface.dart';
import 'add/value_object.dart';

/// {@template domain_sub_domain_add_command}
/// `rapid domain sub_domain add` add a component to the domain part
/// of a Rapid project.
/// {@endtemplate}
class DomainSubDomainAddCommand extends RapidSubDomainBranchCommand {
  /// {@macro domain_sub_domain_add_command}
  DomainSubDomainAddCommand(super.project, {required super.subDomainName}) {
    addSubcommand(
      DomainSubDomainAddEntityCommand(
        project,
        subDomainName: subDomainName,
      ),
    );
    addSubcommand(
      DomainSubDomainAddServiceInterfaceCommand(
        project,
        subDomainName: subDomainName,
      ),
    );
    addSubcommand(
      DomainSubDomainAddValueObjectCommand(
        project,
        subDomainName: subDomainName,
      ),
    );
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid domain $subDomainName add <component>';

  @override
  String get description => 'Add a component to the subdomain $subDomainName.';
}
