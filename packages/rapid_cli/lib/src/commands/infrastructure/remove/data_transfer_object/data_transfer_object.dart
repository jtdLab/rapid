import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';

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
      'rapid infrastructure remove data_transfer_object [arguments]';

  @override
  String get description =>
      'Remove a data transfer object from the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final name = super.className;
        final dir = super.dir;

        // TODO remove

        _logger.success('Removed Data Transfer Object ${name.pascalCase}.');

        return ExitCode.success.code;
      });
}
