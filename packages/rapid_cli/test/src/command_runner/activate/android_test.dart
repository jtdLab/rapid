import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/activate/android.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Adds support for Android to this project.\n'
      '\n'
      'Usage: rapid activate android\n'
      '-h, --help        Print this usage information.\n'
      '    --desc        The description for the native Android project.\n'
      '                  (defaults to "A Rapid app.")\n'
      '    --org-name    The organization for the native Android project.\n'
      '                  (defaults to "com.example")\n'
      '    --language    The default language for Android\n'
      '                  (defaults to "en")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('activate android', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['activate', 'android', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['activate', 'android', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.activateAndroid(
          description: any(named: 'description'),
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['desc']).thenReturn('A description.');
      when(() => argResults['org-name']).thenReturn('com.foo.bar');
      when(() => argResults['language']).thenReturn('de');
      final command = ActivateAndroidCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.activateAndroid(
          description: 'A description.',
          orgName: 'com.foo.bar',
          language: Language(languageCode: 'de'),
        ),
      ).called(1);
    });
  });
}
