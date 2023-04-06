import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/entity_option.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/sub_infrastructure_option.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO maybe introduce super class for dto and service implementation remove

/// {@template infrastructure_sub_infrastructure_remove_data_transfer_object_command}
/// `rapid infrastructure sub_infrastructure remove data_transfer_object` command removes data transfer object from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveDataTransferObjectCommand
    extends Command<int>
    with
        OverridableArgResults,
        SubInfrastructureGetter,
        EntityGetter,
        DirGetter {
  /// {@macro infrastructure_sub_infrastructure_remove_data_transfer_object_command}
  InfrastructureSubInfrastructureRemoveDataTransferObjectCommand({
    Logger? logger,
    Project? project,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project() {
    argParser
      ..addSeparator('')
      ..addSubInfrastructureOption(
        help:
            'The name of the subinfrastructure the data transfer object will be removed from.\n'
            'This must be the name of an existing subinfrastructure.',
      )
      ..addSeparator('')
      ..addEntityOption()
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
      'rapid infrastructure sub_infrastructure remove data_transfer_object <name> [arguments]';

  @override
  String get description =>
      'Remove a data transfer object from the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final infrastructureName = super.subInfrastructure;
          final entityName = super.entity;
          final dir = super.dir;

          _logger.info('Removing Data Transfer Object ...');

          final infrastructureDirectory = _project.infrastructureDirectory;
          final infrastructurePackage = infrastructureDirectory
              .infrastructurePackage(name: infrastructureName);
          final dataTransferObject = infrastructurePackage.dataTransferObject(
            name: entityName,
            dir: dir,
          );
          if (dataTransferObject.existsAny()) {
            dataTransferObject.delete();

            _logger
              ..info('')
              ..success('Removed Data Transfer Object ${name}Dto.');

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err('Data Transfer Object ${name}Dto does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
