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

        await setupProject(Platform.mobile);
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('mobile <feature> add bloc', () {
        test(
          '(fast)',
          () => performTest(
            platform: Platform.mobile,
            expectedCoverage: 80.0,
            type: TestType.fast,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with output dir (fast)',
          () => performTest(
            platform: Platform.mobile,
            outputDir: 'foo',
            expectedCoverage: 80.0,
            type: TestType.fast,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            platform: Platform.mobile,
            expectedCoverage: 80.0,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );

        test(
          'with output dir',
          () => performTest(
            platform: Platform.mobile,
            outputDir: 'foo',
            expectedCoverage: 80.0,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );
      });
    },
  );
}