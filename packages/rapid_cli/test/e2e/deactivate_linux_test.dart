@Tags(['e2e'])
import 'dart:io';

import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import 'common.dart';
import 'deactivate_platform.dart';

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
        'deactivate linux',
        () => performTest(
          platform: Platform.linux,
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
