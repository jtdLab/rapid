@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'deactivate_platform.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'deactivate linux',
        performTest(
          platform: Platform.linux,
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
