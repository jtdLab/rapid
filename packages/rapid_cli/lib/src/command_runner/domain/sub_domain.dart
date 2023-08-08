import '../base.dart';
import 'sub_domain/add.dart';
import 'sub_domain/remove.dart';

/// {@template domain_sub_domain_command}
/// `rapid domain sub_domain` work with a subdomain of the domain part of
/// a Rapid project.
/// {@endtemplate}
class DomainSubdomainCommand extends RapidSubDomainBranchCommand {
  /// {@macro domain_sub_domain_command}
  DomainSubdomainCommand(super.project, {required super.subDomainName}) {
    addSubcommand(
      DomainSubDomainAddCommand(
        project,
        subDomainName: subDomainName,
      ),
    );
    addSubcommand(
      DomainSubDomainRemoveCommand(
        project,
        subDomainName: subDomainName,
      ),
    );
  }

  @override
  String get name => subDomainName;

  @override
  String get invocation => 'rapid domain $subDomainName <command>';

  @override
  String get description => 'Work with the subdomain $subDomainName.';
}
