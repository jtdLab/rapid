@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature_widget.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'android add feature widget',
        performTest(
          platform: Platform.android,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
