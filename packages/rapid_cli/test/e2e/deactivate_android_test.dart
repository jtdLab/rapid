@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'deactivate_platform.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'deactivate android',
        performTest(
          platform: Platform.android,
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
