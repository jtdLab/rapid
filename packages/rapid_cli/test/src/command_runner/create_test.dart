import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/create.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../common.dart';
import '../matchers.dart';
import '../mocks.dart';
import '../utils.dart';

const expectedUsage = [
  'Create a new Rapid project.\n'
      '\n'
      'Usage: rapid create <project name> [arguments]\n'
      '-h, --help          Print this usage information.\n'
      '\n'
      '\n'
      '-o, --output-dir    The directory where to generate the new project\n'
      '                    (defaults to ".")\n'
      '    --desc          The description of the new project.\n'
      '                    (defaults to "A Rapid app.")\n'
      '    --org-name      The organization of the new project.\n'
      '                    (defaults to "com.example")\n'
      '    --language      The language of the new project\n'
      '                    (defaults to "en")\n'
      '\n'
      '\n'
      '    --android       Wheter the new project supports the Android platform.\n'
      '    --ios           Wheter the new project supports the iOS platform.\n'
      '    --linux         Wheter the new project supports the Linux platform.\n'
      '    --macos         Wheter the new project supports the macOS platform.\n'
      '    --web           Wheter the new project supports the Web platform.\n'
      '    --windows       Wheter the new project supports the Windows platform.\n'
      '    --mobile        Wheter the new project supports the Mobile platform.\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('create', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test('c is a valid alias', () {
      final command = CreateCommand();
      expect(command.aliases, contains('c'));
    });

    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['create', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['create', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    group('throws UsageException', () {
      test(
        'when project name is missing',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();
          expect(
            () => commandRunner.run(['create']),
            throwsUsageException(
              message: 'No option specified for the project name.',
            ),
          );
        }),
      );

      group('when project name is invalid', () {
        test(
          '(contains spaces)',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();
            const projectName = 'my app';

            expect(
              () => commandRunner.run(['create', projectName]),
              throwsUsageException(
                message: '"$projectName" is not a valid package name.\n\n'
                    'See https://dart.dev/tools/pub/pubspec#name for more information.',
              ),
            );
          }),
        );

        test(
          '(contains uppercase)',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();
            const projectName = 'My_app';

            expect(
              () => commandRunner.run(['create', projectName]),
              throwsUsageException(
                message: '"$projectName" is not a valid package name.\n\n'
                    'See https://dart.dev/tools/pub/pubspec#name for more information.',
              ),
            );
          }),
        );

        test(
          '(invalid characters present)',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();
            const projectName = '.-@_my_app_*';

            expect(
              () => commandRunner.run(['create', projectName]),
              throwsUsageException(
                message: '"$projectName" is not a valid package name.\n\n'
                    'See https://dart.dev/tools/pub/pubspec#name for more information.',
              ),
            );
          }),
        );
      });

      test(
        'when multiple project names are provided',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();
          expect(
            () => commandRunner.run(['create', 'foo', 'bar']),
            throwsUsageException(
              message: 'Multiple project names specified.',
            ),
          );
        }),
      );

      test(
        'when language is invalid',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();
          const language = 'xxyyzz';

          expect(
            () => commandRunner.run(
              ['create', 'my_project', '--language', language],
            ),
            throwsUsageException(
              message: '"$language" is not a valid language.\n\n'
                  'See https://www.iana.org/assignments/language-subtag-registry/language-subtag-registry for more information.',
            ),
          );
        }),
      );

      group('when org-name is invalid', () {
        void Function() verifyOrgNameIsInvalid(String orgName) =>
            overridePrint((printLogs) async {
              final commandRunner = getCommandRunner();

              expect(
                () => commandRunner.run(
                  ['create', 'my_project', '--org-name', orgName],
                ),
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
    });

    test('completes (1)', () async {
      final rapid = MockRapid();
      when(
        () => rapid.create(
          projectName: any(named: 'projectName'),
          outputDir: any(named: 'outputDir'),
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
          platforms: any(named: 'platforms'),
        ),
      ).thenAnswer((_) async => 0);
      final argResults = MockArgResults();
      when(() => argResults['output-dir']).thenReturn('.');
      when(() => argResults['desc']).thenReturn('A description.');
      when(() => argResults['org-name']).thenReturn('com.foo.bar');
      when(() => argResults['language']).thenReturn('de');
      when(() => argResults['android']).thenReturn(true);
      when(() => argResults['ios']).thenReturn(true);
      when(() => argResults['linux']).thenReturn(true);
      when(() => argResults['macos']).thenReturn(true);
      when(() => argResults['mobile']).thenReturn(true);
      when(() => argResults['web']).thenReturn(true);
      when(() => argResults['windows']).thenReturn(true);
      when(() => argResults.rest).thenReturn(['my_app']);
      final command = CreateCommand()
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.create(
          projectName: 'my_app',
          outputDir: '.',
          description: 'A description.',
          orgName: 'com.foo.bar',
          language: Language(languageCode: 'de'),
          platforms: {
            Platform.android,
            Platform.ios,
            Platform.linux,
            Platform.macos,
            Platform.web,
            Platform.windows,
            Platform.mobile,
          },
        ),
      ).called(1);
    });

    test('completes (2)', () async {
      final rapid = MockRapid();
      when(
        () => rapid.create(
          projectName: any(named: 'projectName'),
          outputDir: any(named: 'outputDir'),
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
          platforms: any(named: 'platforms'),
        ),
      ).thenAnswer((_) async => 0);
      final argResults = MockArgResults();
      when(() => argResults['output-dir']).thenReturn('.');
      when(() => argResults['desc']).thenReturn('A description.');
      when(() => argResults['org-name']).thenReturn('com.foo.bar');
      when(() => argResults['language']).thenReturn('de');
      when(() => argResults['android']).thenReturn(false);
      when(() => argResults['ios']).thenReturn(false);
      when(() => argResults['linux']).thenReturn(false);
      when(() => argResults['macos']).thenReturn(false);
      when(() => argResults['mobile']).thenReturn(false);
      when(() => argResults['web']).thenReturn(false);
      when(() => argResults['windows']).thenReturn(false);
      when(() => argResults.rest).thenReturn(['my_app']);
      final command = CreateCommand()
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.create(
          projectName: 'my_app',
          outputDir: '.',
          description: 'A description.',
          orgName: 'com.foo.bar',
          language: Language(languageCode: 'de'),
          platforms: {},
        ),
      ).called(1);
    });
  });
}
