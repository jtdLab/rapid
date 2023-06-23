@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_page.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'linux add feature page',
        performTest(
          platform: Platform.linux,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'linux add feature page --no-localization',
        performTest(
          platform: Platform.linux,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
