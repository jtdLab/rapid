import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/commands/core/validate_dart_package_name.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_remove_sub_domain_command}
/// `rapid domain remove sub_domain` command remove subdomains from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveSubDomainCommand extends Command<int>
    with OverridableArgResults {
  /// {@macro domain_remove_sub_domain_command}
  DomainRemoveSubDomainCommand({
    Logger? logger,
    required Project project,
  })  : _logger = logger ?? Logger(),
        _project = project;

  final Logger _logger;
  final Project _project;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid domain remove sub_domain <name>';

  @override
  String get description =>
      'Remove subdomains of the domain part of an existing Rapid project.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final name = _name;

          _logger.info('Removing sub domain ...');

          try {
            await _project.removeSubDomain(
              name: name,
              logger: _logger,
            );

            _logger
              ..info('')
              ..success('Removed sub domain $name.');

            return ExitCode.success.code;
          } on SubDomainDoesNotExist {
            _logger
              ..info('')
              ..err('The subdomain "$name" does not exist.');

            return ExitCode.config.code;
          }
        },
      );

  String get _name => _validateNameArg(argResults.rest);

  /// Validates whether [name] is valid feature name.
  ///
  /// Returns [name] when valid.
  String _validateNameArg(List<String> args) {
    if (args.isEmpty) {
      throw UsageException(
        'No option specified for the name.',
        usage,
      );
    }

    if (args.length > 1) {
      throw UsageException('Multiple names specified.', usage);
    }

    final name = args.first;
    final isValid = isValidPackageName(name);
    if (!isValid) {
      throw UsageException(
        '"$name" is not a valid package name.\n\n'
        'See https://dart.dev/tools/pub/pubspec#name for more information.',
        usage,
      );
    }

    return name;
  }
}
