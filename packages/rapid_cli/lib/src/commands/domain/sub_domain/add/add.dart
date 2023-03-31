import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/add/entity/entity.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/add/service_interface/service_interface.dart';
import 'package:rapid_cli/src/commands/domain/sub_domain/add/value_object/value_object.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_sub_domain_add_command}
/// `rapid domain sub_domain add` command add components to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainSubDomainAddCommand extends Command<int> {
  /// {@macro domain_sub_domain_add_command}
  DomainSubDomainAddCommand({
    Logger? logger,
    required Project project,
  }) {
    addSubcommand(DomainSubDomainAddEntityCommand(project: project));
    addSubcommand(DomainSubDomainAddServiceInterfaceCommand(project: project));
    addSubcommand(DomainSubDomainAddValueObjectCommand(project: project));
  }

  @override
  String get name => 'add';

  @override
  String get invocation => 'rapid domain sub_domain add <component>';

  @override
  String get description =>
      'Add a component to the domain part of an existing Rapid project.';
}
