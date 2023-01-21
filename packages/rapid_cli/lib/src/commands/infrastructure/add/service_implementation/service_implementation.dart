import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/class_name_arg.dart';
import 'package:rapid_cli/src/commands/core/output_dir_option.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_class_name.dart';
import 'package:rapid_cli/src/project/project.dart';
import 'package:recase/recase.dart';

/// {@template infrastructure_add_service_implementation_command}
/// `rapid infrastructure add service_implementation` command adds service_implementation to the infrastructure part of an existing Rapid project.
/// {@endtemplate}
class InfrastructureAddServiceImplementationCommand extends Command<int>
    with OverridableArgResults, ClassNameGetter, OutputDirGetter {
  /// {@macro infrastructure_add_service_implementation_command}
  InfrastructureAddServiceImplementationCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project {
    argParser
      ..addSeparator('')
      ..addOption(
        'service',
        help: 'The service interface the service implementation is related to.',
        abbr: 's',
      )
      ..addOutputDirOption(
        help:
            'The output directory relative to <infrastructure_package>/lib/src .',
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
      'rapid infrastructure add service_implementation [arguments]';

  @override
  String get description =>
      'Add a service implementation to the infrastructure part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [isProjectRoot(_project)],
        _logger,
        () async {
          final name = super.className;
          final serviceName = _service;
          final outputDir = super.outputDir;

          final infrastructurePackage = _project.infrastructurePackage;
          final serviceImplementation =
              infrastructurePackage.serviceImplementation(
            name: name,
            serviceName: serviceName,
            dir: outputDir,
          );
          if (!serviceImplementation.exists()) {
            await serviceImplementation.create(logger: _logger);

            // TODO better hint containg related service etc
            _logger.success('Added Service Implementation ${name.pascalCase}.');

            return ExitCode.success.code;
          } else {
            _logger.err('Service Implementation $name already exists.');

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
