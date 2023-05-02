import 'dart:async';
import 'dart:io';

import 'package:args/command_runner.dart';
import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;

// TODO impl cleaner + e2e test

/// {@template begin_command}
/// `rapid begin` command starts a group of Rapid command executions.
class BeginCommand extends Command<int> {
  /// {@macro begin_command}
  BeginCommand({
    Logger? logger,
  }) : _logger = logger ?? Logger();

  final Logger _logger;

  @override
  String get name => 'begin';

  @override
  String get invocation => 'rapid begin';

  @override
  String get description => 'Starts a group of Rapid command executions.';

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

    if (!rapidGroupActive.existsSync()) {
      rapidGroupActive.createSync(recursive: true);
    }

    if (!rapidNeedBootstrap.existsSync()) {
      rapidNeedBootstrap.createSync(recursive: true);
    }

    if (!rapidNeedCodeGen.existsSync()) {
      rapidNeedCodeGen.createSync(recursive: true);
    }

    print(rapidGroupActive.path);

    final groupActive = rapidGroupActive.readAsStringSync() == 'true';
    if (groupActive) {
      _logger
        ..info('')
        ..err(
          'There is already an active group.'
          'Call "rapid end" to complete it.',
        );
    }

    rapidGroupActive.writeAsStringSync('true');

    _logger
      ..info('')
      ..success('Began group!');

    return ExitCode.success.code;
  }
}
