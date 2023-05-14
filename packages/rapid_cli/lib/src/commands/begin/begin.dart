import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/logger_x.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';

// TODO impl cleaner + e2e test

/// {@template begin_command}
/// `rapid begin` command starts a group of Rapid command executions.
class BeginCommand extends RapidRootCommand {
  /// {@macro begin_command}
  BeginCommand({
    super.logger,
    super.project,
  });

  @override
  String get name => 'begin';

  @override
  String get invocation => 'rapid begin';

  @override
  String get description => 'Starts a group of Rapid command executions.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(project)],
        logger,
        () async {
          final dotRapidTool = p.join('.rapid_tool');

          final rapidGroupActive = File(
            p.join(dotRapidTool, 'group-active'),
          );

          final rapidNeedBootstrap = File(
            p.join(dotRapidTool, 'need-bootstrap'),
          );

          final rapidNeedCodeGen = File(
            p.join(dotRapidTool, 'need-code-gen'),
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

          final groupActive = rapidGroupActive.readAsStringSync() == 'true';
          if (groupActive) {
            logger.commandError(
              'There is already an active group. '
              'Call "rapid end" to complete it.',
            );

            return ExitCode.config.code;
          }

          rapidGroupActive.writeAsStringSync('true');

          logger.commandTitle('Beginning Command Group ...');

          return ExitCode.success.code;
        },
      );
}
