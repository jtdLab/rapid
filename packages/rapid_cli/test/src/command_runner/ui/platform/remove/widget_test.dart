import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/ui/platform/remove/widget.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Remove a widget from the ${platform.prettyName} UI part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ui ${platform.name} remove widget <name> [arguments]\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  group('ui', () {
    setUpAll(() {
      registerFallbackValues();
    });

    for (final platform in Platform.values) {
      group('${platform.name} remove widget', () {
        test(
          'help',
          withRunner((commandRunner, _, __, printLogs) async {
            await commandRunner
                .run(['ui', platform.name, 'remove', 'widget', '--help']);
            expect(printLogs, equals(expectedUsage(platform)));

            printLogs.clear();

            await commandRunner
                .run(['ui', platform.name, 'remove', 'widget', '-h']);
            expect(printLogs, equals(expectedUsage(platform)));
          }),
        );

        test('completes', () async {
          final rapid = MockRapid();
          when(
            () => rapid.uiPlatformRemoveWidget(
              platform,
              name: any(named: 'name'),
            ),
          ).thenAnswer((_) async {});
          final argResults = MockArgResults();
          when(() => argResults.rest).thenReturn(['Foo']);
          final command = UiPlatformRemoveWidgetCommand(platform, null)
            ..argResultOverrides = argResults
            ..rapidOverrides = rapid;

          await command.run();

          verify(
            () => rapid.uiPlatformRemoveWidget(
              platform,
              name: 'Foo',
            ),
          ).called(1);
        });
      });
    }
  });
}
