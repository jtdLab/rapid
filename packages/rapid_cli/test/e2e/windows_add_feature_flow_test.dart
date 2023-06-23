@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_flow.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'windows add feature flow',
        performTest(
          platform: Platform.windows,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'windows add feature flow --no-localization',
        performTest(
          platform: Platform.windows,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'windows add feature flow --tab',
        performTest(
          platform: Platform.windows,
          tab: true,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'windows add feature flow --tab --no-localization',
        performTest(
          platform: Platform.windows,
          tab: true,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
