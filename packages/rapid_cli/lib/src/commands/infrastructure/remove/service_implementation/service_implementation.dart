import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';

/// {@template infrastructure_remove_service_implementation_command}
/// `rapid infrastructure remove service_implementation` command removes service implementation from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureRemoveServiceImplementationCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, DirGetter {
  /// {@macro infrastructure_remove_service_implementation_command}
  InfrastructureRemoveServiceImplementationCommand({
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
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure remove service_implementation [arguments]';

  @override
  String get description =>
      'Remove a service implementation from the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final name = super.className;
        final dir = super.dir;

        // TODO remove

        _logger.success('Removed Service Implementation ${name.pascalCase}.');

        return ExitCode.success.code;
      });
}
