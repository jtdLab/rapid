import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/activate/web.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Add support for Web to this project.',
  '',
  'Usage: rapid activate web',
  '-h, --help        Print this usage information.',
  '    --desc        The description for the native Web project.',
  '                  (defaults to "A Rapid app.")',
  '    --language    The default language for Web',
  '                  (defaults to "en")',
  '',
  'Run "rapid help" to see global options.',
];

void main() {
  setUpAll(registerFallbackValues);

  group('activate web', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['activate', 'web', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['activate', 'web', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    group('throws UsageException', () {
      test(
        'when language is invalid',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();
          const language = 'xxyyzz';

          expect(
            () => commandRunner.run(
              ['activate', 'web', '--language', language],
            ),
            throwsUsageException(
              message: '"$language" is not a valid language.\n\n'
                  'See https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry for more information.',
            ),
          );
        }),
      );
    });

    test('completes', () async {
      final rapid = MockRapid();
      final argResults = MockArgResults();
      when(() => argResults['desc']).thenReturn('A description.');
      when(() => argResults['language']).thenReturn('de');
      final command = ActivateWebCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.activateWeb(
          description: 'A description.',
          language: const Language(languageCode: 'de'),
        ),
      ).called(1);
    });
  });
}
