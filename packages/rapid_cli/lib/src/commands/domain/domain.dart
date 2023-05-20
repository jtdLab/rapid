import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/add/add.dart';
import 'package:rapid_cli/src/commands/domain/remove/remove.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/sub_domain.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_command}
/// `rapid domain` command work with the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainCommand extends Command<int> {
  /// {@macro domain_command}
  DomainCommand({
    Logger? logger,
    Project? project,
  }) : _project = project ?? Project() {
    addSubcommand(DomainAddCommand(project: project));
    addSubcommand(DomainRemoveCommand(project: project));
    try {
      // TODO: cleaner
      final domainPackages = _project.domainDirectory.domainPackages();
      for (final domainPackage in domainPackages) {
        addSubcommand(
          DomainSubdomainCommand(
            project: project,
            domainPackage: domainPackage,
          ),
        );
      }
    } catch (_) {}
  }

  final Project _project;

  @override
  String get name => 'domain';

  @override
  String get invocation => 'rapid domain <subcommand>';

  @override
  String get description =>
      'Work with the domain part of an existing Rapid project.';
}
