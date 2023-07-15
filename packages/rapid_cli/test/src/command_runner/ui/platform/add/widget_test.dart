import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/ui/platform/add/widget.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a widget to the ${platform.prettyName} UI part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ui ${platform.name} add widget <name> [arguments]\n'
        '-h, --help          Print this usage information.\n'
        '    --[no-]theme    Wheter the new widget has its own theme.\n'
        '                    (defaults to on)\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('ui', () {
    for (final platform in Platform.values) {
      group('${platform.name} add widget', () {
        test(
          'help',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            await commandRunner
                .run(['ui', platform.name, 'add', 'widget', '--help']);
            expect(printLogs, equals(expectedUsage(platform)));

            printLogs.clear();

            await commandRunner
                .run(['ui', platform.name, 'add', 'widget', '-h']);
            expect(printLogs, equals(expectedUsage(platform)));
          }),
        );

        test('completes', () async {
          final rapid = MockRapid();
          when(
            () => rapid.uiPlatformAddWidget(
              platform,
              name: any(named: 'name'),
              theme: any(named: 'theme'),
            ),
          ).thenAnswer((_) async {});
          final argResults = MockArgResults();
          when(() => argResults['theme']).thenReturn(false);
          when(() => argResults.rest).thenReturn(['Foo']);
          final command = UiPlatformAddWidgetCommand(platform, null)
            ..argResultOverrides = argResults
            ..rapidOverrides = rapid;

          await command.run();

          verify(
            () => rapid.uiPlatformAddWidget(
              platform,
              name: 'Foo',
              theme: false,
            ),
          ).called(1);
        });
      });
    }
  });
}
