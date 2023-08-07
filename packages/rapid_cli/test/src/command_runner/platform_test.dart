import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../mocks.dart';
import '../utils.dart';

// TODO(jtdLab): consider not using a for loop instead share a method with test logic and give each
// platform its own test invocation

List<String> expectedUsage(
  List<String> featurePackages, {
  required Platform platform,
}) {
  return [
    'Work with the ${platform.prettyName} part of a Rapid project.',
    '',
    'Usage: rapid ${platform.name} <subcommand>',
    '-h, --help    Print this usage information.',
    '',
    'Available subcommands:',
    '  add         Add features or languages to the ${platform.prettyName} part of a Rapid project.',
    ...featurePackages.map(
      (featurePackage) =>
          '  $featurePackage   Work with $featurePackage of the ${platform.prettyName} part of a Rapid project.',
    ),
    '  remove      Remove features or languages from the ${platform.prettyName} part of a Rapid project.',
    '  set         Set properties of the ${platform.prettyName} part of a Rapid project.',
    '',
    'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  for (final platform in Platform.values) {
    group(platform.name, () {
      test(
        'help',
        overridePrint(
          (printLogs) async {
            final project = MockRapidProject(
              appModule: MockAppModule(
                platformDirectory: ({required Platform platform}) =>
                    MockPlatformDirectory(
                  featuresDirectory: MockPlatformFeaturesDirectory(
                    featurePackages: [
                      FakePlatformFeaturePackage(name: 'package_a'),
                      FakePlatformFeaturePackage(name: 'package_b'),
                    ],
                  ),
                ),
              ),
            );
            final commandRunner = getCommandRunner(project: project);

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
        ),
      );
    });
  }
}
