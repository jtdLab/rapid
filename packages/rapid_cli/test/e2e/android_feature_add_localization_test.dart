@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_localization.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'android <feature> add localization',
        performTest(
          platform: Platform.android,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
