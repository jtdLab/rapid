import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO maybe introduce super class for dto and service implementation remove

/// {@template infrastructure_remove_data_transfer_object_command}
/// `rapid infrastructure remove data_transfer_object` command removes data transfer object from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureRemoveDataTransferObjectCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, DirGetter {
  /// {@macro infrastructure_remove_data_transfer_object_command}
  InfrastructureRemoveDataTransferObjectCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <infrastructure_package>/lib/ .',
      );
  }

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'data_transfer_object';

  @override
  List<String> get aliases => ['dto'];

  @override
  String get invocation =>
      'rapid infrastructure remove data_transfer_object <name> [arguments]';

  @override
  String get description =>
      'Remove a data transfer object from the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExists(_project)],
        _logger,
        () async {
          final name = super.className;
          final dir = super.dir;

          try {
            await _project.removeDataTransferObject(
              name: name,
              dir: dir,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success('Removed Data Transfer Object $name.');

            return ExitCode.success.code;
          } on DataTransferObjectDoesNotExist {
            _logger
              ..info('')
              ..err('Data Transfer Object $name not found.');

            return ExitCode.config.code;
          }
        },
      );
}
