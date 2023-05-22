@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'platform_feature_add_cubit.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject(Platform.macos);
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('macos <feature> add cubit', () {
        test(
          '(fast)',
          () => performTest(
            platform: Platform.macos,
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
            platform: Platform.macos,
            expectedCoverage: 80.0,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
