@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/command_runner.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'activate_platform.dart';
import 'common.dart';

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

      group('activate web', () {
        test(
          '(fast)',
          () => performTest(
            platform: Platform.web,
            type: TestType.fast,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            platform: Platform.web,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );

        test(
          '(slow)',
          () => performTest(
            platform: Platform.web,
            type: TestType.slow,
            commandRunner: commandRunner,
          ),
          timeout: const Timeout(Duration(minutes: 24)),
          tags: ['web'],
        );
      });
    },
  );
}
