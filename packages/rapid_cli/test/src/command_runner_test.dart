import 'package:test/test.dart';

import 'common.dart';
import 'mocks.dart';

const expectedUsage = [
  'A CLI tool for developing Flutter apps based on Rapid Architecture.\n'
      '\n'
      'Usage: rapid <command>\n'
      '\n'
      'Global options:\n'
      '-h, --help       Print this usage information.\n'
      '-v, --version    Print the current version.\n'
      '    --verbose    Enable verbose logging.\n'
      '\n'
      'Available commands:\n'
      '  activate         Add support for a platform to an existing Rapid project.\n'
      '  android          Work with the Android part of an existing Rapid project.\n'
      '  begin            Starts a group of Rapid command executions.\n'
      '  create           Create a new Rapid project.\n'
      '  deactivate       Remove support for a platform from an existing Rapid project.\n'
      '  doctor           Show information about an existing Rapid project.\n'
      '  domain           Work with the domain part of an existing Rapid project.\n'
      '  end              Ends a group of Rapid command executions.\n'
      '  infrastructure   Work with the infrastructure part of an existing Rapid\n'
      '                   project.\n'
      '  ios              Work with the iOS part of an existing Rapid project.\n'
      '  linux            Work with the Linux part of an existing Rapid project.\n'
      '  macos            Work with the macOS part of an existing Rapid project.\n'
      '  mobile           Work with the Mobile part of an existing Rapid project.\n'
      '  pub              Work with packages in a Rapid environment.\n'
      '  ui               Work with the UI part of an existing Rapid project.\n'
      '  web              Work with the Web part of an existing Rapid project.\n'
      '  windows          Work with the Windows part of an existing Rapid project.\n'
      '\n'
      'Run "rapid help <command>" for more information about a command.'
];

void main() {
  group('RapidCommandRunner', () {
    setUpAll(() {
      registerFallbackValues();
    });

    test(
      'help',
      withRunner((commandRunner, _, __, printLogs) async {
        await commandRunner.run(['--help']);
        expect(printLogs, equals(expectedUsage));

        printLogs.clear();

        await commandRunner.run(['-h']);
        expect(printLogs, equals(expectedUsage));
      }),
    );
  });
}

///
/// // TODO test rapidEntryPoint
///  test(
///       'version',
///       overridePrint((_) async {
///         await commandRunner.run(['--version']);
///         verify(() => logger.info(packageVersion)).called(1);
///       }),
///     );
///
///     test('handles FormatException', () async {
///         // Arrange
///         const exception = FormatException('oops!');
///         var isFirstInvocation = true;
///         when(() => logger.info(any())).thenAnswer((_) {
///           if (isFirstInvocation) {
///             isFirstInvocation = false;
///             throw exception;
///           }
///         });
///
///         // Act
///         final result = await commandRunner.run(['--version']);
///
///         // Assert
///         expect(result, equals(ExitCode.usage.code));
///         verify(() => logger.err(exception.message)).called(1);
///         verify(() => logger.info(commandRunner.usage)).called(1);
///       });
///
///       test('handles UsageException', () async {
///         // Arrange
///         final exception = UsageException('oops!', 'exception usage');
///         var isFirstInvocation = true;
///         when(() => logger.info(any())).thenAnswer((_) {
///           if (isFirstInvocation) {
///             isFirstInvocation = false;
///             throw exception;
///           }
///         });
///
///         // Act
///         final result = await commandRunner.run(['--version']);
///
///         // Assert
///         expect(result, equals(ExitCode.usage.code));
///         verify(() => logger.err(exception.message)).called(1);
///         verify(() => logger.info('exception usage')).called(1);
///       });
///
///       test(
///         'handles no command',
///         overridePrint(() async {
///           // Act
///           final result = await commandRunner.run([]);
///
///           // Assert
///           expect(printLogs, equals(expectedUsage));
///           expect(result, equals(ExitCode.success.code));
///         }),
///       );
