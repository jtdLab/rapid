@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_remove_navigator.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'mobile remove navigator',
        performTest(
          platform: Platform.mobile,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
