@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_cubit.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'mobile <feature> add cubit',
        performTest(
          platform: Platform.mobile,
          expectedCoverage: 77.78,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'mobile <feature> add cubit (with output dir)',
        performTest(
          platform: Platform.mobile,
          outputDir: 'foo',
          expectedCoverage: 77.78,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
