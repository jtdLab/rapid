@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_cubit.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'ios <feature> add cubit',
        performTest(
          platform: Platform.ios,
          expectedCoverage: 77.78,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

/*       test(
        'ios <feature> add cubit (with output dir)',
        performTest(
          platform: Platform.ios,
          outputDir: 'foo',
          expectedCoverage: 77.78,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      ); */
    },
  );
}
