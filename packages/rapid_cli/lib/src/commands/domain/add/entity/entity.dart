import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_add_entity_command}
/// `rapid domain add entity` command adds entity to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainAddEntityCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, OutputDirGetter {
  /// {@macro domain_add_entity_command}
  DomainAddEntityCommand({
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
  String get name => 'entity';

  @override
  String get invocation => 'rapid domain add entity <name> [arguments]';

  @override
  String get description =>
      'Add an entity to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExists(_project)],
        _logger,
        () async {
          final name = super.className;
          final outputDir = super.outputDir;

          _logger.info('Adding Entity ...');

          try {
            await _project.addEntity(
              name: name,
              outputDir: outputDir,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success('Added Entity ${name.pascalCase}.');

            return ExitCode.success.code;
          } on EntityAlreadyExists {
            _logger
              ..info('')
              ..err('Entity $name already exists.');

            return ExitCode.config.code;
          }
        },
      );
}
