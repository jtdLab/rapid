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

      group('domain <sub_domain> add service_interface', () {
        Future<void> performTest({
          required String subDomain,
          String? outputDir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
          if (subDomain != 'default') {
            await runRapidCommand([
              'domain',
              'add',
              'sub_domain',
              subDomain,
            ]);
          }
          final name = 'FooBar';

          // Act
          runRapidCommand([
            'domain',
            subDomain,
            'add',
            'service_interface',
            name,
            if (outputDir != null) '--output-dir',
            if (outputDir != null) outputDir,
          ]);

          // Assert
          await verifyNoAnalyzerIssues();
          await verifyNoFormattingIssues();
          verifyDoExist({
            ...platformIndependentPackages,
            ...serviceInterfaceFiles(name: name, outputDir: outputDir),
          });
        }

        group('(default)', () {
          test(
            '(fast) ',
            () => performTest(
              subDomain: 'default',
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            'with output dir (fast) ',
            () => performTest(
              subDomain: 'default',
              outputDir: 'foo',
              type: TestType.fast,
            ),
            timeout: const Timeout(Duration(minutes: 4)),
            tags: ['fast'],
          );

          test(
            '',
            () => performTest(
              subDomain: 'default',
            ),
            timeout: const Timeout(Duration(minutes: 4)),
          );

          test(
            'with output dir',
            () => performTest(
              subDomain: 'default',
              outputDir: 'foo',
            ),
            timeout: const Timeout(Duration(minutes: 4)),
          );
        });

        test(
          '(fast) ',
          () => performTest(
            subDomain: 'foo_bar',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          'with output dir (fast) ',
          () => performTest(
            subDomain: 'foo_bar',
            outputDir: 'foo',
            type: TestType.fast,
          ),
          timeout: const Timeout(Duration(minutes: 4)),
          tags: ['fast'],
        );

        test(
          '',
          () => performTest(
            subDomain: 'foo_bar',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );

        test(
          'with output dir',
          () => performTest(
            subDomain: 'foo_bar',
            outputDir: 'foo',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
