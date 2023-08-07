import 'package:mocktail/mocktail.dart';
import 'package:rapid_cli/src/command_runner/platform/add/feature/flow.dart';
import 'package:rapid_cli/src/project/platform.dart';
import 'package:test/test.dart';

import '../../../../matchers.dart';
import '../../../../mocks.dart';
import '../../../../utils.dart';

List<String> expectedUsage(Platform platform) {
  return [
    'Add a flow feature to the ${platform.prettyName} part of a Rapid project.',
    '',
    'Usage: rapid ${platform.name} add feature flow <name> [arguments]',
    '-h, --help         Print this usage information.',
    '',
    '',
    '    --desc         The description of the new feature.',
    '    --navigator    Whether to generate a navigator for the new feature.',
    '',
    'Run "rapid help" to see global options.'
  ];
}

void main() {
  setUpAll(registerFallbackValues);

  for (final platform in Platform.values) {
    group('${platform.name} add feature flow', () {
      test(
        'help',
        overridePrint((printLogs) async {
          final commandRunner = getCommandRunner();

          await commandRunner
              .run([platform.name, 'add', 'feature', 'flow', '--help']);
          expect(printLogs, equals(expectedUsage(platform)));

          printLogs.clear();

          await commandRunner
              .run([platform.name, 'add', 'feature', 'flow', '-h']);
          expect(printLogs, equals(expectedUsage(platform)));
        }),
      );

      group('throws UsageException', () {
        test(
          'when name is missing',
          overridePrint((printLogs) async {
            final commandRunner = getCommandRunner();

            expect(
              () =>
                  commandRunner.run([platform.name, 'add', 'feature', 'flow']),
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
                  .run([platform.name, 'add', 'feature', 'flow', 'Foo', 'Bar']),
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
                  .run([platform.name, 'add', 'feature', 'flow', '+foo+']),
              throwsUsageException(
                message: '"+foo+" is not a valid dart package name.\n\n'
                    'See https://dart.dev/tools/pub/pubspec#name for more information.',
              ),
            );
          }),
        );
      });

      test('completes', () async {
        final rapid = MockRapid();
        final argResults = MockArgResults();
        when(() => argResults['navigator']).thenReturn(true);
        when(() => argResults['desc']).thenReturn('Some description.');
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformAddFeatureFlowCommand(null, platform: platform)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddFeatureFlow(
            platform,
            name: 'package_a',
            description: 'Some description.',
            navigator: true,
          ),
        ).called(1);
      });

      test('completes with fallbacks', () async {
        final rapid = MockRapid();
        final argResults = MockArgResults();
        when(() => argResults.rest).thenReturn(['package_a']);
        final command = PlatformAddFeatureFlowCommand(null, platform: platform)
          ..argResultOverrides = argResults
          ..rapidOverrides = rapid;

        await command.run();

        verify(
          () => rapid.platformAddFeatureFlow(
            platform,
            name: 'package_a',
            description: 'The PackageA tab flow feature.',
            navigator: false,
          ),
        ).called(1);
      });
    });
  }
}
