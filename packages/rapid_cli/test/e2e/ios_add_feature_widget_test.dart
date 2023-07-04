@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_widget.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'ios add feature widget',
        performTest(
          platform: Platform.ios,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'ios add feature widget --no-localization',
        performTest(
          platform: Platform.ios,
          localization: false,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
