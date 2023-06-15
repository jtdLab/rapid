@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_add_language.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'windows add language',
        () => performTest(
          platform: Platform.windows,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
