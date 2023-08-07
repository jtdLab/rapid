import 'dart:async';
import 'dart:io' hide Platform;

import 'package:args/command_runner.dart';
import 'package:cli_launcher/cli_launcher.dart';
import 'package:meta/meta.dart';
import 'package:pub_updater/pub_updater.dart';

import 'command_runner/activate.dart';
import 'command_runner/begin.dart';
import 'command_runner/create.dart';
import 'command_runner/deactivate.dart';
import 'command_runner/domain.dart';
import 'command_runner/end.dart';
import 'command_runner/infrastructure.dart';
import 'command_runner/platform.dart';
import 'command_runner/pub.dart';
import 'command_runner/ui.dart';
import 'exception.dart';
import 'logging.dart';
import 'project/platform.dart';
import 'project/project.dart';
import 'project_config.dart';
import 'utils.dart';
import 'version.dart';

// TODO(jtdLab): reconsider how project is resolved

/// The name of this package.
const packageName = 'rapid_cli';

/// {@template rapid_command_runner}
/// A [CommandRunner] for the Rapid Command Line Interface.
/// {@endtemplate}
class RapidCommandRunner extends CommandRunner<void> {
  /// {@macro rapid_command_runner}
  RapidCommandRunner({
    RapidProject? project,
  }) : super(
          'rapid',
          'A CLI tool for developing Flutter apps based on Rapid Architecture.',
          usageLineLength: terminalWidth,
        ) {
    argParser
      ..addFlag(
        globalOptionVersion,
        abbr: 'v',
        help: 'Print the current version.',
        negatable: false,
      )
      ..addFlag(
        globalOptionVerbose,
        help: 'Enable verbose logging.',
        negatable: false,
      );

    addCommand(ActivateCommand(project));
    addCommand(PlatformCommand(project, platform: Platform.android));
    addCommand(BeginCommand(project));
    addCommand(CreateCommand());
    addCommand(DeactivateCommand(project));
    addCommand(DomainCommand(project));
    addCommand(EndCommand(project));
    addCommand(InfrastructureCommand(project));
    addCommand(PlatformCommand(project, platform: Platform.ios));
    addCommand(PlatformCommand(project, platform: Platform.linux));
    addCommand(PlatformCommand(project, platform: Platform.macos));
    addCommand(PlatformCommand(project, platform: Platform.mobile));
    addCommand(PubCommand(project));
    addCommand(UiCommand(project));
    addCommand(PlatformCommand(project, platform: Platform.web));
    addCommand(PlatformCommand(project, platform: Platform.windows));
  }

  @override
  String get invocation => 'rapid <command>';
}

/// The entry point to start Rapid command-line interface (CLI).
FutureOr<void> rapidEntryPoint(
  List<String> arguments,
  LaunchContext context, {
  RapidLogger? logger,
  RapidCommandRunner Function({RapidProject? project})? commandRunnerBuilder,
  PubUpdater? pubUpdater,
}) async {
  logger ??= RapidLogger();

  if (arguments.contains('--version') || arguments.contains('-v')) {
    logger.info(packageVersion);

    return _checkForUpdates(context, logger: logger, pubUpdater: pubUpdater);
  }
  try {
    if (!arguments.willShowHelp) {
      final dart = await runCommand(['dart', '--version']);
      if (dart.exitCode != 0) {
        logger.err('Dart not installed.');
        exitCode = 1;
        return;
      }

      final flutter = await runCommand(['flutter', '--version']);
      if (flutter.exitCode != 0) {
        logger.err('Flutter not installed.');
        exitCode = 1;
        return;
      }

      if (!arguments.willRunCreate) {
        final melos = await runCommand(['melos', '--version']);
        if (melos.exitCode != 0) {
          logger.err('Melos not installed.');
          exitCode = 1;
          return;
        }
      }
    }
    final project = await resolveProject(
      arguments,
      context.localInstallation?.packageRoot,
    );

    final commandRunner =
        (commandRunnerBuilder ?? RapidCommandRunner.new)(project: project);
    await commandRunner.run(arguments);
  } on RapidException catch (err) {
    logger.err(err.toString());
    exitCode = 1;
  } on UsageException catch (err) {
    logger.err(err.toString());
    exitCode = 1;
  } catch (err) {
    rethrow;
  }
}

Future<void> _checkForUpdates(
  LaunchContext context, {
  required RapidLogger logger,
  PubUpdater? pubUpdater,
}) async {
  // TODO(jtdLab): get this covered
  pubUpdater ??= PubUpdater(); // coverage:ignore-line

  final isUpToDate = await pubUpdater.isUpToDate(
    packageName: packageName,
    currentVersion: packageVersion,
  );
  if (!isUpToDate) {
    final latestVersion = await pubUpdater.getLatestVersion(packageName);
    final isGlobal = context.localInstallation == null;

    if (isGlobal) {
      final shouldUpdate = logger.prompt(
            'There is a new version of $packageName available '
            '($latestVersion). Would you like to update?',
            defaultValue: false,
          ) ==
          'true';
      if (shouldUpdate) {
        await pubUpdater.update(packageName: packageName);
        logger.info(
          '$packageName has been updated to version $latestVersion.',
        );
      }
    } else {
      logger.info(
        'There is a new version of $packageName available '
        '($latestVersion).',
      );
    }
  }
}

/// Visible for e2e tests
@visibleForTesting
Future<RapidProject?> resolveProject(
  List<String> arguments,
  Directory? projectRoot,
) async {
  final RapidProjectConfig config;
  if (projectRoot == null) {
    if (arguments.willShowHelp || arguments.willRunCreate) {
      return null;
    } else {
      config = await RapidProjectConfig.handleProjectNotFound(
        Directory.current,
      );
    }
  } else {
    config = await RapidProjectConfig.fromProjectRoot(projectRoot);
  }

  return RapidProject.fromConfig(config);
}

extension on List<String> {
  bool get willShowHelp => isEmpty || contains('--help') || contains('-h');

  bool get willRunCreate => isNotEmpty && first == 'create';
}
