@Tags(['e2e'])
library;

import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import 'ui_platform_add_widget.dart';

void main() {
  group('E2E', () {
    test(
      'ui linux add widget',
      performTest(
        platform: Platform.linux,
      ),
      timeout: const Timeout(Duration(minutes: 4)),
    );
  });
}
