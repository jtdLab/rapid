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

        await setupProject(Platform.linux);
        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('linux <feature> add cubit', () {
        test(
          '(fast)',
          () => performTest(
            platform: Platform.linux,
            expectedCoverage: 84.62,
            type: TestType.fast,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            platform: Platform.linux,
            expectedCoverage: 84.62,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
