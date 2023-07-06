import 'package:cli_launcher/cli_launcher.dart';
import 'package:rapid_cli/src/command_runner.dart';

Future<void> main(List<String> arguments) async => launchExecutable(
      arguments,
      LaunchConfig(
        name: ExecutableName('rapid', package: 'rapid_cli'),
        launchFromSelf: false,
        entrypoint: rapidEntryPoint,
      ),
    );

/* 
import 'dart:async';

import 'package:rapid_cli/src/logging.dart';
import 'package:rapid_cli/src/utils.dart';

Future<void> main() async {
  final logger = RapidLogger();
  await logger.task('Task 1');
  await logger.task('Task 2', fail: true);
  logger.newLine();
  await logger.taskGroup('Task Group');
  logger.newLine();
  await logger.parallelTaskGroup('Parallel Task Group');

  logger.newLine();
  logger.commandSuccess('Published App!');
}

extension on RapidLogger {
  Future<void> task(
    String description, {
    bool fail = false,
    int delay = 2,
  }) async {
    final progress = this.progress(description);
    await Future.delayed(Duration(seconds: delay));
    if (fail) {
      progress.fail();
    } else {
      progress.complete();
    }
  }

  Future<void> taskGroup(String description) async {
    log('$construction ${taskGroupTitleStyle(description)}');
    await task('Task 1');
    await task('Task 2', fail: true);
  }

  Future<void> parallelTaskGroup(String description) async {
    final group =
        progressGroup('$construction ${taskGroupTitleStyle(description)}');
    await Stream.fromIterable(
      [
        parallelTask('Task 1', group: group),
        parallelTask('Task 2', group: group, fail: true, delay: 4),
        parallelTask('Task 3', group: group, fail: true, delay: 10),
        parallelTask('Task 4', group: group, delay: 6),
      ],
    ).parallel((t) async {
      final result = await t;
      return result;
    }).drain<void>();
  }

  Future<void> parallelTask(
    String description, {
    required ProgressGroup group,
    bool fail = false,
    int delay = 2,
  }) async {
    final progress = group.progress(description);
    await Future.delayed(Duration(seconds: delay));
    if (fail) {
      progress.fail();
    } else {
      progress.complete();
    }
  }
}
 */
