@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_bloc.dart';

// TODO output-dir

void main() {
  group(
    'E2E',
    () {
      test(
        'ios <feature> add bloc',
        performTest(
          platform: Platform.ios,
          expectedCoverage: 72.73,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

/*       test(
        'ios <feature> add bloc (with output dir)',
        performTest(
          platform: Platform.ios,
          outputDir: 'foo',
          expectedCoverage: 72.73,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      ); */
    },
  );
}
