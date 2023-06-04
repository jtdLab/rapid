import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

List<String> expectedUsage(
  String featurePackage, {
  required Platform platform,
}) {
  return [
    'Work with $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} $featurePackage <subcommand>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Available subcommands:\n'
        '  add      Add components to $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '  remove   Remove components from $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} <feature>', () {
      test(
        'help',
        withRunner(
          (commandRunner, _, __, printLogs) async {
            await commandRunner.run([platform.name, 'package_a', '--help']);
            expect(
              printLogs,
              equals(expectedUsage('package_a', platform: platform)),
            );

            printLogs.clear();

            await commandRunner.run([platform.name, 'package_a', '-h']);
            expect(
              printLogs,
              equals(expectedUsage('package_a', platform: platform)),
            );
          },
          setupProject: (project) {
            final featuresDirectory = MockPlatformFeaturesDirectory();
            final platformDirectory = MockPlatformDirectory();
            final featurePackageA = MockPlatformFeaturePackage();
            when(() => featurePackageA.name).thenReturn('package_a');
            when(() => platformDirectory.featuresDirectory)
                .thenReturn(featuresDirectory);
            when(() => featuresDirectory.featurePackages())
                .thenReturn([featurePackageA]);
            when(
              () => project.platformDirectory(platform: any(named: 'platform')),
            ).thenReturn(platformDirectory);
          },
        ),
      );
    });
  }
}