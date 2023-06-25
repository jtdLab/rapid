@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'platform_feature_add_localization.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'macos <feature> add localization',
        performTest(
          platform: Platform.macos,
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
