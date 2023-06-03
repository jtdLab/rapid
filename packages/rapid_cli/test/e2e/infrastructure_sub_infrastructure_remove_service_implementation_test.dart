@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

// TODO test sub-infrastructure

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

      group('infrastructure <sub_infrastructure> remove service_implementation',
          () {
        Future<void> performTest({
          String? dir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
          await setupProject();
          final name = 'Fake';
          final service = 'FooBar';
          final outputDir = 'foo';
          await runRapidCommand([
            'domain',
            'default',
            'add',
            'service_interface',
            service,
            if (dir != null) '--output-dir',
            if (dir != null) outputDir,
          ]);
          await runRapidCommand([
            'infrastructure',
            'default',
            'add',
            'service_implementation',
            name,
            '--service',
            service,
            if (dir != null) '--output-dir',
            if (dir != null) outputDir,
          ]);

          // Act
          await runRapidCommand([
            'infrastructure',
            'default',
            'remove',
            'service_implementation',
            name,
            '--service',
            service,
            if (dir != null) '--dir',
            if (dir != null) outputDir
          ]);

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
              outputDir: outputDir,
            ),
          });
          if (type != TestType.fast) {
            verifyDoNotHaveTests({
              infrastructurePackage(),
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
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
