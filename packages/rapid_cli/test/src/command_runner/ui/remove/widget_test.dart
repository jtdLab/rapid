import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/ui/remove/widget.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

const expectedUsage = [
  'Remove a widget to the platform independent UI part of an existing Rapid project.\n'
      '\n'
      'Usage: rapid ui remove widget <name> [arguments]\n'
      '-h, --help    Print this usage information.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('ui remove widget', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['ui', 'remove', 'widget', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['ui', 'remove', 'widget', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.uiRemoveWidget(name: any(named: 'name')),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults.rest).thenReturn(['Foo']);
      final command = UiRemoveWidgetCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(() => rapid.uiRemoveWidget(name: 'Foo')).called(1);
    });
  });
}
