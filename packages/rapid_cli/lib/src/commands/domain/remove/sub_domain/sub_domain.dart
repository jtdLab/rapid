import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/dart_package_name_rest.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_remove_sub_domain_command}
/// `rapid domain remove sub_domain` command remove subdomains from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveSubDomainCommand extends Command<int>
    with OverridableArgResults, DartPackageNameGetter {
  /// {@macro domain_remove_sub_domain_command}
  DomainRemoveSubDomainCommand({
    Logger? logger,
    Project? project,
    MelosBootstrapCommand? melosBootstrap,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap;

  final Logger _logger;
  final Project _project;
  final MelosBootstrapCommand _melosBootstrap;

  @override
  String get name => 'sub_domain';

  @override
  List<String> get aliases => ['sub', 'sd'];

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
          final name = super.dartPackageName;

          _logger.info('Removing subdomain ...');

          final domainDirectory = _project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: name);
          if (domainPackage.exists()) {
            final infrastructureDirectory = _project.infrastructureDirectory;
            final infrastructurePackage =
                infrastructureDirectory.infrastructurePackage(name: name);
            if (infrastructurePackage.exists()) {
              domainPackage.delete();
              infrastructurePackage.delete();

              await _melosBootstrap(
                cwd: _project.path,
                scope: [
                  domainPackage.packageName(),
                  infrastructurePackage.packageName(),
                ],
                logger: _logger,
              );

              _logger
                ..info('')
                ..success('Removed subdomain $name.');

              return ExitCode.success.code;
            } else {
              _logger
                ..info('')
                ..err('The subinfrastructure "$name" does not exist.');

              return ExitCode.config.code;
            }
          } else {
            _logger
              ..info('')
              ..err('The subdomain "$name" does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
