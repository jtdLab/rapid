import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/activate/linux.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

import '../../matchers.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Adds support for Linux to this project.\n'
      '\n'
      'Usage: rapid activate linux\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the native Linux project.\n'
      '                  (defaults to "com.example")\n'
      '    --language    The default language for Linux\n'
      '                  (defaults to "en")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

  group('activate linux', () {
    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['activate', 'linux', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['activate', 'linux', '-h']);
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
                    .run(['activate', 'linux', '--org-name', orgName]),
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
              ['activate', 'linux', '--language', language],
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
      when(() => argResults['org-name']).thenReturn('com.foo.bar');
      when(() => argResults['language']).thenReturn('de');
      final command = ActivateLinuxCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.activateLinux(
          orgName: 'com.foo.bar',
          language: Language(languageCode: 'de'),
        ),
      ).called(1);
    });
  });
}
