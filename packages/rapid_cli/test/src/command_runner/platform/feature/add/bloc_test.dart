import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/feature/add/bloc.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

List<String> expectedUsage(
  String featurePackage, {
  required Platform platform,
}) {
  return [
    'Adds a bloc to $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} $featurePackage add bloc <name> [arguments]\n'
        '-h, --help          Print this usage information.\n'
        '\n'
        '\n'
        '-o, --output-dir    The output directory relative to <feature_package>/lib/src .\n'
        '                    (defaults to ".")\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} <feature> add bloc', () {
      test(
        'help',
        withRunner(
          (commandRunner, _, __, printLogs) async {
            await commandRunner.run(
              [platform.name, 'package_a', 'add', 'bloc', '--help'],
            );
            expect(
              printLogs,
              equals(expectedUsage('package_a', platform: platform)),
            );

            printLogs.clear();

            await commandRunner.run(
              [platform.name, 'package_a', 'add', 'bloc', '-h'],
            );
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

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformFeatureAddBloc(
            any(),
            name: any(named: 'name'),
            featureName: any(named: 'featureName'),
            outputDir: any(named: 'outputDir'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['output-dir']).thenReturn('some');
        when(() => argResults.rest).thenReturn(['Foo']);
        final command =
            PlatformFeatureAddBlocCommand(platform, 'package_a', null)
              ..argResultOverrides = argResults
              ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformFeatureAddBloc(
            platform,
            name: 'Foo',
            featureName: 'package_a',
            outputDir: 'some',
          ),
        ).called(1);
      });
    });
  }
}
