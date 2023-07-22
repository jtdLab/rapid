@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_remove_navigator.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'ios remove navigator',
        performTest(
          platform: Platform.ios,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
