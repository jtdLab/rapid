@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

// TODO: impl

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

/*       group('end', () {
        test(
          '',
          () => performTest(),
          timeout: const Timeout(Duration(minutes: 8)),
        );
      }); */
    },
  );
}
