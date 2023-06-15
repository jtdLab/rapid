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

        await setupProject(Platform.mobile);
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'mobile <feature> add cubit',
        () => performTest(
          platform: Platform.mobile,
          expectedCoverage: 80.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'mobile <feature> add cubit (with output dir)',
        () => performTest(
          platform: Platform.mobile,
          outputDir: 'foo',
          expectedCoverage: 80.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
