import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'ui_platform_remove_widget.dart';

void main() {
  group(
    'E2E',
    () {
      test(
        'ui web remove widget',
        () => performTest(
          platform: Platform.web,
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
