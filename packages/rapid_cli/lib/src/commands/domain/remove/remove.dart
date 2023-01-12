import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/remove/entity/entity.dart';
import 'package:rapid_cli/src/commands/domain/remove/service_interface/service_interface.dart';
import 'package:rapid_cli/src/commands/domain/remove/value_object/value_object.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_remove_command}
/// `rapid domain remove` command remove components from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveCommand extends Command<int> {
  /// {@macro domain_remove_command}
  DomainRemoveCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(DomainRemoveEntityCommand(project: project));
    addSubcommand(DomainRemoveServiceInterfaceCommand(project: project));
    addSubcommand(DomainRemoveValueObjectCommand(project: project));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid domain remove <component>';

  @override
  String get description =>
      'Remove a component from the domain part of an existing Rapid project.';
}
