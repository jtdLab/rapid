import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/overridable_arg_results.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO impl cleaner + e2e test

/// {@template pub_remove_command}
/// `rapid pub remove` command remove packages in a Rapid environment.
/// {@endtemplate}
class PubRemoveCommand extends Command<int> with OverridableArgResults {
  /// {@macro pub_remove_command}
  PubRemoveCommand({
    Logger? logger,
    ProjectBuilder? project,
    FlutterPubRemoveCommand? flutterPubRemove,
    MelosBootstrapCommand? melosBootstrap,
  })  : _logger = logger ?? Logger(),
        _project = project ?? (({String path = '.'}) => Project(path: path)),
        _flutterPubRemove = flutterPubRemove ?? Flutter.pubRemove,
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap;

  final Logger _logger;
  final ProjectBuilder _project;
  final FlutterPubRemoveCommand _flutterPubRemove;
  final MelosBootstrapCommand _melosBootstrap;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid pub remove [packages]';

  @override
  String get description => 'Remove packages in a Rapid environment.';

  @override
  Future<int> run() async {
    final packages = _packages;
    final rootDir = _findRootDir(Directory.current);
    final project = _project(path: rootDir.path);

    await _flutterPubRemove(
      cwd: '.',
      logger: _logger,
      packages: packages,
    );

    final packagePubspec = PubspecFile();
    final packageName = packagePubspec.readName();
    final projectPackages = <DartPackage>[
      project.diPackage,
      ...project.domainDirectory.domainPackages(),
      ...project.infrastructureDirectory.infrastructurePackages(),
      project.loggingPackage,
      project.uiPackage,
      for (final platform in Platform.values
          .where((platform) => project.platformIsActivated(platform))) ...[
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
        packageName,
        ...dependingPackageNames,
      ],
      logger: _logger,
    );

    _logger
      ..info('')
      ..success(
        'Removed ${packages.join(', ')} from $packageName.',
      );

    return ExitCode.success.code;
  }

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
