@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'platform_add_feature.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      late RapidCommandRunner commandRunner;

      setUp(() {
        Directory.current = getTempDir();

        commandRunner = RapidCommandRunner();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group(
        'macos add feature',
        () {
          test(
            '(fast)',
            () => performTest(
              platform: Platform.macos,
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
              commandRunner: commandRunner,
            ),
            timeout: const Timeout(Duration(minutes: 8)),
          );
        },
      );
    },
  );
}
