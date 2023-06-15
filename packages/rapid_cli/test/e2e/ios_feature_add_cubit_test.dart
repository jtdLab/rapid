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

        await setupProject(Platform.ios);
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'ios <feature> add cubit',
        () => performTest(
          platform: Platform.ios,
          expectedCoverage: 80.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'ios <feature> add cubit (with output dir)',
        () => performTest(
          platform: Platform.ios,
          outputDir: 'foo',
          expectedCoverage: 80.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
