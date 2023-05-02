import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO impl cleaner + e2e test

/// {@template pub_add_command}
/// `rapid pub add` command add packages in a Rapid environment.
/// {@endtemplate}
class PubAddCommand extends Command<int> with OverridableArgResults {
  /// {@macro pub_add_command}
  PubAddCommand({
    Logger? logger,
    ProjectBuilder? project,
    FlutterPubAddCommand? flutterPubAdd,
    MelosBootstrapCommand? melosBootstrap,
  })  : _logger = logger ?? Logger(),
        _project = project ?? (({String path = '.'}) => Project(path: path)),
        _flutterPubAdd = flutterPubAdd ?? Flutter.pubAdd,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap;

  final Logger _logger;
  final ProjectBuilder _project;
  final FlutterPubAddCommand _flutterPubAdd;
  final MelosBootstrapCommand _melosBootstrap;

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
        _logger,
        () async {
          final rootDir = _findRootDir(Directory.current);
          final project = _project(path: rootDir.path);
          final unparsedPackages = _packages;
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
          if (publicPackagesToAdd.isNotEmpty) {
            await _flutterPubAdd(
              cwd: '.',
              packages: publicPackagesToAdd,
              logger: _logger,
            );
          }
          if (publicDevPackagesToAdd.isNotEmpty) {
            await _flutterPubAdd(
              cwd: '.',
              packages: publicDevPackagesToAdd,
              logger: _logger,
            );
          }
          final packagePubspec = PubspecFile();
          for (final localPackage in localPackagesToAdd) {
            final name = localPackage.trim().split(':').first;
            packagePubspec.setDependency(name);
          }
          for (final localDevPackage in localDevPackagesToAdd) {
            final name = localDevPackage.trim().split(':')[1];
            packagePubspec.setDependency(name, dev: true);
          }
          final packageName = packagePubspec.readName();
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

          final dependingPackageNames = projectPackages
              .where((e) => e.pubspecFile.hasDependency(packageName))
              .map((e) => e.pubspecFile.readName())
              .toList();

          await _melosBootstrap(
            cwd: rootDir.path,
            scope: [
              if (localPackagesToAdd.isNotEmpty ||
                  localDevPackagesToAdd.isNotEmpty)
                packageName,
              ...dependingPackageNames,
            ],
            logger: _logger,
          );

          _logger
            ..info('')
            ..success(
              'Added ${unparsedPackages.length == 1 ? unparsedPackages.first : unparsedPackages.join(', ')} to $packageName.',
            );

          return ExitCode.success.code;
        },
      );

  // TODO share with remove
  Directory _findRootDir(Directory dir) {
    final melosFile = File(p.join(dir.path, 'melos.yaml'));
    if (melosFile.existsSync()) {
      return dir;
    }

    final parent = dir.parent;
    if (dir.path == parent.path) {
      throw UsageException(
        'Could not find Rapid project root.'
        'Did you call this command from within a Rapid workspace?',
        usage,
      );
    }

    return _findRootDir(parent);
  }

  List<String> get _packages {
    return argResults.rest;
  }
}
