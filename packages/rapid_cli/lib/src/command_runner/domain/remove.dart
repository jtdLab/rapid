import '../base.dart';
import 'remove/sub_domain.dart';

/// {@template domain_remove_command}
/// `rapid domain remove` command remove subdomains from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveCommand extends RapidBranchCommand {
  /// {@macro domain_remove_command}
  DomainRemoveCommand(super.project) {
    addSubcommand(DomainRemoveSubDomainCommand(project));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid domain remove <subcommand>';

  @override
  String get description =>
      'Remove subdomains from the domain part of an existing Rapid project.';
}
