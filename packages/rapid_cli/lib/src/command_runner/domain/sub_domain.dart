import '../base.dart';
import 'sub_domain/add.dart';
import 'sub_domain/remove.dart';

/// {@template domain_sub_domain_command}
/// `rapid domain sub_domain` command work with subdomains of the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubdomainCommand extends RapidBranchCommand {
  /// {@macro domain_sub_domain_command}
  DomainSubdomainCommand(this.subDomainName, super.project) {
    addSubcommand(DomainSubDomainAddCommand(subDomainName, project));
    addSubcommand(DomainSubDomainRemoveCommand(subDomainName, project));
  }

  final String subDomainName;

  @override
  String get name => subDomainName;

  @override
  String get invocation => 'rapid domain $subDomainName <subcommand>';

  @override
  String get description => 'Work with the subdomain $subDomainName.';
}
