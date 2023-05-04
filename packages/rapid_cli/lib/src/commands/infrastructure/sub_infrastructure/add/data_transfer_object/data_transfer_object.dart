import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/entity_option.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/sub_infrastructure_option.dart';
// TODO in test template without output dir a path gets a unneccessary dot

/// {@template infrastructure_sub_infrastructure_add_data_transfer_object_command}
/// `rapid infrastructure sub_infrastructure add data_transfer_object` command adds data_transfer_object to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddDataTransferObjectCommand
    extends RapidRootCommand
    with SubInfrastructureGetter, EntityGetter, OutputDirGetter {
  /// {@macro infrastructure_sub_infrastructure_add_data_transfer_object_command}
  InfrastructureSubInfrastructureAddDataTransferObjectCommand({
    super.logger,
    super.project,
    DartFormatFixCommand? dartFormatFix,
  }) : _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addSubInfrastructureOption(
        help:
            'The name of the subinfrastructure this new data transfer object will be added to.\n'
            'This must be the name of an existing subinfrastructure.',
      )
      ..addSeparator('')
      ..addEntityOption()
      ..addOutputDirOption(
        help:
            'The output directory relative to <infrastructure_package>/lib/src .',
      );
  }

  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'data_transfer_object';

  @override
  List<String> get aliases => ['dto'];

  @override
  String get invocation =>
      'rapid infrastructure sub_infrastructure add data_transfer_object [arguments]';

  @override
  String get description =>
      'Add a data transfer object to the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final infrastructureName = super.subInfrastructure;
          final entityName = super.entity;
          final outputDir = super.outputDir;

          logger.commandTitle(
            'Adding Data Transfer Object for Entity "$entityName"${infrastructureName != null ? ' to $infrastructureName' : ''} ...',
          );

          final domainDirectory = project.domainDirectory;
          final domainPackage =
              domainDirectory.domainPackage(name: infrastructureName);
          final entity = domainPackage.entity(name: entityName, dir: outputDir);
          if (entity.existsAll()) {
            final infrastructureDirectory = project.infrastructureDirectory;
            final infrastructurePackage = infrastructureDirectory
                .infrastructurePackage(name: infrastructureName);
            final dataTransferObject = infrastructurePackage.dataTransferObject(
              name: entityName,
              dir: outputDir,
            );
            if (!dataTransferObject.existsAny()) {
              await dataTransferObject.create();

              final barrelFile = infrastructurePackage.barrelFile;
              barrelFile.addExport(
                p.normalize(
                  p.join('src', outputDir, '${entityName.snakeCase}_dto.dart'),
                ),
              );

              await _dartFormatFix(
                cwd: infrastructurePackage.path,
                logger: logger,
              );

              logger.commandSuccess();

              return ExitCode.success.code;
            } else {
              logger.commandError(
                'Data Transfer Object ${entityName}Dto already exists.',
              );

              return ExitCode.config.code;
            }
          } else {
            logger.commandError('Entity $entityName does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
