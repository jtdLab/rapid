@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'deactivate_platform.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'deactivate windows',
        performTest(
          platform: Platform.windows,
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
