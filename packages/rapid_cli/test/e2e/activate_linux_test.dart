import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'activate_platform.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'activate linux',
        () => performTest(
          platform: Platform.linux,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
