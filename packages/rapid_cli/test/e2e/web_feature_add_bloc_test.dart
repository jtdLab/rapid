@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_bloc.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'web <feature> add bloc',
        performTest(
          platform: Platform.web,
          expectedCoverage: 80,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

/*       test(
        'web <feature> add bloc (with output dir)',
        performTest(
          platform: Platform.web,
          outputDir: 'foo',
          expectedCoverage: 72.73,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      ); */
    },
  );
}
