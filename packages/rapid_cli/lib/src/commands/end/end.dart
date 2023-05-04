import 'dart:async';
import 'dart:io';

import 'package:mason/mason.dart';
import 'package:path/path.dart' as p;
import 'package:rapid_cli/src/cli/cli.dart';
import 'package:rapid_cli/src/commands/core/command.dart';
import 'package:rapid_cli/src/commands/core/run_when.dart';
import 'package:rapid_cli/src/project/project.dart';

// TODO impl cleaner + e2e test

/// {@template end_command}
/// `rapid end` command ends a group of Rapid command executions.
class EndCommand extends RapidRootCommand {
  /// {@macro end_command}
  EndCommand({
    Logger? logger,
    Project? project,
    MelosBootstrapCommand? melosBootstrap,
    FlutterPubGetCommand? flutterPubGet,
    FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand?
        flutterPubRunBuildRunnerBuildDeleteConflictingOutputs,
  })  : _logger = logger ?? Logger(),
        _project = project ?? Project(),
        _melosBootstrap = melosBootstrap ?? Melos.bootstrap,
        _flutterPubGet = flutterPubGet ?? Flutter.pubGet,
        _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs =
            flutterPubRunBuildRunnerBuildDeleteConflictingOutputs ??
                Flutter.pubRunBuildRunnerBuildDeleteConflictingOutputs;

  final Logger _logger;
  final Project _project;
  final MelosBootstrapCommand _melosBootstrap;
  final FlutterPubGetCommand _flutterPubGet;
  final FlutterPubRunBuildRunnerBuildDeleteConflictingOutputsCommand
      _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs;

  @override
  String get name => 'end';

  @override
  String get invocation => 'rapid end';

  @override
  String get description => 'Ends a group of Rapid command executions.';

  @override
  Future<int> run() => runWhen(
        [projectExistsAll(_project)],
        _logger,
        () async {
          final dotRapidTool = '.rapid_tool';

          final rapidGroupActive = File(
            p.join(dotRapidTool, 'group-active'),
          );

          final rapidNeedBootstrap = File(
            p.join(dotRapidTool, 'need-bootstrap'),
          );

          final rapidNeedCodeGen = File(
            p.join(dotRapidTool, 'need-code-gen'),
          );

          if (!rapidGroupActive.existsSync() ||
              !rapidNeedBootstrap.existsSync() ||
              !rapidNeedCodeGen.existsSync()) {
            _logger
              ..info('')
              ..err(
                'There is no active group. '
                'Did you call "rapid begin" before?',
              );

            return ExitCode.config.code;
          }

          final groupActive = rapidGroupActive.readAsStringSync() == 'true';
          if (!groupActive) {
            _logger
              ..info('')
              ..err(
                'There is no active group. '
                'Did you call "rapid begin" before?',
              );

            return ExitCode.config.code;
          }

          final packagesToBootstrap =
              rapidNeedBootstrap.readAsStringSync().split(',').toSet().toList();
          await _melosBootstrap(
            cwd: '.',
            logger: _logger,
            scope: packagesToBootstrap,
          );

          final packagesToCodeGen =
              rapidNeedCodeGen.readAsStringSync().split(',').toSet().toList();
          for (final packageToCodeGen in packagesToCodeGen) {
            await _flutterPubGet(cwd: packageToCodeGen, logger: _logger);
            await _flutterPubRunBuildRunnerBuildDeleteConflictingOutputs(
              cwd: packageToCodeGen,
              logger: _logger,
            );
          }

          rapidGroupActive.writeAsStringSync('false');
          rapidNeedBootstrap.writeAsStringSync('');
          rapidNeedCodeGen.writeAsStringSync('');

          _logger
            ..info('')
            ..success('Ended group!');

          return ExitCode.success.code;
        },
      );
}
