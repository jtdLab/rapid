import 'dart:async';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/package_option.dart';
import 'package:rapid_cli/src/core/dart_package.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO impl cleaner + e2e test

/// {@template pub_remove_command}
/// `rapid pub remove` command remove packages in a Rapid environment.
/// {@endtemplate}
class PubRemoveCommand extends RapidNonRootCommand
    with PackageGetter, GroupableMixin, BootstrapMixin {
  /// {@macro pub_remove_command}
  PubRemoveCommand({
    super.logger,
    super.project,
    FlutterPubRemoveCommand? flutterPubRemove,
    MelosBootstrapCommand? melosBootstrap,
  })  : _flutterPubRemove = flutterPubRemove ?? Flutter.pubRemove,
        melosBootstrap = melosBootstrap ?? Melos.bootstrap {
    argParser.addPackageOption(
      help: 'The package where the command is run in.',
    );
  }

  final FlutterPubRemoveCommand _flutterPubRemove;
  @override
  final MelosBootstrapCommand melosBootstrap;

  @override
  String get name => 'remove';

  @override
  String get invocation => 'rapid pub remove [packages]';

  @override
  String get description => 'Remove packages in a Rapid environment.';

  @override
  Future<int> run() async {
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
    final packages = _packages;
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

    // TODO good ?
    if (!projectPackages.map((e) => e.packageName()).contains(packageName)) {
      throw RapidException('Package $packageName not found.');
    }

    logger.commandTitle('Removing Dependencies from "$packageName" ...');

    final package =
        projectPackages.firstWhere((e) => e.packageName() == packageName);

    await _flutterPubRemove(
      cwd: package.path,
      logger: logger,
      packages: packages,
    );

    final dependingPackages =
        projectPackages.where((e) => e.pubspecFile.hasDependency(packageName!));

    await bootstrap(
      packages: [
        package,
        ...dependingPackages,
      ],
      logger: logger,
    );

    logger.commandSuccess('Removed ${packages.join(', ')} from $packageName!');

    return ExitCode.success.code;
  }

  List<String> get _packages {
    return argResults.rest;
  }
}
