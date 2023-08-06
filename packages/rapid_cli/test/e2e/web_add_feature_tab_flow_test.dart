@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_tab_flow.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'web add feature tab_flow',
        performTest(
          platform: Platform.web,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
