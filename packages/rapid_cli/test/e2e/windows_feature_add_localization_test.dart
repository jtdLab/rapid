@Tags(['e2e'])
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_localization.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'windows <feature> add localization',
        performTest(
          platform: Platform.windows,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
