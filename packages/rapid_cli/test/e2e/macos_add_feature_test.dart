@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'macos add feature',
        () => performTest(
          platform: Platform.macos,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
