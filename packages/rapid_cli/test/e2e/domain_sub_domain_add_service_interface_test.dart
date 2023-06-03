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
          String? outputDir,
          TestType type = TestType.normal,
        }) async {
          // Arrange
          final name = 'FooBar';

          // Act
          runRapidCommand([
            'domain',
            'default',
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
          timeout: const Timeout(Duration(minutes: 4)),
        );

        test(
          'with output dir',
          () => performTest(
            outputDir: 'foo',
          ),
          timeout: const Timeout(Duration(minutes: 4)),
        );
      });
    },
  );
}
