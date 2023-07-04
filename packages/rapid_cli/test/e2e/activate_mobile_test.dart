@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'activate_platform.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'activate mobile',
        performTest(
          platform: Platform.mobile,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'activate mobile (with language)',
        performTest(
          platform: Platform.mobile,
          language: 'zh_Hant_HK',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
