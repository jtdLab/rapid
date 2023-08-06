import '../base.dart';
import 'add/sub_domain.dart';

/// {@template domain_add_command}
/// `rapid domain add` add subdomains to the domain part of a Rapid project.
/// {@endtemplate}
class DomainAddCommand extends RapidBranchCommand {
  /// {@macro domain_add_command}
  DomainAddCommand(super.project) {
    addSubcommand(DomainAddSubDomainCommand(project));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid domain add <subcommand>';

  @override
  String get description =>
      'Add subdomains to the domain part of a Rapid project.';
}
