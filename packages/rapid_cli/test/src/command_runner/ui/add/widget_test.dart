import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/ui/add/widget.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

const expectedUsage = [
  'Add a widget to the platform independent UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui add widget <name> [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('ui add widget', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
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
        () => rapid.uiAddWidget(name: any(named: 'name')),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults.rest).thenReturn(['Foo']);
      final command = UiAddWidgetCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(() => rapid.uiAddWidget(name: 'Foo')).called(1);
    });
  });
}
