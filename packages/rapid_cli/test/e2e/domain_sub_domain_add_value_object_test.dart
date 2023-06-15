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
        required String subDomain,
        String? outputDir,
      }) async {
        // Arrange
        await setupProject();
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
        await runRapidCommand([
          'domain',
          subDomain,
          'add',
          'value_object',
          name,
          if (outputDir != null) '--output-dir',
          if (outputDir != null) outputDir,
        ]);

        // Assert
        await verifyHasAnalyzerIssues(3);
        await verifyNoFormattingIssues();
        verifyDoExist({
          ...valueObjectFiles(
            name: name,
            subDomainName: subDomain,
            outputDir: outputDir,
          ),
        });
      }

      test(
        'domain default add value_object',
        () => performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain default add value_object (with output dir)',
        () => performTest(
          subDomain: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> add value_object',
        () => performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> add value_object (with output dir)',
        () => performTest(
          subDomain: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
