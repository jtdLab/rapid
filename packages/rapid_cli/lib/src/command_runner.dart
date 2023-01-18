import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:rapid_cli/src/commands/activate/activate.dart';
import 'package:rapid_cli/src/commands/android/android.dart';
import 'package:rapid_cli/src/commands/deactivate/deactivate.dart';
import 'package:rapid_cli/src/commands/doctor/doctor.dart';
import 'package:rapid_cli/src/commands/domain/domain.dart';
import 'package:rapid_cli/src/commands/infrastructure/infrastructure.dart';
import 'package:rapid_cli/src/commands/ios/ios.dart';
import 'package:rapid_cli/src/commands/linux/linux.dart';
import 'package:rapid_cli/src/commands/macos/macos.dart';
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
        super('rapid', 'Rapid Command Line Interface') {
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
    final p = project ?? Project();
    addCommand(ActivateCommand(logger: logger, project: p));
    addCommand(AndroidCommand(logger: logger, project: p));
    addCommand(CreateCommand(logger: logger));
    addCommand(DeactivateCommand(logger: logger, project: p));
    addCommand(DoctorCommand(logger: logger, project: p));
    addCommand(DomainCommand(logger: logger, project: p));
    addCommand(InfrastructureCommand(logger: logger, project: p));
    addCommand(IosCommand(logger: logger, project: p));
    addCommand(LinuxCommand(logger: logger, project: p));
    addCommand(MacosCommand(logger: logger, project: p));
    addCommand(UiCommand(logger: logger, project: p));
    addCommand(WebCommand(logger: logger, project: p));
    addCommand(WindowsCommand(logger: logger, project: p));
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
      _logger
        ..err(e.message)
        ..err('$stackTrace')
        ..info('')
        ..info(usage);
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
      return ExitCode.success.code;
    }
    exitCode = await super.runCommand(topLevelResults);

    return exitCode;
  }
}
