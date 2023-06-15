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

        await setupProject(Platform.macos);
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'macos <feature> add cubit',
        () => performTest(
          platform: Platform.macos,
          expectedCoverage: 84.62,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'macos <feature> add cubit (with output dir)',
        () => performTest(
          platform: Platform.macos,
          outputDir: 'foo',
          expectedCoverage: 84.62,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
