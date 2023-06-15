import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      dynamic performTest({
        required String subInfrastructure,
        String? outputDir,
      }) =>
          withTempDir((root) async {
            // Arrange
            final tester = await RapidE2ETester.withProject(root);
            if (subInfrastructure != 'default') {
              await tester.runRapidCommand([
                'domain',
                'add',
                'sub_domain',
                subInfrastructure,
              ]);
            }
            final entity = 'FooBar';
            await tester.runRapidCommand([
              'domain',
              subInfrastructure,
              'add',
              'entity',
              entity,
              if (outputDir != null) '--output-dir',
              if (outputDir != null) outputDir,
            ]);

            // Act
            await tester.runRapidCommand([
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
              ...tester.dataTransferObjectFiles(
                entity: entity,
                subInfrastructureName: subInfrastructure,
                outputDir: outputDir,
              ),
            });
            await verifyTestsPassWith100PercentCoverage({
              tester.infrastructurePackage(subInfrastructure),
            });
          });

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
