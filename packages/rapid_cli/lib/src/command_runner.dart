import 'package:args/args.dart';
import 'package:args/command_runner.dart';
import 'package:mason/mason.dart' hide packageVersion;
import 'package:rapid_cli/src/commands/activate/activate.dart';
import 'package:rapid_cli/src/commands/deactivate/deactivate.dart';
import 'package:rapid_cli/src/core/project.dart';

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
        _project = project ?? Project(),
        super('rapid', 'Rapid Command Line Interface') {
    argParser.addFlag(
      'version',
      abbr: 'v',
      help: 'Print the current version.',
      negatable: false,
    );
    addCommand(CreateCommand(logger: logger));
    addCommand(ActivateCommand(logger: logger, project: _project));
    addCommand(DeactivateCommand(logger: logger, project: _project));
  }

  final Logger _logger;
  final Project _project;

  @override
  Future<int> run(Iterable<String> args) async {
    try {
      final argResults = parse(args);
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
    int? exitCode = ExitCode.unavailable.code;
    if (topLevelResults['version']) {
      _logger.info(packageVersion);
      exitCode = ExitCode.success.code;
    }
    exitCode = await super.runCommand(topLevelResults);

    return exitCode;
  }
}
