@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_flow.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'mobile add feature flow',
        performTest(
          platform: Platform.mobile,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
