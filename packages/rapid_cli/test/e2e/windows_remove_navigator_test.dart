@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'platform_remove_navigator.dart';

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

      group(
        'windows remove navigator',
        () {
          test(
            '(fast)',
            () => performTest(
              platform: Platform.windows,
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            '',
            () => performTest(
              platform: Platform.windows,
            ),
            timeout: const Timeout(Duration(minutes: 8)),
          );
        },
      );
    },
  );
}
