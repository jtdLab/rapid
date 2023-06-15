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
        final entity = 'FooBar';
        await runRapidCommand([
          'domain',
          subInfrastructure,
          'add',
          'entity',
          entity,
          if (dir != null) '--output-dir',
          if (dir != null) dir,
        ]);
        await runRapidCommand([
          'infrastructure',
          subInfrastructure,
          'add',
          'data_transfer_object',
          '--entity',
          entity,
          if (dir != null) '--output-dir',
          if (dir != null) dir,
        ]);

        // Act
        await runRapidCommand([
          'infrastructure',
          subInfrastructure,
          'remove',
          'data_transfer_object',
          '--entity',
          entity,
          if (dir != null) '--dir',
          if (dir != null) dir
        ]);

        // Assert
        await verifyNoAnalyzerIssues();
        await verifyNoFormattingIssues();
        verifyDoNotExist({
          ...dataTransferObjectFiles(
            entity: entity,
            subInfrastructureName: subInfrastructure,
            outputDir: dir,
          ),
        });
        verifyDoNotHaveTests([infrastructurePackage(subInfrastructure)]);
      }

      test(
        'infrastructure default remove data_transfer_object',
        () => performTest(
          subInfrastructure: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'infrastructure default remove data_transfer_object (with dir)',
        () => performTest(
          subInfrastructure: 'default',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'infrastructure <sub_infrastructure> remove data_transfer_object',
        () => performTest(
          subInfrastructure: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'infrastructure <sub_infrastructure> remove data_transfer_object (with dir)',
        () => performTest(
          subInfrastructure: 'foo_bar',
          dir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
