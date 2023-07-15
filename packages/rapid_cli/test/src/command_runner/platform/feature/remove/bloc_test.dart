import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/feature/remove/bloc.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(
  String featurePackage, {
  required Platform platform,
}) {
  return [
    'Removes a bloc from $featurePackage of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} $featurePackage remove bloc <name> [arguments]\n'
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
    group('${platform.name} <feature> remove bloc', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final featurePackage = FakePlatformFeaturePackage(name: 'package_a');
          final project = MockRapidProject(
            appModule: MockAppModule(
              platformDirectory: ({required Platform platform}) =>
                  MockPlatformDirectory(
                featuresDirectory: MockPlatformFeaturesDirectory(
                  featurePackages: [featurePackage],
                ),
              ),
            ),
          );
          final commandRunner = getCommandRunner(project: project);

          await commandRunner
              .run([platform.name, 'package_a', 'remove', 'bloc', '--help']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );

          printLogs.clear();

          await commandRunner
              .run([platform.name, 'package_a', 'remove', 'bloc', '-h']);
          expect(
            printLogs,
            equals(expectedUsage('package_a', platform: platform)),
          );
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformFeatureRemoveBloc(
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
            PlatformFeatureRemoveBlocCommand(platform, 'package_a', null)
              ..argResultOverrides = argResults
              ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformFeatureRemoveBloc(
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
