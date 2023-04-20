import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/add/add.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/remove/remove.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_sub_domain_command}
/// `rapid domain sub_domain` command work with subdomains of the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubdomainCommand extends Command<int> {
  /// {@macro domain_sub_domain_command}
  DomainSubdomainCommand({
    Logger? logger,
    Project? project,
  }) {
    addSubcommand(DomainSubDomainAddCommand(project: project));
    addSubcommand(DomainSubDomainRemoveCommand(project: project));
  }

  @override
  String get name => 'sub_domain';

  @override
  List<String> get aliases => ['sub', 'sd'];

  @override
  String get invocation => 'rapid domain sub_domain <subcommand>';

  @override
  String get description =>
      'Work with the subdomains of the domain part of an existing Rapid project.';
}
