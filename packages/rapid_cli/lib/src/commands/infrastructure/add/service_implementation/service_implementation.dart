import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template infrastructure_add_service_implementation_command}
/// `rapid infrastructure add service_implementation` command adds service_implementation to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureAddServiceImplementationCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, OutputDirGetter {
  /// {@macro infrastructure_add_service_implementation_command}
  InfrastructureAddServiceImplementationCommand({
    Logger? logger,
    required Project project,
    DartFormatFixCommand? dartFormatFix,
  })  : _logger = logger ?? Logger(),
        _project = project,
        _dartFormatFix = dartFormatFix ?? Dart.formatFix {
    argParser
      ..addSeparator('')
      ..addOption(
        'service',
        help:
            'The name of the service interface the service implementation is related to.',
        abbr: 's',
      )
      ..addOutputDirOption(
        help:
            'The output directory relative to <infrastructure_package>/lib/src .',
      );
  }

  final Logger _logger;
  final Project _project;
  final DartFormatFixCommand _dartFormatFix;

  @override
  String get name => 'service_implementation';

  @override
  List<String> get aliases => ['service', 'si'];

  @override
  String get invocation =>
      'rapid infrastructure add service_implementation <name> [arguments]';

  @override
  String get description =>
      'Add a service implementation to the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = super.className;
          final service = _service;
          final outputDir = super.outputDir;

          _logger.info('Adding Service Implementation ...');

          try {
            await _project.addServiceImplementation(
              name: name,
              serviceName: service,
              outputDir: outputDir,
              logger: _logger,
            );

            final infrastructurePackage = _project.infrastructurePackage;
            await _dartFormatFix(
              cwd: infrastructurePackage.path,
              logger: _logger,
            );

            // Move component name to the component as a getter
            // TODO better hint containg related service etc
            _logger
              ..info('')
              ..success(
                'Added Service Implementation ${name.pascalCase}${service.pascalCase}Service.',
              );

            return ExitCode.success.code;
          } on ServiceInterfaceDoesNotExist {
            _logger
              ..info('')
              ..err(
                'Service Interface I${service}Service does not exist.',
              );

            return ExitCode.config.code;
          } on ServiceImplementationAlreadyExists {
            _logger
              ..info('')
              ..err(
                'Service Implementation ${name.pascalCase}${service.pascalCase}Service already exists.',
              );

            return ExitCode.config.code;
          }
        },
      );

  /// Gets the name of the service interface this service implementation is related to.
  String get _service => _validateServiceArg(argResults['service']);

  /// Validates whether `service` is a valid service name.
  ///
  /// Returns `service` when valid.
  String _validateServiceArg(String? service) {
    if (service == null) {
      throw UsageException(
        'No option specified for the service.',
        usage,
      );
    }

    final isValid = isValidClassName(service);
    if (!isValid) {
      throw UsageException(
        '"$service" is not a valid dart class name.',
        usage,
      );
    }

    return service;
  }
}
