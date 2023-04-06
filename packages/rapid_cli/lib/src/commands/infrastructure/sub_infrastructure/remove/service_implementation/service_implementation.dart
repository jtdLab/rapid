import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/service_option.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/sub_infrastructure_option.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_sub_infrastructure_remove_service_implementation_command}
/// `rapid infrastructure sub_infrastructure remove service_implementation` command removes service implementation from the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureRemoveServiceImplementationCommand
    extends Command<int>
    with
        OverridableArgResults,
        ClassNameGetter,
        SubInfrastructureGetter,
        ServiceGetter,
        DirGetter {
  /// {@macro infrastructure_sub_infrastructure_remove_service_implementation_command}
  InfrastructureSubInfrastructureRemoveServiceImplementationCommand({
    Logger? logger,
    Project? project,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project() {
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

  final Logger _logger;
  final Project _project;

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
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final infrastructureName = super.subInfrastructure;
          final serviceName = super.service;
          final dir = super.dir;

          _logger.info('Removing Service Implementation ...');

          final infrastructureDirectory = _project.infrastructureDirectory;
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

            _logger
              ..info('')
              ..success(
                'Removed Service Implementation $name${serviceName}Service.',
              );

            return ExitCode.success.code;
          } else {
            _logger
              ..info('')
              ..err(
                'Service Implementation $name${serviceName}Service does not exist.',
              );

            return ExitCode.config.code;
          }
        },
      );
}
