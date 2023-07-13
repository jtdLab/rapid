import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/ui/add/widget.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

const expectedUsage = [
  'Add a widget to the platform independent UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui add widget <name> [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '    --[no-]theme    Wheter the new widget has its own theme.\n'
      '                    (defaults to on)\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('ui add widget', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['ui', 'add', 'widget', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['ui', 'add', 'widget', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.uiAddWidget(
          name: any(named: 'name'),
          theme: any(named: 'theme'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['theme']).thenReturn(false);
      when(() => argResults.rest).thenReturn(['Foo']);
      final command = UiAddWidgetCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(() => rapid.uiAddWidget(name: 'Foo', theme: false)).called(1);
    });
  });
}
