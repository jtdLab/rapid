@Tags(['e2e'])
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'ui_platform_add_widget.dart';

void main() {
  group('E2E', () {
    test(
      'ui android add widget',
      () => performTest(
        platform: Platform.android,
      ),
      timeout: const Timeout(Duration(minutes: 4)),
    );
  });
}
