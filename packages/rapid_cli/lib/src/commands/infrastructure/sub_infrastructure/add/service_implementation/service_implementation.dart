import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_rest.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/infrastructure/sub_infrastructure/core/service_option.dart';
import 'package:rapid_cli/src/project/infrastructure_directory/infrastructure_package/infrastructure_package.dart';

/// {@template infrastructure_sub_infrastructure_add_service_implementation_command}
/// `rapid infrastructure sub_infrastructure add service_implementation` command adds service_implementation to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureSubInfrastructureAddServiceImplementationCommand
    extends RapidRootCommand
    with ClassNameGetter, ServiceGetter, OutputDirGetter {
  /// {@macro infrastructure_sub_infrastructure_add_service_implementation_command}
  InfrastructureSubInfrastructureAddServiceImplementationCommand({
    super.logger,
    required InfrastructurePackage infrastructurePackage,
    super.project,
    DartFormatFixCommand? dartFormatFix,
  })  : _infrastructurePackage = infrastructurePackage,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addServiceOption()
      ..addOutputDirOption(
        help:
            'The output directory relative to <infrastructure_package>/lib/src .',
      );
  }

  final InfrastructurePackage _infrastructurePackage;

  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure ${_infrastructurePackage.name ?? 'default'} add service_implementation <name> [arguments]';

  @override
  String get description =>
      'Add a service implementation to the subinfrastructure ${_infrastructurePackage.name ?? 'default'}.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.className;
          final infrastructureName = _infrastructurePackage.name ?? 'default';
          final serviceName = super.service;
          final outputDir = super.outputDir;

          logger.commandTitle(
            'Adding Service Implementation "$name" for Service Interface "$serviceName" to $infrastructureName ...',
          );

          final domainDirectory = project.domainDirectory;
          final domainPackage =
              domainDirectory.domainPackage(name: _infrastructurePackage.name);
          final serviceInterface =
              domainPackage.serviceInterface(name: serviceName, dir: outputDir);
          if (serviceInterface.existsAll()) {
            final serviceImplementation =
                _infrastructurePackage.serviceImplementation(
              name: name,
              serviceName: serviceName,
              dir: outputDir,
            );

            if (!serviceImplementation.existsAny()) {
              await serviceImplementation.create();

              final barrelFile = _infrastructurePackage.barrelFile;
              barrelFile.addExport(
                p.normalize(
                  p.join(
                    'src',
                    outputDir,
                    '${name.snakeCase}_${serviceName.snakeCase}_service.dart',
                  ),
                ),
              );

              await _dartFormatFix(
                cwd: _infrastructurePackage.path,
                logger: logger,
              );

              // TODO better hint containg related service etc
              logger.commandSuccess();

              return ExitCode.success.code;
            } else {
              logger.commandError(
                'Service Implementation $name${serviceName}Service already exists.',
              );

              return ExitCode.config.code;
            }
          } else {
            logger.commandError(
              'Service Interface I${serviceName}Service does not exist.',
            );

            return ExitCode.config.code;
          }
        },
      );
}
