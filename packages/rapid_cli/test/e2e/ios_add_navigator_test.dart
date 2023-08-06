@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_add_navigator.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'ios add navigator',
        performTest(
          platform: Platform.ios,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
