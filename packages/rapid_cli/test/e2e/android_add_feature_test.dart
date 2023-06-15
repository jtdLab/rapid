import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_feature.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'android add feature',
        () => performTest(
          platform: Platform.android,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
