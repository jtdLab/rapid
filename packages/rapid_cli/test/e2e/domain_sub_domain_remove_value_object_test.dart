@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-domain

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() async {
        Directory.current = getTempDir();

        await setupProject();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      group('domain <sub_domain> remove value_object', () {
        Future<void> performTest({
          String? dir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
          final name = 'FooBar';
          await runRapidCommand([
            'domain',
            'default',
            'add',
            'value_object',
            name,
            if (dir != null) '--output-dir',
            if (dir != null) dir,
          ]);

          // Act
          await runRapidCommand([
            'domain',
            'default',
            'remove',
            'value_object',
            name,
            if (dir != null) '--dir',
            if (dir != null) dir
          ]);

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...valueObjectFiles(name: name, outputDir: dir),
          });
          if (type != TestType.fast) {
            verifyDoNotHaveTests({
              domainPackage(),
            });
          }
        }

        test(
          '(fast) ',
          () => performTest(
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with dir (fast) ',
          () => performTest(
            dir: 'foo',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(),
          timeout: const Timeout(Duration(minutes: 4)),
        );

        test(
          'with dir',
          () => performTest(
            dir: 'foo',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
