import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/remove/sub_domain/sub_domain.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_remove_command}
/// `rapid domain remove` command remove subdomains from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveCommand extends Command<int> {
  /// {@macro domain_remove_command}
  DomainRemoveCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(DomainRemoveSubDomainCommand(project: project));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid domain remove <subcommand>';

  @override
  String get description =>
      'Remove subdomains from the domain part of an existing Rapid project.';
}
