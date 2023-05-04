import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:rapid_cli/src/commands/activate/activate.dart';
import 'package:rapid_cli/src/commands/android/android.dart';
import 'package:rapid_cli/src/commands/begin/begin.dart';
import 'package:rapid_cli/src/commands/deactivate/deactivate.dart';
import 'package:rapid_cli/src/commands/domain/domain.dart';
import 'package:rapid_cli/src/commands/end/end.dart';
import 'package:rapid_cli/src/commands/infrastructure/infrastructure.dart';
import 'package:rapid_cli/src/commands/ios/ios.dart';
import 'package:rapid_cli/src/commands/linux/linux.dart';
import 'package:rapid_cli/src/commands/macos/macos.dart';
import 'package:rapid_cli/src/commands/pub/pub.dart';
import 'package:rapid_cli/src/commands/ui/ui.dart';
import 'package:rapid_cli/src/commands/web/web.dart';
import 'package:rapid_cli/src/commands/windows/windows.dart';
import 'package:rapid_cli/src/project/project.dart';

import 'commands/create/create.dart';
import 'version.dart';

/// {@template rapid_command_runner}
/// A [CommandRunner] for the Rapid Command Line Interface.
/// {@endtemplate}
class RapidCommandRunner extends CommandRunner<int> {
  RapidCommandRunner({
    Logger? logger,
    Project? project,
  })  : _logger = logger ?? Logger(),
        super(
          'rapid',
          'A CLI tool for developing Flutter apps based on Rapid Architecture.',
        ) {
    argParser
      ..addFlag(
        'version',
        abbr: 'v',
        help: 'Print the current version.',
        negatable: false,
      )
      ..addFlag(
        'verbose',
        help: 'Enable verbose logging.',
        negatable: false,
      );
    addCommand(ActivateCommand(logger: _logger, project: project));
    addCommand(AndroidCommand(logger: _logger, project: project));
    addCommand(BeginCommand(logger: _logger, project: project));
    addCommand(CreateCommand(logger: _logger));
    addCommand(DeactivateCommand(logger: _logger, project: project));
    // addCommand(DoctorCommand(logger: _logger, project: project)); // TODO use later
    addCommand(DomainCommand(logger: _logger, project: project));
    addCommand(EndCommand(logger: _logger, project: project));
    addCommand(InfrastructureCommand(logger: _logger, project: project));
    addCommand(IosCommand(logger: _logger, project: project));
    addCommand(LinuxCommand(logger: _logger, project: project));
    addCommand(MacosCommand(logger: _logger, project: project));
    addCommand(PubCommand(logger: _logger));
    addCommand(UiCommand(logger: _logger, project: project));
    addCommand(WebCommand(logger: _logger, project: project));
    addCommand(WindowsCommand(logger: _logger, project: project));
  }

  @override
  String get invocation => 'rapid <command>';

  final Logger _logger;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);
      if (argResults['verbose'] == true) {
        _logger.level = Level.verbose;
      }

      return await runCommand(argResults) ?? ExitCode.success.code;
    } on FormatException catch (e, stackTrace) {
      // TODO is catching FormatException needed ?
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
      return ExitCode.usage.code;
    } on RapidException catch (e) {
      _logger.err(e.message);

      return ExitCode.usage.code;
    } on UsageException catch (e) {
      _logger
        ..err(e.message)
        ..info('')
        ..info(e.usage);
      return ExitCode.usage.code;
    }
  }

  @override
  Future<int?> runCommand(ArgResults topLevelResults) async {
    _logger
      ..detail('Argument information:')
      ..detail('  Top level options:');
    for (final option in topLevelResults.options) {
      if (topLevelResults.wasParsed(option)) {
        _logger.detail('  - $option: ${topLevelResults[option]}');
      }
    }
    if (topLevelResults.command != null) {
      final commandResult = topLevelResults.command!;
      _logger
        ..detail('  Command: ${commandResult.name}')
        ..detail('    Command options:');
      for (final option in commandResult.options) {
        if (commandResult.wasParsed(option)) {
          _logger.detail('    - $option: ${commandResult[option]}');
        }
      }

      if (commandResult.command != null) {
        final subCommandResult = commandResult.command!;
        _logger.detail('    Command sub command: ${subCommandResult.name}');
      }
    }

    int? exitCode = ExitCode.unavailable.code;
    if (topLevelResults['version']) {
      _logger.info(packageVersion);
      // TODO add when pub.dev release
      // await _checkForUpdates();

      return ExitCode.success.code;
    }
    exitCode = await super.runCommand(topLevelResults);

    return exitCode;
  }

  // TODO add when pub.dev release
  /* Future<void> _checkForUpdates({
    required Logger logger,
  }) async {
    final pubUpdater = PubUpdater();
    const packageName = 'rapid_cli';
    final isUpToDate = await pubUpdater.isUpToDate(
      packageName: packageName,
      currentVersion: packageVersion,
    );
    if (!isUpToDate) {
      final latestVersion = await pubUpdater.getLatestVersion(packageName);

      final shouldUpdate = logger.prompt(
            'There is a new version of $packageName available '
            '($latestVersion). Would you like to update?',
            defaultValue: true,
          ) ==
          'true';
      if (shouldUpdate) {
        await pubUpdater.update(packageName: packageName);
        logger.success(
          '$packageName has been updated to version $latestVersion.',
        );
      }
    }
  } */
}
