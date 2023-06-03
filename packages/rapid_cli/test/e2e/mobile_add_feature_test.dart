@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'platform_add_feature.dart';

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
        'mobile add feature',
        () {
          test(
            '(fast)',
            () => performTest(
              platform: Platform.mobile,
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            '',
            () => performTest(
              platform: Platform.mobile,
            ),
            timeout: const Timeout(Duration(minutes: 8)),
          );
        },
      );
    },
  );
}
