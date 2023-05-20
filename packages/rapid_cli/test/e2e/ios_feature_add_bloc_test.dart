@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'platform_feature_add_bloc.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject(Platform.ios);
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('ios <feature> add bloc', () {
        test(
          '(fast)',
          () => performTest(
            platform: Platform.ios,
            type: TestType.fast,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with output dir (fast)',
          () => performTest(
            platform: Platform.ios,
            outputDir: 'foo',
            type: TestType.fast,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            platform: Platform.ios,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );

        test(
          'with output dir',
          () => performTest(
            platform: Platform.ios,
            outputDir: 'foo',
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );
      });
    },
  );
}
