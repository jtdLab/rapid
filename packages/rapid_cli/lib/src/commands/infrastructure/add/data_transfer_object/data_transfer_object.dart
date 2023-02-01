import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO in test template without output dir a path gets a unneccessary dot

/// {@template infrastructure_add_data_transfer_object_command}
/// `rapid infrastructure add data_transfer_object` command adds data_transfer_object to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureAddDataTransferObjectCommand extends Command<int>
    with OverridableArgResults, OutputDirGetter {
  /// {@macro infrastructure_add_data_transfer_object_command}
  InfrastructureAddDataTransferObjectCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addOption(
        'entity',
        help: 'The entity the data transfer object is related to.',
        abbr: 'e',
      )
      ..addOutputDirOption(
        help:
            'The output directory relative to <infrastructure_package>/lib/src .',
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
      'rapid infrastructure add data_transfer_object [arguments]';

  @override
  String get description =>
      'Add a data transfer object to the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExists(_project)],
        _logger,
        () async {
          final entityName = _entity;
          final outputDir = super.outputDir;

          _logger.info('Adding Data Transfer Object ...');

          try {
            await _project.addDataTransferObject(
              entityName: entityName,
              outputDir: outputDir,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success(
                'Added Data Transfer Object ${entityName}Dto.',
              );

            return ExitCode.success.code;
          } on EntityDoesNotExist {
            _logger
              ..info('')
              ..err(
                'Entity $entityName does not exist.',
              );

            return ExitCode.config.code;
          } on DataTransferObjectAlreadyExists {
            _logger
              ..info('')
              ..err(
                'Data Transfer Object ${entityName}Dto already exists.',
              );

            return ExitCode.config.code;
          }
        },
      );

  /// Gets the name of the entity the data transfer object is related to.
  String get _entity => _validateEntityArg(argResults['entity']);

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
