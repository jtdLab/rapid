@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_remove_feature.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'web remove feature',
        performTest(
          platform: Platform.web,
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
