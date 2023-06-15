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
        String? dir,
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
        final outputDir = 'foo';
        await runRapidCommand([
          'domain',
          subInfrastructure,
          'add',
          'service_interface',
          service,
          if (dir != null) '--output-dir',
          if (dir != null) outputDir,
        ]);
        await runRapidCommand([
          'infrastructure',
          subInfrastructure,
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
          subInfrastructure,
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
        verifyDoNotExist({
          ...serviceImplementationFiles(
            name: name,
            serviceName: service,
            subInfrastructureName: subInfrastructure,
            outputDir: outputDir,
          ),
        });
        verifyDoNotHaveTests([infrastructurePackage(subInfrastructure)]);
      }

      test(
        'infrastructure default remove service_implementation',
        () => performTest(
          subInfrastructure: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'infrastructure default remove service_implementation (with dir)',
        () => performTest(
          subInfrastructure: 'default',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'infrastructure <sub_infrastructure> remove service_implementation',
        () => performTest(
          subInfrastructure: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'infrastructure <sub_infrastructure> remove service_implementation (with dir)',
        () => performTest(
          subInfrastructure: 'foo_bar',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
