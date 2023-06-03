@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'activate_platform.dart';
import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() {
        Directory.current = getTempDir();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('activate android', () {
        test(
          '(fast)',
          () => performTest(
            platform: Platform.android,
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            platform: Platform.android,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );

        test(
          '(slow)',
          () => performTest(
            platform: Platform.android,
            type: TestType.slow,
          ),
          timeout: const Timeout(Duration(minutes: 24)),
          tags: ['android'],
        );
      });
    },
  );
}
