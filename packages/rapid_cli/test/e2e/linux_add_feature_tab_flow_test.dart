@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_tab_flow.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'linux add feature tab_flow',
        performTest(
          platform: Platform.linux,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
