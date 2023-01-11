import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/add/entity/entity.dart';
import 'package:rapid_cli/src/commands/domain/add/service_interface/service_interface.dart';
import 'package:rapid_cli/src/commands/domain/add/value_object/value_object.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_add_command}
/// `rapid domain add` command add components to the domain part part of an existing Rapid project.
/// {@endtemplate}
class DomainAddCommand extends Command<int> {
  /// {@macro domain_add_command}
  DomainAddCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(DomainAddEntityCommand(project: project));
    addSubcommand(DomainAddServiceInterfaceCommand(project: project));
    addSubcommand(DomainAddValueObjectCommand(project: project));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid domain add <component>';

  @override
  String get description =>
      'Adds a component to the domain part of an existing Rapid project.';
}
