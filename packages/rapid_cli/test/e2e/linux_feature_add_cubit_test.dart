@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_cubit.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'linux <feature> add cubit',
        performTest(
          platform: Platform.linux,
          expectedCoverage: 81.82,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'linux <feature> add cubit (with output dir)',
        performTest(
          platform: Platform.linux,
          outputDir: 'foo',
          expectedCoverage: 81.82,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
