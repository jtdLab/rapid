import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'entity_bundle.dart';

/// {@template domain_add_entity_command}
/// `rapid domain add entity` command adds entity to the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainAddEntityCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, OutputDirGetter {
  /// {@macro domain_add_entity_command}
  DomainAddEntityCommand({
    Logger? logger,
    required Project project,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addSeparator('')
      ..addOutputDirOption(
        help: 'The output directory relative to <domain_package>/lib/ .',
      );
  }

  final Logger _logger;
  final Project _project;
  final GeneratorBuilder _generator;

  @override
  String get name => 'entity';

  @override
  String get invocation => 'rapid domain add entity [arguments]';

  @override
  String get description =>
      'Add an entity to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final projectName = _project.melosFile.name();
        final name = super.className;
        final outputDir = super.outputDir;

        final generateProgress = _logger.progress('Generating files');
        final generator = await _generator(entityBundle);
        final files = await generator.generate(
          DirectoryGeneratorTarget(Directory('.')),
          vars: <String, dynamic>{
            'project_name': projectName,
            'name': name,
            'output_dir': outputDir,
          },
          logger: _logger,
        );
        generateProgress.complete('Generated ${files.length} file(s)');

        _logger.success('Added Entity ${name.pascalCase}.');

        return ExitCode.success.code;
      });
}
