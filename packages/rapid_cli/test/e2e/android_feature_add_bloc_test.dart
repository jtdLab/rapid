@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'platform_feature_add_bloc.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject(Platform.android);
      });

      tearDown(() {
        Directory.current = cwd;
      });

      test(
        'android <feature> add bloc',
        () => performTest(
          platform: Platform.android,
          expectedCoverage: 75.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'android <feature> add bloc (with output dir)',
        () => performTest(
          platform: Platform.android,
          outputDir: 'foo',
          expectedCoverage: 75.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
