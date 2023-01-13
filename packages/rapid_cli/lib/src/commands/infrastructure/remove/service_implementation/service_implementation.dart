import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/project/project.dart';

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

        final infrastructurePackage = _project.infrastructurePackage;
        final serviceImplementation =
            infrastructurePackage.serviceImplementation(name: name, dir: dir);

        final exists = serviceImplementation.exists();
        if (exists) {
          final deletedFiles = serviceImplementation.delete();

          for (final file in deletedFiles) {
            _logger.info(file.path);
          }

          _logger.info('');
          _logger.info('Deleted ${deletedFiles.length} item(s)');
          _logger.info('');
          _logger.success('Removed Service Implementation $name.');

          return ExitCode.success.code;
        } else {
          _logger.err('Service Implementation $name not found.');

          return ExitCode.config.code;
        }
      });
}
