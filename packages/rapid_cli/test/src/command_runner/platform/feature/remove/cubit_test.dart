import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/feature/remove/cubit.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

List<String> expectedUsage(
  String featurePackage, {
  required Platform platform,
}) {
  return [
    'Removes a cubit from $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} $featurePackage remove cubit <name> [arguments]\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        '\n'
        '-d, --dir     The directory relative to <feature_package>/lib/src .\n'
        '              (defaults to ".")\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} <feature> remove cubit', () {
      test(
        'help',
        withRunner(
          (commandRunner, _, __, printLogs) async {
            await commandRunner.run(
              [platform.name, 'package_a', 'remove', 'cubit', '--help'],
            );
            expect(
              printLogs,
              equals(expectedUsage('package_a', platform: platform)),
            );

            printLogs.clear();

            await commandRunner.run(
              [platform.name, 'package_a', 'remove', 'cubit', '-h'],
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
          () => rapid.platformFeatureRemoveCubit(
            any(),
            name: any(named: 'name'),
            featureName: any(named: 'featureName'),
            dir: any(named: 'dir'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['dir']).thenReturn('some');
        when(() => argResults.rest).thenReturn(['Foo']);
        final command =
            PlatformFeatureRemoveCubitCommand(platform, 'package_a', null)
              ..argResultOverrides = argResults
              ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformFeatureRemoveCubit(
            platform,
            name: 'Foo',
            featureName: 'package_a',
            dir: 'some',
          ),
        ).called(1);
      });
    });
  }
}
