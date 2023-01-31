import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_remove_service_interface_command}
/// `rapid domain remove service_interface` command removes service interface from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveServiceInterfaceCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, DirGetter {
  /// {@macro domain_remove_service_interface_command}
  DomainRemoveServiceInterfaceCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addDirOption(
        help: 'The directory relative to <domain_package>/lib/ .',
      );
  }

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'service_interface';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid domain remove service_interface <name> [arguments]';

  @override
  String get description =>
      'Remove a service interface from the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExists(_project)],
        _logger,
        () async {
          final name = super.className;
          final dir = super.dir;

          try {
            await _project.removeServiceInterface(
              name: name,
              dir: dir,
              logger: _logger,
            );

            // TODO only name sucks
            _logger
              ..info('')
              ..success('Removed Service Interface ${name.pascalCase}.');

            return ExitCode.success.code;
          } on ServiceInterfaceDoesNotExist {
            // TODO only name sucks
            _logger
              ..info('')
              ..err('Service Interface ${name.pascalCase} not found.');

            return ExitCode.config.code;
          }
        },
      );
}
