import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/ui/remove/widget.dart';
import 'package:test/test.dart';

import '../../../matchers.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

const expectedUsage = [
  'Remove a widget from the platform independent UI part of a Rapid project.',
  '',
  'Usage: rapid ui remove widget <name> [arguments]',
  '-h, --help    Print this usage information.',
  '',
  'Run "rapid help" to see global options.',
];

void main() {
  setUpAll(registerFallbackValues);

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

    group('throws UsageException', () {
      test(
        'when name is missing',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          expect(
            () => commandRunner.run(['ui', 'remove', 'widget']),
            throwsUsageException(
              message: 'No option specified for the name.',
            ),
          );
        }),
      );

      test(
        'when multiple names are provided',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          expect(
            () => commandRunner.run(['ui', 'remove', 'widget', 'Foo', 'Bar']),
            throwsUsageException(message: 'Multiple names specified.'),
          );
        }),
      );

      test(
        'when name is not a valid dart class name',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          expect(
            () => commandRunner.run(['ui', 'remove', 'widget', 'foo']),
            throwsUsageException(
              message: '"foo" is not a valid dart class name.',
            ),
          );
        }),
      );
    });

    test('completes', () async {
      final rapid = MockRapid();
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
