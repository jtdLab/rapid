@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_remove_language.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'android remove language',
        performTest(
          platform: Platform.android,
        ),
        timeout: const Timeout(Duration(minutes: 6)),
      );
    },
  );
}
