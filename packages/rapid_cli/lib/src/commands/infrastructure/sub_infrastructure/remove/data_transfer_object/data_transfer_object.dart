import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/entity_option.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/sub_infrastructure_option.dart';

// TODO maybe introduce super class for dto and service implementation remove

/// {@template infrastructure_sub_infrastructure_remove_data_transfer_object_command}
/// `rapid infrastructure sub_infrastructure remove data_transfer_object` command removes data transfer object from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveDataTransferObjectCommand
    extends RapidRootCommand
    with SubInfrastructureGetter, EntityGetter, DirGetter {
  /// {@macro infrastructure_sub_infrastructure_remove_data_transfer_object_command}
  InfrastructureSubInfrastructureRemoveDataTransferObjectCommand({
    super.logger,
    super.project,
  }) {
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
        [projectExistsAll(project)],
        logger,
        () async {
          final infrastructureName = super.subInfrastructure;
          final entityName = super.entity;
          final dir = super.dir;

          logger.commandTitle(
            'Removing Data Transfer Object for Entity "$entityName"${infrastructureName != null ? ' from $infrastructureName' : ''} ...',
          );

          final infrastructureDirectory = project.infrastructureDirectory;
          final infrastructurePackage = infrastructureDirectory
              .infrastructurePackage(name: infrastructureName);
          final dataTransferObject = infrastructurePackage.dataTransferObject(
            name: entityName,
            dir: dir,
          );
          if (dataTransferObject.existsAny()) {
            dataTransferObject.delete();

            final barrelFile = infrastructurePackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join('src', dir, '${entityName.snakeCase}_dto.dart'),
              ),
            );

            logger.commandSuccess(
              'Removed Data Transfer Object ${entityName}Dto.',
            );

            return ExitCode.success.code;
          } else {
            logger.commandError(
              'Data Transfer Object ${entityName}Dto does not exist.',
            );

            return ExitCode.config.code;
          }
        },
      );
}
