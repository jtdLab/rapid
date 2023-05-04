import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/dart_package_name_rest.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/platform.dart';

/// {@template domain_remove_sub_domain_command}
/// `rapid domain remove sub_domain` command remove subdomains from the domain part of an existing Rapid project.
/// {@endtemplate}
class DomainRemoveSubDomainCommand extends RapidRootCommand
    with DartPackageNameGetter, GroupableMixin, BootstrapMixin, CodeGenMixin {
  /// {@macro domain_remove_sub_domain_command}
  DomainRemoveSubDomainCommand({
    super.logger,
    super.project,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

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
        [projectExistsAll(project)],
        logger,
        () async {
          final name = super.dartPackageName;

          logger.info('Removing subdomain ...');

          final domainDirectory = project.domainDirectory;
          final domainPackage = domainDirectory.domainPackage(name: name);
          if (domainPackage.exists()) {
            final infrastructureDirectory = project.infrastructureDirectory;
            final infrastructurePackage =
                infrastructureDirectory.infrastructurePackage(name: name);
            if (infrastructurePackage.exists()) {
              domainPackage.delete();
              infrastructurePackage.delete();

              final activatedPlatformRootPackages = Platform.values
                  .where((platform) => project.platformIsActivated(platform))
                  .map(
                    (platform) => project
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

              logger
                ..info('')
                ..success('Removed subdomain $name.');

              return ExitCode.success.code;
            } else {
              logger
                ..info('')
                ..err('The subinfrastructure "$name" does not exist.');

              return ExitCode.config.code;
            }
          } else {
            logger
              ..info('')
              ..err('The subdomain "$name" does not exist.');

            return ExitCode.config.code;
          }
        },
      );
}
