import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/remove/navigator.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Remove a navigator from the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} remove navigator [arguments]\n'
        '-h, --help       Print this usage information.\n'
        '\n'
        '\n'
        '-f, --feature    The name of the feature the navigator is related to.\n'
        '                 This must be the name of an existing ${platform.prettyName} feature.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} remove navigator', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner
              .run([platform.name, 'remove', 'navigator', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'remove', 'navigator', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformRemoveNavigator(
            any(),
            featureName: any(named: 'featureName'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults['feature']).thenReturn('package_a');
        final command = PlatformRemoveNavigatorCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformRemoveNavigator(
            platform,
            featureName: 'package_a',
          ),
        ).called(1);
      });
    });
  }
}
