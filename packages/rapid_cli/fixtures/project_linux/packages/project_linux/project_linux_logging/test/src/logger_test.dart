import 'package:project_linux_logging/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

abstract class _LogCommand {
  void call(
    String message, {
    int level,
    Object? error,
    StackTrace? stackTrace,
  });
}

class _MockLogCommand extends Mock implements _LogCommand {}

class _MockStackTrace extends Mock implements StackTrace {}

void main() {
  group('Level', () {
    late Level underTest;

    group('verbose', () {
      setUpAll(() {
        underTest = Level.verbose;
      });

      group('value', () {
        test('returns 0', () {
          // Assert
          expect(underTest.value, 0);
        });
      });
    });

    group('debug', () {
      setUpAll(() {
        underTest = Level.debug;
      });

      group('value', () {
        test('returns 500', () {
          // Assert
          expect(underTest.value, 500);
        });
      });
    });

    group('info', () {
      setUpAll(() {
        underTest = Level.info;
      });

      group('value', () {
        test('returns 800', () {
          // Assert
          expect(underTest.value, 800);
        });
      });
    });

    group('warning', () {
      setUpAll(() {
        underTest = Level.warning;
      });

      group('value', () {
        test('returns 900', () {
          // Assert
          expect(underTest.value, 900);
        });
      });
    });

    group('error', () {
      setUpAll(() {
        underTest = Level.error;
      });

      group('value', () {
        test('returns 1000', () {
          // Assert
          expect(underTest.value, 1000);
        });
      });
    });

    group('wtf', () {
      setUpAll(() {
        underTest = Level.wtf;
      });

      group('value', () {
        test('returns 1200', () {
          // Assert
          expect(underTest.value, 1200);
        });
      });
    });

    group('nothing', () {
      setUpAll(() {
        underTest = Level.nothing;
      });

      group('value', () {
        test('returns 2000', () {
          // Assert
          expect(underTest.value, 2000);
        });
      });
    });

    group('>=', () {
      test('returns true when value is larger than others value', () {
        // Assert
        expect(Level.nothing >= Level.verbose, true);
      });

      test('returns true when value is the same as others value', () {
        // Assert
        expect(Level.error >= Level.error, true);
      });

      test('returns false when value is smaller than others value', () {
        // Assert
        expect(Level.verbose >= Level.nothing, false);
      });
    });
  });

  group('ProjectLinuxLoggerDevelopment', () {
    late LogCommand logCommand;
    late ProjectLinuxLoggerDevelopment underTest;

    setUp(() {
      logCommand = _MockLogCommand();
      when(
        () => logCommand(
          any(),
          level: any(named: 'level'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).thenReturn(null);
      underTest = ProjectLinuxLoggerDevelopment()
        ..logCommandOverrides = logCommand;
    });

    group('verbose', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('does nothing', () {
        // Act
        underTest.verbose(message, error, stackTrace);

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('debug', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs debug message with error and stackTrace', () {
        // Act
        underTest.debug(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[debug] $message',
            level: Level.debug.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs debug message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.debug(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[debug] $message',
            level: Level.debug.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('info', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs info message with error and stackTrace', () {
        // Act
        underTest.info(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[info] $message',
            level: Level.info.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs info message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.info(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[info] $message',
            level: Level.info.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('warning', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs warning message with error and stackTrace', () {
        // Act
        underTest.warning(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[warning] $message',
            level: Level.warning.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs warning message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.warning(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[warning] $message',
            level: Level.warning.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('error', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs error message with error and stackTrace', () {
        // Act
        underTest.error(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[error] $message',
            level: Level.error.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs error message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.error(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[error] $message',
            level: Level.error.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('wtf', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs wtf message with error and stackTrace', () {
        // Act
        underTest.wtf(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[wtf] $message',
            level: Level.wtf.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs wtf message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.wtf(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[wtf] $message',
            level: Level.wtf.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });
  });

  group('ProjectLinuxLoggerTest', () {
    late LogCommand logCommand;
    late ProjectLinuxLoggerTest underTest;

    setUp(() {
      logCommand = _MockLogCommand();
      when(
        () => logCommand(
          any(),
          level: any(named: 'level'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).thenReturn(null);
      underTest = ProjectLinuxLoggerTest()..logCommandOverrides = logCommand;
    });

    group('verbose', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs verbose message with error and stackTrace', () {
        // Act
        underTest.verbose(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[verbose] $message',
            level: Level.verbose.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs verbose message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.verbose(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[verbose] $message',
            level: Level.verbose.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('debug', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs debug message with error and stackTrace', () {
        // Act
        underTest.debug(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[debug] $message',
            level: Level.debug.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs debug message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.debug(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[debug] $message',
            level: Level.debug.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('info', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs info message with error and stackTrace', () {
        // Act
        underTest.info(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[info] $message',
            level: Level.info.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs info message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.info(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[info] $message',
            level: Level.info.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('warning', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs warning message with error and stackTrace', () {
        // Act
        underTest.warning(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[warning] $message',
            level: Level.warning.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs warning message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.warning(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[warning] $message',
            level: Level.warning.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('error', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs error message with error and stackTrace', () {
        // Act
        underTest.error(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[error] $message',
            level: Level.error.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs error message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.error(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[error] $message',
            level: Level.error.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });

    group('wtf', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('logs wtf message with error and stackTrace', () {
        // Act
        underTest.wtf(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[wtf] $message',
            level: Level.wtf.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs wtf message without error and stackTrace', () {
        // Arrange
        error = null;
        stackTrace = null;

        // Act
        underTest.wtf(message, error, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[wtf] $message',
            level: Level.wtf.value,
            error: error,
            stackTrace: stackTrace,
          ),
        ).called(1);
      });
    });
  });

  group('ProjectLinuxLoggerProduction', () {
    late LogCommand logCommand;
    late ProjectLinuxLoggerProduction underTest;

    setUp(() {
      logCommand = _MockLogCommand();
      when(
        () => logCommand(
          any(),
          level: any(named: 'level'),
          error: any(named: 'error'),
          stackTrace: any(named: 'stackTrace'),
        ),
      ).thenReturn(null);
      underTest = ProjectLinuxLoggerProduction()
        ..logCommandOverrides = logCommand;
    });

    group('verbose', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('does nothing', () {
        // Act
        underTest.verbose(message, error, stackTrace);

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('debug', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('does nothing', () {
        // Act
        underTest.debug(message, error, stackTrace);

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('info', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('does nothing', () {
        // Act
        underTest.info(message, error, stackTrace);

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('warning', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('does nothing', () {
        // Act
        underTest.warning(message, error, stackTrace);

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('error', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('does nothing', () {
        // Act
        underTest.error(message, error, stackTrace);

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('wtf', () {
      late dynamic message;
      late dynamic error;
      late StackTrace? stackTrace;

      setUp(() {
        message = 'foo';
        error = {'code': 404};
        stackTrace = _MockStackTrace();
      });

      test('does nothing', () {
        // Act
        underTest.wtf(message, error, stackTrace);

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });
  });
}
