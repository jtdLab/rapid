@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_remove_language.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'macos remove language',
        performTest(
          platform: Platform.macos,
        ),
        timeout: const Timeout(Duration(minutes: 6)),
      );
    },
  );
}
