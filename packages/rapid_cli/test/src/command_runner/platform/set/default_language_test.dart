import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/set/default_language.dart';
import 'package:rapid_cli/src/core/language.dart';
import 'package:rapid_cli/src/core/platform.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../mocks.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Set the default language of the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} set default_language <language>\n'
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
    group('${platform.name} set default_language', () {
      test(
        'help',
        withRunner((commandRunner, _, __, printLogs) async {
          await commandRunner.run(
            [platform.name, 'set', 'default_language', '--help'],
          );
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run(
            [platform.name, 'set', 'default_language', '-h'],
          );
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformSetDefaultLanguage(
            any(),
            language: any(named: 'language'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults.rest).thenReturn(['de']);
        final command = PlatformSetDefaultLanguageCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformSetDefaultLanguage(
            platform,
            language: Language(languageCode: 'de'),
          ),
        ).called(1);
      });
    });
  }
}
