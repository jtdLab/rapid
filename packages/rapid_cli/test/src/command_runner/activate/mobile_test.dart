import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/activate/mobile.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../matchers.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Adds support for Mobile to this project.\n'
      '\n'
      'Usage: rapid activate mobile\n'
      '-h, --help        Print this usage information.\n'
      '    --desc        The description for the native Android project.\n'
      '                  (defaults to "A Rapid app.")\n'
      '    --org-name    The organization for the native Mobile projects.\n'
      '                  (defaults to "com.example")\n'
      '    --language    The default language for Mobile\n'
      '                  (defaults to "en")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('activate mobile', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['activate', 'mobile', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['activate', 'mobile', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    group('throws UsageException', () {
      group('when org-name is invalid', () {
        void Function() verifyOrgNameIsInvalid(String orgName) =>
            overridePrint((printLogs) async {
              final commandRunner = getCommandRunner();

              expect(
                () => commandRunner
                    .run(['activate', 'mobile', '--org-name', orgName]),
                throwsUsageException(
                  message: '"$orgName" is not a valid org name.\n\n'
                      'A valid org name has at least 2 parts separated by "."\n'
                      'Each part must start with a letter and only include '
                      'alphanumeric characters (A-Z, a-z, 0-9), underscores (_), '
                      'and hyphens (-)\n'
                      '(ex. com.example)',
                ),
              );
            });

        test(
          '(valid prefix but invalid suffix)',
          verifyOrgNameIsInvalid('some.good.prefix.bad@@suffix'),
        );

        test(
          '(invalid characters present)',
          verifyOrgNameIsInvalid('bad%.org@.#name'),
        );

        test('(no delimiters)', verifyOrgNameIsInvalid('My Org'));

        test(
          '(segment starts with a non-letter)',
          verifyOrgNameIsInvalid('bad.org.1name'),
        );

        test('(less than 2 domains)', verifyOrgNameIsInvalid('badorgname'));
      });

      test(
        'when language is invalid',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();
          const language = 'xxyyzz';

          expect(
            () => commandRunner.run(
              ['activate', 'mobile', '--language', language],
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
      when(() => argResults['org-name']).thenReturn('com.foo.bar');
      when(() => argResults['language']).thenReturn('de');
      final command = ActivateMobileCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.activateMobile(
          description: 'A description.',
          orgName: 'com.foo.bar',
          language: Language(languageCode: 'de'),
        ),
      ).called(1);
    });
  });
}
