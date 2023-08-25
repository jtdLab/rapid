import 'package:rapid_cli/src/project/platform.dart';

import 'common.dart';

dynamic Function() performTest({
  required Platform platform,
  required double expectedCoverage,
  String? outputDir,
}) =>
    withTempDir((root) async {
      // Arrange
      final tester = await RapidE2ETester.withProject(root, platform);
      const name = 'FooBar';
      const featureName = 'home_page';

      // Act
      await tester.runRapidCommand([
        platform.name,
        featureName,
        'add',
        'bloc',
        name,
        if (outputDir != null) '--output-dir',
        if (outputDir != null) outputDir,
      ]);

      // Assert
      // TODO(jtdLab): commented because https://github.com/Milad-Akarie/injectable/pull/399.
      // await verifyNoAnalyzerIssues();
      await verifyNoFormattingIssues();
      verifyDoExist({
        ...tester.blocFiles(
          name: name,
          featureName: featureName,
          platform: platform,
          outputDir: outputDir,
        ),
        tester.applicationBarrelFile(
          featureName: featureName,
          platform: platform,
        ),
      });
      await verifyTestsPass(
        tester.featurePackage(featureName, platform),
        expectedCoverage: expectedCoverage,
      );
    });
