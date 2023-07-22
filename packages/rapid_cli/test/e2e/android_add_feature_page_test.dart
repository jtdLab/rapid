@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_page.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'android add feature page',
        performTest(
          platform: Platform.android,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
