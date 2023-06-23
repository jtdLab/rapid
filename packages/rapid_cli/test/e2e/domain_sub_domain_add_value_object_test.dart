@Tags(['e2e'])
import 'package:test/test.dart';

import 'common.dart';

void main() {
  group(
    'E2E',
    () {
      dynamic performTest({
        required String subDomain,
        String? outputDir,
      }) =>
          withTempDir((root) async {
            // Arrange
            final tester = await RapidE2ETester.withProject(root);
            if (subDomain != 'default') {
              await tester.runRapidCommand([
                'domain',
                'add',
                'sub_domain',
                subDomain,
              ]);
            }
            final name = 'FooBar';

            // Act
            await tester.runRapidCommand([
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
              ...tester.valueObjectFiles(
                name: name,
                subDomainName: subDomain,
                outputDir: outputDir,
              ),
            });
          });

      test(
        'domain default add value_object',
        performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain default add value_object (with output dir)',
        performTest(
          subDomain: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> add value_object',
        performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> add value_object (with output dir)',
        performTest(
          subDomain: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
