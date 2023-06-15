@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'ui_platform_remove_widget.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() {
        Directory.current = getTempDir();
      });

      tearDown(() {
        Directory.current = cwd;
      });

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
