import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/remove/feature.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../common.dart';
import '../../../matchers.dart';
import '../../../mocks.dart';
import '../../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Removes a feature from the ${platform.prettyName} part of an existing Rapid project.\n'
        '\n'
        'Usage: rapid ${platform.name} remove feature <name>\n'
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
    group('${platform.name} remove feature', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner
              .run([platform.name, 'remove', 'feature', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner.run([platform.name, 'remove', 'feature', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      group('throws UsageException', () {
        test(
          'when name is missing',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () => commandRunner.run([platform.name, 'remove', 'feature']),
              throwsUsageException(
                message: 'No option specified for the name.',
              ),
            );
          }),
        );

        test(
          'when multiple names are provided',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () => commandRunner
                  .run([platform.name, 'remove', 'feature', 'Foo', 'Bar']),
              throwsUsageException(message: 'Multiple names specified.'),
            );
          }),
        );

        test(
          'when name is not a valid dart package name',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () => commandRunner
                  .run([platform.name, 'remove', 'feature', '+foo+']),
              throwsUsageException(
                message: '"+foo+" is not a valid package name.\n\n'
                    'See https://dart.dev/tools/pub/pubspec#name for more information.',
              ),
            );
          }),
        );
      });

      test('completes', () async {
        final rapid = MockRapid();
        when(
          () => rapid.platformRemoveFeature(
            any(),
            name: any(named: 'name'),
          ),
        ).thenAnswer((_) async {});
        final argResults = MockArgResults();
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformRemoveFeatureCommand(platform, null)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformRemoveFeature(
            platform,
            name: 'package_a',
          ),
        ).called(1);
      });
    });
  }
}
