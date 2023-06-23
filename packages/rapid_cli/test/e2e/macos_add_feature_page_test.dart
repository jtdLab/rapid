@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_page.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'macos add feature page',
        performTest(
          platform: Platform.macos,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'macos add feature page --no-localization',
        performTest(
          platform: Platform.macos,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
