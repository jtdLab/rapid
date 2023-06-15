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
            tester.runRapidCommand([
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
              ...tester.serviceInterfaceFiles(
                name: name,
                subDomainName: subDomain,
                outputDir: outputDir,
              ),
            });
          });

      test(
        'domain default add service_interface',
        () => performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain default add service_interface (with output dir)',
        () => performTest(
          subDomain: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> add service_interface',
        () => performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

      test(
        'domain <sub_domain> add service_interface (with output dir)',
        () => performTest(
          subDomain: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );
    },
  );
}
