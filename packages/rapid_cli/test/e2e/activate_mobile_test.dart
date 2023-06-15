@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'activate_platform.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'activate mobile',
        () => performTest(
          platform: Platform.mobile,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
