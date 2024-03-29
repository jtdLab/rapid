import '../project/project.dart';
import 'base.dart';
import 'domain/add.dart';
import 'domain/remove.dart';
import 'domain/sub_domain.dart';

/// {@template domain_command}
/// `rapid domain` work with the domain part of a Rapid project.
/// {@endtemplate}
class DomainCommand extends RapidBranchCommand {
  /// {@macro domain_command}
  DomainCommand(super.project) {
    addSubcommand(DomainAddCommand(project));
    addSubcommand(DomainRemoveCommand(project));
    final domainPackages = project?.appModule.domainDirectory.domainPackages();
    for (final domainPackage in domainPackages ?? <DomainPackage>[]) {
      addSubcommand(
        DomainSubdomainCommand(
          project,
          subDomainName: domainPackage.name ?? 'default',
        ),
      );
    }
  }

  @override
  String get name => 'domain';

  @override
  String get invocation => 'rapid domain <subcommand>';

  @override
  String get description => 'Work with the domain part of a Rapid project.';
}
