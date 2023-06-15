@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      dynamic performTest({
        required String subInfrastructure,
        String? dir,
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
              if (dir != null) '--output-dir',
              if (dir != null) dir,
            ]);
            await tester.runRapidCommand([
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
            await tester.runRapidCommand([
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
              ...tester.dataTransferObjectFiles(
                entity: entity,
                subInfrastructureName: subInfrastructure,
                outputDir: dir,
              ),
            });
            verifyDoNotHaveTests(
                [tester.infrastructurePackage(subInfrastructure)]);
          });

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
