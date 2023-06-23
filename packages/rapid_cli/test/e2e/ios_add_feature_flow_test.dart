@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_flow.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'ios add feature flow',
        performTest(
          platform: Platform.ios,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'ios add feature flow --no-localization',
        performTest(
          platform: Platform.ios,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'ios add feature flow --tab',
        performTest(
          platform: Platform.ios,
          tab: true,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'ios add feature flow --tab --no-localization',
        performTest(
          platform: Platform.ios,
          tab: true,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
