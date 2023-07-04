@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_flow.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'web add feature flow',
        performTest(
          platform: Platform.web,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'web add feature flow --no-localization',
        performTest(
          platform: Platform.web,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'web add feature flow --tab',
        performTest(
          platform: Platform.web,
          tab: true,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'web add feature flow --tab --no-localization',
        performTest(
          platform: Platform.web,
          tab: true,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
