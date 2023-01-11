import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'entity_bundle.dart';

// TODO share code with add cubit command

/// {@template domain_add_entity_command}
/// `rapid domain add entity` command adds entity to the domain part part of an existing Rapid project.
/// {@endtemplate}
class DomainAddEntityCommand extends Command<int> with OverridableArgResults {
  /// {@macro domain_add_entity_command}
  DomainAddEntityCommand({
    Logger? logger,
    required Project project,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addSeparator('')
      // TODO add hint that its a dart package nameish string but not the full name of the related package
      ..addOption(
        'output-dir',
        help: 'The output directory inside domain packages lib directory.',
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
      'Adds a entity to the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final projectName = _project.melosFile.name();
        final name = _name;
        final outputDir = _outputDir;

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

        _logger.success(
          'Added Entity ${name.pascalCase}.',
        );

        return ExitCode.success.code;
      });

  /// Gets the name of the bloc.
  String get _name => _validateNameArg(argResults.rest);

  /// The output directory inside domain packages lib directory.
  String get _outputDir => argResults['output-dir'] ?? '.'; // TODO does . work?

  /// Validates whether [name] is valid feature name.
  ///
  /// Returns [name] when valid.
  String _validateNameArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the name.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple names specified.', usage);
    }

    final name = args.first;
    final isValid = isValidClassName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid dart class name.',
        usage,
      );
    }

    return name;
  }
}
