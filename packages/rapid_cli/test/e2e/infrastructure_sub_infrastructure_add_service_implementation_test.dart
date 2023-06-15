@Tags(['e2e'])
import 'dart:io';

import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      cwd = Directory.current;

      setUp(() async {
        Directory.current = getTempDir();
      });

      tearDown(() {
        Directory.current = cwd;
      });

      Future<void> performTest({
        required String subInfrastructure,
        String? outputDir,
      }) async {
        // Arrange
        await setupProject();
        if (subInfrastructure != 'default') {
          await runRapidCommand([
            'domain',
            'add',
            'sub_domain',
            subInfrastructure,
          ]);
        }
        final name = 'Fake';
        final service = 'FooBar';
        await runRapidCommand([
          'domain',
          subInfrastructure,
          'add',
          'service_interface',
          service,
          if (outputDir != null) '--output-dir',
          if (outputDir != null) outputDir,
        ]);

        // Act
        await runRapidCommand([
          'infrastructure',
          subInfrastructure,
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
          ...serviceImplementationFiles(
            name: name,
            serviceName: service,
            subInfrastructureName: subInfrastructure,
            outputDir: outputDir,
          ),
        });
        await verifyTestsPass(
          infrastructurePackage(subInfrastructure),
          expectedCoverage: 0,
        );
      }

      test(
        'infrastructure default add service_implementation',
        () => performTest(
          subInfrastructure: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'infrastructure default add service_implementation (with output dir)',
        () => performTest(
          subInfrastructure: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'infrastructure <sub_infrastructure> add service_implementation',
        () => performTest(
          subInfrastructure: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'infrastructure <sub_infrastructure> add service_implementation (with output dir)',
        () => performTest(
          subInfrastructure: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
