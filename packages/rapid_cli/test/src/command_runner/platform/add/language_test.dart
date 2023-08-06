import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/language.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../matchers.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a language to the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} add language <language>\n'
        '-h, --help    Print this usage information.\n'
        '\n'
        'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  for (final platform in Platform.values) {
    group('${platform.name} add language', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner.run([platform.name, 'add', 'language', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'add', 'language', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      group('throws UsageException', () {
        test(
          'when language is missing',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () => commandRunner.run([platform.name, 'add', 'language']),
              throwsUsageException(
                message: 'No option specified for the language.',
              ),
            );
          }),
        );

        test(
          'when multiple languages are provided',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () => commandRunner
                  .run([platform.name, 'add', 'language', 'de', 'fr']),
              throwsUsageException(
                message: 'Multiple languages specified.',
              ),
            );
          }),
        );

        test(
          'when language is invalid',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () =>
                  commandRunner.run([platform.name, 'add', 'language', '+en+']),
              throwsUsageException(
                message: '"+en+" is not a valid language.\n\n'
                    'See https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry for more information.',
              ),
            );
          }),
        );
      });

      test('completes', () async {
        final rapid = MockRapid();
        final argResults = MockArgResults();
        when(() => argResults.rest).thenReturn(['de']);
        final command = PlatformAddLanguageCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddLanguage(
            platform,
            language: Language(languageCode: 'de'),
          ),
        ).called(1);
      });
    });
  }
}
