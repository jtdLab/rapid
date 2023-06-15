@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_bloc.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'mobile <feature> add bloc',
        () => performTest(
          platform: Platform.mobile,
          expectedCoverage: 75.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'mobile <feature> add bloc (with output dir)',
        () => performTest(
          platform: Platform.mobile,
          outputDir: 'foo',
          expectedCoverage: 75.0,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
