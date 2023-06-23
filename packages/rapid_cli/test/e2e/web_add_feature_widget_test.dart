@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_widget.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'web add feature widget',
        performTest(
          platform: Platform.web,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'web add feature widget --no-localization',
        performTest(
          platform: Platform.web,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
