@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_cubit.dart';

void main() {
  group(
    'E2E',
    () {
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
