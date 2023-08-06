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
        'web <feature> add cubit',
        performTest(
          platform: Platform.web,
          expectedCoverage: 77.78,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

/*       test(
        'web <feature> add cubit (with output dir)',
        performTest(
          platform: Platform.web,
          outputDir: 'foo',
          expectedCoverage: 77.78,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      ); */
    },
  );
}
