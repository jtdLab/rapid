import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/package_option.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO impl cleaner + e2e test

/// {@template pub_add_command}
/// `rapid pub add` command add packages in a Rapid environment.
/// {@endtemplate}
class PubAddCommand extends RapidNonRootCommand
    with PackageGetter, GroupableMixin, BootstrapMixin {
  /// {@macro pub_add_command}
  PubAddCommand({
    super.logger,
    super.project,
    FlutterPubAddCommand? flutterPubAdd,
    MelosBootstrapCommand? melosBootstrap,
  })  : _flutterPubAdd = flutterPubAdd ?? Flutter.pubAdd,
        melosBootstrap = melosBootstrap ?? Melos.bootstrap {
    argParser.addPackageOption(
      help: 'The package where the command is run.',
    );
  }

  final FlutterPubAddCommand _flutterPubAdd;
  @override
  final MelosBootstrapCommand melosBootstrap;

  @override
  String get name => 'add';

  @override
  String get invocation =>
      'rapid pub add [dev:]<package>[:descriptor] [[dev:]<package>[:descriptor] ...]';

  @override
  String get description => 'Add packages in a Rapid environment.';

  @override
  Future<int> run() => runWhen(
        [
          pubspecExists(),
        ],
        logger,
        () async {
          var packageName = super.package;
          if (packageName == null) {
            final pubspec = PubspecFile();
            try {
              packageName = pubspec.readName();
            } catch (e) {
              throw UsageException(
                'This command must either be called from within a package or with a explicit package via the "package" argument.',
                usage,
              );
            }
          }
          final projectPackages = <DartPackage>[
            project.diPackage,
            ...project.domainDirectory.domainPackages(),
            ...project.infrastructureDirectory.infrastructurePackages(),
            project.loggingPackage,
            project.uiPackage,
            for (final platform in Platform.values.where(
                (platform) => project.platformIsActivated(platform))) ...[
              project.platformDirectory(platform: platform).rootPackage,
              project.platformDirectory(platform: platform).navigationPackage,
              ...project
                  .platformDirectory(platform: platform)
                  .featuresDirectory
                  .featurePackages(),
              project.platformUiPackage(platform: platform),
            ],
          ];
          // TODO good
          if (!projectPackages
              .map((e) => e.packageName())
              .contains(packageName)) {
            throw RapidException('Package $packageName not found.');
          }

          final unparsedPackages = _packages;

          logger.commandTitle('Adding Dependencies to "$packageName" ...');

          final localPackagesToAdd = unparsedPackages
              .where(
                  (e) => !e.trim().startsWith('dev') && e.trim().endsWith(':'))
              .toList();
          final localDevPackagesToAdd = unparsedPackages
              .where(
                  (e) => e.trim().startsWith('dev') && e.trim().endsWith(':'))
              .toList();
          final publicPackagesToAdd = unparsedPackages
              .where(
                  (e) => !e.trim().startsWith('dev') && !e.trim().endsWith(':'))
              .toList();
          final publicDevPackagesToAdd = unparsedPackages
              .where(
                  (e) => e.trim().startsWith('dev') && !e.trim().endsWith(':'))
              .toList();

          final package =
              projectPackages.firstWhere((e) => e.packageName() == packageName);
          if (publicPackagesToAdd.isNotEmpty) {
            await _flutterPubAdd(
              cwd: package.path,
              packages: publicPackagesToAdd,
              logger: logger,
            );
          }
          if (publicDevPackagesToAdd.isNotEmpty) {
            await _flutterPubAdd(
              cwd: package.path,
              packages: publicDevPackagesToAdd,
              logger: logger,
            );
          }

          for (final localPackage in localPackagesToAdd) {
            final name = localPackage.trim().split(':').first;
            package.pubspecFile.setDependency(name);
          }
          for (final localDevPackage in localDevPackagesToAdd) {
            final name = localDevPackage.trim().split(':')[1];
            package.pubspecFile.setDependency(name, dev: true);
          }

          final dependingPackages = projectPackages
              .where((e) => e.pubspecFile.hasDependency(packageName!));

          await bootstrap(
            packages: [
              package,
              ...dependingPackages,
            ],
            logger: logger,
          );

          logger.commandSuccess(
            'Added ${unparsedPackages.length == 1 ? unparsedPackages.first : unparsedPackages.join(', ')} to $packageName!',
          );

          return ExitCode.success.code;
        },
      );

  List<String> get _packages {
    return argResults.rest;
  }
}
