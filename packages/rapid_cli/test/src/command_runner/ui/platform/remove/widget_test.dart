import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/ui/platform/remove/widget.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../common.dart';
import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

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
  setUpAll(() {
    registerFallbackValues();
  });

  group('ui', () {
    for (final platform in Platform.values) {
      group('${platform.name} remove widget', () {
        test(
          'help',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            await commandRunner
                .run(['ui', platform.name, 'remove', 'widget', '--help']);
            expect(printLogs, equals(expectedUsage(platform)));

            printLogs.clear();

            await commandRunner
                .run(['ui', platform.name, 'remove', 'widget', '-h']);
            expect(printLogs, equals(expectedUsage(platform)));
          }),
        );

        group('throws UsageException', () {
          test(
            'when name is missing',
            overridePrint((printLogs) async {
              final commandRunner = getCommandRunner();

              expect(
                () => commandRunner
                    .run(['ui', platform.name, 'remove', 'widget']),
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
                () => commandRunner.run(
                    ['ui', platform.name, 'remove', 'widget', 'Foo', 'Bar']),
                throwsUsageException(message: 'Multiple names specified.'),
              );
            }),
          );

          test(
            'when name is not a valid dart class name',
            overridePrint((printLogs) async {
              final commandRunner = getCommandRunner();

              expect(
                () => commandRunner
                    .run(['ui', platform.name, 'remove', 'widget', 'foo']),
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
