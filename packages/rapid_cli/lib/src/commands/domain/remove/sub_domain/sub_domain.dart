import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dart_package_name_rest.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

/// {@template domain_remove_sub_domain_command}
/// `rapid domain remove sub_domain` command remove subdomains from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveSubDomainCommand extends RapidRootCommand
    with DartPackageNameGetter, GroupableMixin, BootstrapMixin, CodeGenMixin {
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
        melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Logger _logger;
  final Project _project;
  @override
  final MelosBootstrapCommand melosBootstrap;
  @override
  final FlutterPubGetCommand flutterPubGet;
  @override
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

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
                  )
                  .toList();

              for (final rootPackage in activatedPlatformRootPackages) {
                await rootPackage
                    .unregisterInfrastructurePackage(infrastructurePackage);
              }

              await bootstrap(
                packages: [
                  ...activatedPlatformRootPackages,
                ],
                logger: logger,
              );
              await codeGen(
                packages: activatedPlatformRootPackages,
                logger: logger,
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
