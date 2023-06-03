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

      group('infrastructure <sub_infrastructure> add service_implementation',
          () {
        Future<void> performTest({
          String? outputDir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
          final name = 'Fake';
          final service = 'FooBar';
          await runRapidCommand([
            'domain',
            'default',
            'add',
            'service_interface',
            service,
            if (outputDir != null) '--output-dir',
            if (outputDir != null) outputDir,
          ]);

          // Act
          await runRapidCommand([
            'infrastructure',
            'default',
            'add',
            'service_implementation',
            name,
            '--service',
            service,
            if (outputDir != null) '--output-dir',
            if (outputDir != null) outputDir
          ]);

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...serviceImplementationFiles(
              name: name,
              serviceName: service,
              outputDir: outputDir,
            ),
          });
          if (type != TestType.fast) {
            await verifyTestsPass(infrastructurePackage(), expectedCoverage: 0);
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
          'with output dir (fast) ',
          () => performTest(
            outputDir: 'foo',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(),
          timeout: const Timeout(Duration(minutes: 8)),
        );

        test(
          'with output dir',
          () => performTest(
            outputDir: 'foo',
          ),
          timeout: const Timeout(Duration(minutes: 8)),
        );
      });
    },
  );
}
