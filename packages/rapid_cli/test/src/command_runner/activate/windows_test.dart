import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/activate/windows.dart';
import 'package:rapid_cli/src/language.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';

const expectedUsage = [
  'Adds support for Windows to this project.\n'
      '\n'
      'Usage: rapid activate windows\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the native Windows project.\n'
      '                  (defaults to "com.example")\n'
      '    --language    The default language for Windows\n'
      '                  (defaults to "en")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('activate windows', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
        await commandRunner.run(['activate', 'windows', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['activate', 'windows', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.activateWindows(
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['org-name']).thenReturn('com.foo.bar');
      when(() => argResults['language']).thenReturn('de');
      final command = ActivateWindowsCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.activateWindows(
          orgName: 'com.foo.bar',
          language: Language(languageCode: 'de'),
        ),
      ).called(1);
    });
  });
}
