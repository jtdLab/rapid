import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/generator_builder.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when_cwd_has_melos.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';
import 'package:universal_io/io.dart';

import 'data_transfer_object_bundle.dart';

// TODO share code with other infrastructure add commands
// TODO in test template without output dir a path gets a unneccessary dot

/// The default output directory inside `<infrastructure_package>/lib/`.
const _defaultOutputDir = '.';

/// {@template infrastructure_add_data_transfer_object_command}
/// `rapid infrastructure add data_transfer_object` command adds data_transfer_object to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureAddDataTransferObjectCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro infrastructure_add_data_transfer_object_command}
  InfrastructureAddDataTransferObjectCommand({
    Logger? logger,
    required Project project,
    GeneratorBuilder? generator,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _generator = generator ?? MasonGenerator.fromBundle {
    argParser
      ..addSeparator('')
      ..addOption(
        'entity',
        help: 'The entity the data transfer object is related to.',
        abbr: 'e',
        // mandatory: true // TODO good ?
      )
      ..addOption(
        'output-dir',
        help:
            'The output directory inside infrastructure packages lib directory.',
        abbr: 'o',
        defaultsTo: _defaultOutputDir,
      );
  }

  final Logger _logger;
  final Project _project;
  final GeneratorBuilder _generator;

  @override
  String get name => 'data_transfer_object';

  @override
  List<String> get aliases => ['dto'];

  @override
  String get invocation =>
      'rapid infrastructure add data_transfer_object [arguments]';

  @override
  String get description =>
      'Adds a data transfer object to the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhenCwdHasMelos(_project, _logger, () async {
        final projectName = _project.melosFile.name();
        final entityName = _entity;
        final outputDir = _outputDir;

        final generateProgress = _logger.progress('Generating files');
        final generator = await _generator(dataTransferObjectBundle);
        final files = await generator.generate(
          DirectoryGeneratorTarget(Directory('.')),
          vars: <String, dynamic>{
            'project_name': projectName,
            'entity_name': entityName,
            'output_dir': outputDir,
          },
          logger: _logger,
        );
        generateProgress.complete('Generated ${files.length} file(s)');

        _logger.success(
          'Added Data Transfer Object ${entityName.pascalCase}Dto.',
        );

        return ExitCode.success.code;
      });

  /// Gets the name of the entity the data transfer object is related to.
  String get _entity => _validateEntityArg(argResults['entity']);

  /// The output directory inside infrastructure packages lib directory.
  String get _outputDir => argResults['output-dir'] ?? _defaultOutputDir;

  // TODO this doc is wrong in other commands here it is correct (name ref is wrong)

  /// Validates whether `entity` is a valid entity name.
  ///
  /// Returns `entity` when valid.
  String _validateEntityArg(String? entity) {
    if (entity == null) {
      throw UsageException(
        'No option specified for the entity.',
        usage,
      );
    }

    final isValid = isValidClassName(entity);
    if (!isValid) {
      throw UsageException(
        '"$entity" is not a valid dart class name.',
        usage,
      );
    }

    return entity;
  }
}
