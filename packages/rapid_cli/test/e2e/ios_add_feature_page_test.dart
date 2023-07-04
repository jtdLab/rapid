@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_page.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'ios add feature page',
        performTest(
          platform: Platform.ios,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'ios add feature page --no-localization',
        performTest(
          platform: Platform.ios,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
