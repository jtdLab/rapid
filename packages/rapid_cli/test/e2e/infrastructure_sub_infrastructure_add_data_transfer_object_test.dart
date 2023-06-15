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
        final entity = 'FooBar';
        await runRapidCommand([
          'domain',
          subInfrastructure,
          'add',
          'entity',
          entity,
          if (outputDir != null) '--output-dir',
          if (outputDir != null) outputDir,
        ]);

        // Act
        await runRapidCommand([
          'infrastructure',
          subInfrastructure,
          'add',
          'data_transfer_object',
          '--entity',
          entity,
          if (outputDir != null) '--output-dir',
          if (outputDir != null) outputDir
        ]);

        // Assert
        await verifyNoAnalyzerIssues();
        await verifyNoFormattingIssues();
        verifyDoExist({
          ...dataTransferObjectFiles(
            entity: entity,
            subInfrastructureName: subInfrastructure,
            outputDir: outputDir,
          ),
        });
        await verifyTestsPassWith100PercentCoverage({
          infrastructurePackage(subInfrastructure),
        });
      }

      test(
        'infrastructure default add data_transfer_object',
        () => performTest(
          subInfrastructure: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'infrastructure default add data_transfer_object (with output dir)',
        () => performTest(
          subInfrastructure: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'infrastructure <sub_infrastructure> add data_transfer_object',
        () => performTest(
          subInfrastructure: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

      test(
        'infrastructure <sub_infrastructure> add data_transfer_object (with output dir)',
        () => performTest(
          subInfrastructure: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );
    },
  );
}
