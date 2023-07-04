import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../mocks.dart';

List<String> expectedUsage(
  List<String> featurePackages, {
  required Platform platform,
}) {
  return [
    'Work with the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  add         Add features or languages to the ${platform.prettyName} part of an existing Rapid project.\n'
        '${featurePackages.map((e) => '  $e   Work with $e of the ${platform.prettyName} part of an existing Rapid project.\n').join()}'
        '  remove      Removes features or languages from the ${platform.prettyName} part of an existing Rapid project.\n'
        '  set         Set properties of features from the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group(platform.name, () {
      test(
        'help',
        withRunner(
          (commandRunner, _, __, printLogs) async {
            await commandRunner.run([platform.name, '--help']);
            expect(
              printLogs,
              equals(
                expectedUsage(['package_a', 'package_b'], platform: platform),
              ),
            );

            printLogs.clear();

            await commandRunner.run([platform.name, '-h']);
            expect(
              printLogs,
              equals(
                expectedUsage(['package_a', 'package_b'], platform: platform),
              ),
            );
          },
          setupProject: (project) {
            final featuresDirectory = MockPlatformFeaturesDirectory();
            final platformDirectory = MockPlatformDirectory();
            final featurePackageA = MockPlatformFeaturePackage();
            when(() => featurePackageA.name).thenReturn('package_a');
            final featurePackageB = MockPlatformFeaturePackage();
            when(() => featurePackageB.name).thenReturn('package_b');
            when(() => platformDirectory.featuresDirectory)
                .thenReturn(featuresDirectory);
            when(() => featuresDirectory.featurePackages())
                .thenReturn([featurePackageA, featurePackageB]);
            when(
              () => project.platformDirectory(platform: any(named: 'platform')),
            ).thenReturn(platformDirectory);
          },
        ),
      );
    });
  }
}
