import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/service_option.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/sub_infrastructure_option.dart';

/// {@template infrastructure_sub_infrastructure_remove_service_implementation_command}
/// `rapid infrastructure sub_infrastructure remove service_implementation` command removes service implementation from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveServiceImplementationCommand
    extends RapidRootCommand
    with ClassNameGetter, SubInfrastructureGetter, ServiceGetter, DirGetter {
  /// {@macro infrastructure_sub_infrastructure_remove_service_implementation_command}
  InfrastructureSubInfrastructureRemoveServiceImplementationCommand({
    super.logger,
    super.project,
  }) {
    argParser
      ..addSeparator('')
      ..addSubInfrastructureOption(
        help:
            'The name of the subinfrastructure the service implementation will be removed from.\n'
            'This must be the name of an existing subinfrastructure.',
      )
      ..addSeparator('')
      ..addServiceOption()
      ..addDirOption(
        help: 'The directory relative to <infrastructure_package>/lib/ .',
      );
  }

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure sub_infrastructure remove service_implementation <name> [arguments]';

  @override
  String get description =>
      'Remove a service implementation from the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final infrastructureName = super.subInfrastructure;
          final serviceName = super.service;
          final dir = super.dir;

          logger.info('Removing Service Implementation ...');

          final infrastructureDirectory = project.infrastructureDirectory;
          final infrastructurePackage = infrastructureDirectory
              .infrastructurePackage(name: infrastructureName);
          final serviceImplementation =
              infrastructurePackage.serviceImplementation(
            name: name,
            serviceName: serviceName,
            dir: dir,
          );
          if (serviceImplementation.existsAny()) {
            serviceImplementation.delete();

            final barrelFile = infrastructurePackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join(
                  'src',
                  dir,
                  '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
                ),
              ),
            );

            logger
              ..info('')
              ..success(
                'Removed Service Implementation $name${serviceName}Service.',
              );

            return ExitCode.success.code;
          } else {
            logger
              ..info('')
              ..err(
                'Service Implementation $name${serviceName}Service does not exist.',
              );

            return ExitCode.config.code;
          }
        },
      );
}
