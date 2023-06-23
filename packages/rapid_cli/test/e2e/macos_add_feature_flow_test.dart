@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_flow.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'macos add feature flow',
        performTest(
          platform: Platform.macos,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'macos add feature flow --no-localization',
        performTest(
          platform: Platform.macos,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'macos add feature flow --tab',
        performTest(
          platform: Platform.macos,
          tab: true,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'macos add feature flow --tab --no-localization',
        performTest(
          platform: Platform.macos,
          tab: true,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
