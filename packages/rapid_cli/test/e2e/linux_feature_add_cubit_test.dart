@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'platform_feature_add_cubit.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject(Platform.linux);
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('linux <feature> add cubit', () {
        test(
          '(fast)',
          () => performTest(
            platform: Platform.linux,
            expectedCoverage: 80.0,
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            platform: Platform.linux,
            expectedCoverage: 80.0,
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );
      });
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
