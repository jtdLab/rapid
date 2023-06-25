@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_bloc.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'macos <feature> add bloc',
        performTest(
          platform: Platform.macos,
          expectedCoverage: 81.25,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'macos <feature> add bloc (with output dir)',
        performTest(
          platform: Platform.macos,
          outputDir: 'foo',
          expectedCoverage: 81.25,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
