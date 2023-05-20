import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/service_option.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/infrastructure_package.dart';

/// {@template infrastructure_sub_infrastructure_remove_service_implementation_command}
/// `rapid infrastructure sub_infrastructure remove service_implementation` command removes service implementation from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveServiceImplementationCommand
    extends RapidRootCommand with ClassNameGetter, ServiceGetter, DirGetter {
  /// {@macro infrastructure_sub_infrastructure_remove_service_implementation_command}
  InfrastructureSubInfrastructureRemoveServiceImplementationCommand({
    super.logger,
    required InfrastructurePackage infrastructurePackage,
    super.project,
  }) : _infrastructurePackage = infrastructurePackage {
    argParser
      ..addSeparator('')
      ..addServiceOption()
      ..addDirOption(
        help: 'The directory relative to <infrastructure_package>/lib/ .',
      );
  }

  final InfrastructurePackage _infrastructurePackage;

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure ${_infrastructurePackage.name ?? 'default'} remove service_implementation <name> [arguments]';

  @override
  String get description =>
      'Remove a service implementation from the subinfrastructure ${_infrastructurePackage.name ?? 'default'}.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final infrastructureName = _infrastructurePackage.name ?? 'default';
          final serviceName = super.service;
          final dir = super.dir;

          logger.commandTitle(
            'Removing Service Implementation "$name" for Service Interface "$serviceName" from $infrastructureName ...',
          );

          final serviceImplementation =
              _infrastructurePackage.serviceImplementation(
            name: name,
            serviceName: serviceName,
            dir: dir,
          );
          if (serviceImplementation.existsAny()) {
            serviceImplementation.delete();

            final barrelFile = _infrastructurePackage.barrelFile;
            barrelFile.removeExport(
              p.normalize(
                p.join(
                  'src',
                  dir,
                  '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
                ),
              ),
            );

            logger.commandSuccess(
              'Removed Service Implementation $name${serviceName}Service.',
            );

            return ExitCode.success.code;
          } else {
            logger.commandError(
              'Service Implementation $name${serviceName}Service does not exist.',
            );

            return ExitCode.config.code;
          }
        },
      );
}
