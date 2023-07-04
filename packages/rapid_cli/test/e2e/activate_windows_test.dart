@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'activate_platform.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'activate windows',
        performTest(
          platform: Platform.windows,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'activate windows (with language)',
        performTest(
          platform: Platform.windows,
          language: 'zh_Hant_HK',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
