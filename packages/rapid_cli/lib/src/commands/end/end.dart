import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

// TODO impl cleaner + e2e test

/// {@template end_command}
/// `rapid end` command ends a group of Rapid command executions.
class EndCommand extends Command<int> {
  /// {@macro end_command}
  EndCommand({
    Logger? logger,
  }) : _logger = logger ?? Logger();

  final Logger _logger;

  @override
  String get name => 'end';

  @override
  String get invocation => 'rapid end';

  @override
  String get description => 'Ends a group of Rapid command executions.';

  @override
  Future<int> run() async {
    // TODO consider placing into root of the workspace
    final userHomeDir =
        Platform.environment['HOME'] ?? Platform.environment['USERPROFILE']!;

    final rapidGroupActive = File(
      p.join(userHomeDir, '.rapid', 'group-active'),
    );

    final rapidNeedBootstrap = File(
      p.join(userHomeDir, '.rapid', 'need-bootstrap'),
    );

    final rapidNeedCodeGen = File(
      p.join(userHomeDir, '.rapid', 'need-code-gen'),
    );

    if (!rapidGroupActive.existsSync() ||
        !rapidNeedBootstrap.existsSync() ||
        !rapidNeedCodeGen.existsSync()) {
      _logger
        ..info('')
        ..err(
          'There is no active group.'
          'Did you call "rapid begin" before?',
        );
    }

    final groupActive = rapidGroupActive.readAsStringSync() == 'true';
    if (!groupActive) {
      _logger
        ..info('')
        ..err(
          'There is no active group.'
          'Did you call "rapid begin" before?',
        );
    }

    rapidGroupActive.writeAsStringSync('false');
    rapidNeedBootstrap.writeAsStringSync('');
    rapidNeedCodeGen.writeAsStringSync('');

    _logger
      ..info('')
      ..success('Ended group!');

    return ExitCode.success.code;
  }
}
