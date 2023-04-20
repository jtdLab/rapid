import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/remove/entity/entity.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/remove/service_interface/service_interface.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/remove/value_object/value_object.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_sub_domain_remove_command}
/// `rapid domain sub_domain remove` command remove components from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainRemoveCommand extends Command<int> {
  /// {@macro domain_sub_domain_remove_command}
  DomainSubDomainRemoveCommand({
    Logger? logger,
    Project? project,
  }) {
    addSubcommand(DomainSubDomainRemoveEntityCommand(project: project));
    addSubcommand(
      DomainSubDomainRemoveServiceInterfaceCommand(project: project),
    );
    addSubcommand(DomainSubDomainRemoveValueObjectCommand(project: project));
  }

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid domain sub_domain remove <component>';

  @override
  String get description =>
      'Remove a component from the domain part of an existing Rapid project.';
}
