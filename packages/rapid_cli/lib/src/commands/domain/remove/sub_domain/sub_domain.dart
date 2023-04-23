import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/dart_package_name_rest.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
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
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Logger _logger;
  final Project _project;
  final MelosBootstrapCommand _melosBootstrap;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

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

              final activatedPlatformRootPackages = Platform.values
                  .where((platform) => _project.platformIsActivated(platform))
                  .map(
                    (platform) => _project
                        .platformDirectory(platform: platform)
                        .rootPackage,
                  );

              for (final rootPackage in activatedPlatformRootPackages) {
                await rootPackage
                    .unregisterInfrastructurePackage(infrastructurePackage);
              }

              await _melosBootstrap(
                cwd: _project.path,
                scope: [
                  ...activatedPlatformRootPackages.map((e) => e.packageName()),
                ],
                logger: _logger,
              );

              for (final rootPackage in activatedPlatformRootPackages) {
                await _flutterPubGet(cwd: rootPackage.path, logger: _logger);
                await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
                  cwd: rootPackage.path,
                  logger: _logger,
                );
              }

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
