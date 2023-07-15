import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/activate/web.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Adds support for Web to this project.\n'
      '\n'
      'Usage: rapid activate web\n'
      '-h, --help        Print this usage information.\n'
      '    --desc        The description for the native Web project.\n'
      '                  (defaults to "A Rapid app.")\n'
      '    --language    The default language for Web\n'
      '                  (defaults to "en")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  setUpAll(() {
    registerFallbackValues();
  });

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

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.activateWeb(
          description: any(named: 'description'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async {});
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
          language: Language(languageCode: 'de'),
        ),
      ).called(1);
    });
  });
}
