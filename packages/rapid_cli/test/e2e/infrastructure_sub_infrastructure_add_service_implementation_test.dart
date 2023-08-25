@Tags(['e2e'])
library;

import 'package:test/test.dart';

import 'common.dart';

dynamic Function() performTest({
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
      const name = 'Fake';
      const service = 'FooBar';
      await tester.runRapidCommand([
        'domain',
        subInfrastructure,
        'add',
        'service_interface',
        service,
        if (outputDir != null) '--output-dir',
        if (outputDir != null) outputDir,
      ]);

      // Act
      await tester.runRapidCommand([
        'infrastructure',
        subInfrastructure,
        'add',
        'service_implementation',
        name,
        '--service',
        service,
        if (outputDir != null) '--output-dir',
        if (outputDir != null) outputDir,
      ]);

      // Assert
      // TODO(jtdLab): commented because https://github.com/Milad-Akarie/injectable/pull/399.
      // await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoExist({
        ...tester.serviceImplementationFiles(
          name: name,
          serviceName: service,
          subInfrastructureName: subInfrastructure,
          outputDir: outputDir,
        ),
      });
      await verifyTestsPass(
        tester.infrastructurePackage(subInfrastructure),
        expectedCoverage: 0,
      );
    });

void main() {
  group(
    'E2E',
    () {
      test(
        'infrastructure default add service_implementation',
        performTest(
          subInfrastructure: 'default',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

/*       test(
        'infrastructure default add service_implementation (with output dir)',
        performTest(
          subInfrastructure: 'default',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      ); */

      test(
        'infrastructure <sub_infrastructure> add service_implementation',
        performTest(
          subInfrastructure: 'foo_bar',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      );

/*       test(
        'infrastructure <sub_infrastructure> add '
        'service_implementation (with output dir)',
        performTest(
          subInfrastructure: 'foo_bar',
          outputDir: 'foo',
        ),
        timeout: const Timeout(Duration(minutes: 8)),
      ); */
    },
  );
}
