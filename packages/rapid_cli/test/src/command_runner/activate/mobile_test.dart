import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/activate/mobile.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

import '../../common.dart';
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
  group('activate mobile', () {
    setUpAll(() {
      registerFallbackValues();
    });

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

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.activateMobile(
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async {});
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
