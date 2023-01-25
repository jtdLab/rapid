import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_add_service_interface_command}
/// `rapid domain add service_interface` command adds service_interface to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainAddServiceInterfaceCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, OutputDirGetter {
  /// {@macro domain_add_service_interface_command}
  DomainAddServiceInterfaceCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <domain_package>/lib/ .',
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
      'rapid domain add service_interface <name> [arguments]';

  @override
  String get description =>
      'Add a service interface to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExists(_project)],
        _logger,
        () async {
          final name = super.className;
          final outputDir = super.outputDir;

          try {
            await _project.addServiceInterface(
              name: name,
              outputDir: outputDir,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success('Added Service Interface I${name}Service.');

            return ExitCode.success.code;
          } on ServiceInterfaceAlreadyExists {
            // TODO only name is not enough
            _logger
              ..info('')
              ..err('Service Interface I${name}Service already exists.');

            return ExitCode.config.code;
          }
        },
      );
}
