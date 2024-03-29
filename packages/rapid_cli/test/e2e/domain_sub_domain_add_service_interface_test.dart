@Tags(['e2e'])
library;

import 'package:test/test.dart';

import 'common.dart';

dynamic Function() performTest({
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
      const name = 'FooBar';

      // Act
      await tester.runRapidCommand([
        'domain',
        subDomain,
        'add',
        'service_interface',
        name,
        if (outputDir != null) '--output-dir',
        if (outputDir != null) outputDir,
      ]);

      // Assert
      // TODO(jtdLab): service interface has one_member_abstract lint
      // await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoExist({
        ...tester.serviceInterfaceFiles(
          name: name,
          subDomainName: subDomain,
          outputDir: outputDir,
        ),
      });
    });

void main() {
  group(
    'E2E',
    () {
      test(
        'domain default add service_interface',
        performTest(
          subDomain: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'domain default add service_interface (with output dir)',
        performTest(
          subDomain: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */

      test(
        'domain <sub_domain> add service_interface',
        performTest(
          subDomain: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      );

/*       test(
        'domain <sub_domain> add service_interface (with output dir)',
        performTest(
          subDomain: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 4)),
      ); */
    },
  );
}
