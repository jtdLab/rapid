@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'activate_platform.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'activate web',
        performTest(
          platform: Platform.web,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'activate web (with language)',
        performTest(
          platform: Platform.web,
          language: 'zh_Hant_HK',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
