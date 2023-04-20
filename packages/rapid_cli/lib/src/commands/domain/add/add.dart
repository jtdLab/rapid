import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/add/sub_domain/sub_domain.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_add_command}
/// `rapid domain add` command add subdomains to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainAddCommand extends Command<int> {
  /// {@macro domain_add_command}
  DomainAddCommand({
    Logger? logger,
    Project? project,
  }) {
    addSubcommand(DomainAddSubDomainCommand(project: project));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid domain add <subcommand>';

  @override
  String get description =>
      'Add subdomains to the domain part of an existing Rapid project.';
}
