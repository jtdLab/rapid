import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/activate/ios.dart';
import 'package:rapid_cli/src/project/language.dart';
import 'package:test/test.dart';

import '../../common.dart';
import '../../mocks.dart';
import '../../utils.dart';

const expectedUsage = [
  'Adds support for iOS to this project.\n'
      '\n'
      'Usage: rapid activate ios\n'
      '-h, --help        Print this usage information.\n'
      '    --org-name    The organization for the native iOS project.\n'
      '                  (defaults to "com.example")\n'
      '    --language    The default language for iOS\n'
      '                  (defaults to "en")\n'
      '\n'
      'Run "rapid help" to see global options.'
];

void main() {
  group('activate ios', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      overridePrint((printLogs) async {
        final commandRunner = getCommandRunner();

        await commandRunner.run(['activate', 'ios', '--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['activate', 'ios', '-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );

    test('completes', () async {
      final rapid = MockRapid();
      when(
        () => rapid.activateIos(
          orgName: any(named: 'orgName'),
          language: any(named: 'language'),
        ),
      ).thenAnswer((_) async {});
      final argResults = MockArgResults();
      when(() => argResults['org-name']).thenReturn('com.foo.bar');
      when(() => argResults['language']).thenReturn('de');
      final command = ActivateIosCommand(null)
        ..argResultOverrides = argResults
        ..rapidOverrides = rapid;

      await command.run();

      verify(
        () => rapid.activateIos(
          orgName: 'com.foo.bar',
          language: Language(languageCode: 'de'),
        ),
      ).called(1);
    });
  });
}
