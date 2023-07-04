@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_bloc.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'linux <feature> add bloc',
        performTest(
          platform: Platform.linux,
          expectedCoverage: 76.92,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'linux <feature> add bloc (with output dir)',
        performTest(
          platform: Platform.linux,
          outputDir: 'foo',
          expectedCoverage: 76.92,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
