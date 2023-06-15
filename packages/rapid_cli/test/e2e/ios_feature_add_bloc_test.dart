@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_bloc.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'ios <feature> add bloc',
        () => performTest(
          platform: Platform.ios,
          expectedCoverage: 75.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'ios <feature> add bloc (with output dir)',
        () => performTest(
          platform: Platform.ios,
          outputDir: 'foo',
          expectedCoverage: 75.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
