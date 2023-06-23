@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_page.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'web add feature page',
        performTest(
          platform: Platform.web,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'web add feature page --no-localization',
        performTest(
          platform: Platform.web,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
