import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_remove_language.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'web remove language',
        () => performTest(
          platform: Platform.web,
        ),
        timeout: const Timeout(Duration(minutes: 6)),
      );
    },
  );
}
