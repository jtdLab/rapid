@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_flow.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'android add feature flow',
        performTest(
          platform: Platform.android,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'android add feature flow --no-localization',
        performTest(
          platform: Platform.android,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'android add feature flow --tab',
        performTest(
          platform: Platform.android,
          tab: true,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'android add feature flow --tab --no-localization',
        performTest(
          platform: Platform.android,
          tab: true,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
