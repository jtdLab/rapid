@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_navigator.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'linux add navigator',
        () => performTest(
          platform: Platform.linux,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
