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

      group('infrastructure <sub_infrastructure> remove data_transfer_object',
          () {
        Future<void> performTest({
          required String subInfrastructure,
          String? dir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
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
          verifyDoExist({
            ...platformIndependentPackages,
          });
          verifyDoNotExist({
            ...dataTransferObjectFiles(entity: entity, outputDir: dir),
          });
          if (type != TestType.fast) {
            verifyDoNotHaveTests({
              infrastructurePackage(),
            });
          }
        }

        group('(default)', () {
          test(
            '(fast) ',
            () => performTest(
              subInfrastructure: 'default',
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            'with dir (fast) ',
            () => performTest(
              subInfrastructure: 'default',
              dir: 'foo',
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            '',
            () => performTest(
              subInfrastructure: 'default',
            ),
            timeout: const Timeout(Duration(minutes: 4)),
          );

          test(
            'with dir',
            () => performTest(
              subInfrastructure: 'default',
              dir: 'foo',
            ),
            timeout: const Timeout(Duration(minutes: 4)),
          );
        });

        test(
          '(fast) ',
          () => performTest(
            subInfrastructure: 'foo_bar',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with dir (fast) ',
          () => performTest(
            subInfrastructure: 'foo_bar',
            dir: 'foo',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            subInfrastructure: 'foo_bar',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );

        test(
          'with dir',
          () => performTest(
            subInfrastructure: 'foo_bar',
            dir: 'foo',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
