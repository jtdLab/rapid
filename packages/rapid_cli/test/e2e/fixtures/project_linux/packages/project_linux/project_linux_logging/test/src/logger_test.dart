import 'package:project_linux_logging/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

ProjectLinuxLoggerDevelopment _getProjectLinuxLoggerDevelopment({
  required LogCommand logCommand,
}) {
  return ProjectLinuxLoggerDevelopment()..logCommandOverrides = logCommand;
}

ProjectLinuxLoggerTest _getProjectLinuxLoggerTest({
  required LogCommand logCommand,
}) {
  return ProjectLinuxLoggerTest()..logCommandOverrides = logCommand;
}

ProjectLinuxLoggerProduction _getProjectLinuxLoggerProduction({
  required LogCommand logCommand,
}) {
  return ProjectLinuxLoggerProduction()..logCommandOverrides = logCommand;
}

void main() {
  group('Level', () {
    group('.verbose', () {
      final verbose = Level.verbose;

      test('.value', () {
        expect(verbose.value, 0);
      });
    });

    group('.debug', () {
      final debug = Level.debug;

      test('.value', () {
        expect(debug.value, 500);
      });
    });

    group('.info', () {
      final info = Level.info;

      test('.value', () {
        expect(info.value, 800);
      });
    });

    group('.warning', () {
      final warning = Level.warning;

      test('.value', () {
        expect(warning.value, 900);
      });
    });

    group('.error', () {
      final error = Level.error;

      test('.value', () {
        expect(error.value, 1000);
      });
    });

    group('.wtf', () {
      final wtf = Level.wtf;

      test('.value', () {
        expect(wtf.value, 1200);
      });
    });

    group('.nothing', () {
      final nothing = Level.nothing;

      test('.value', () {
        expect(nothing.value, 2000);
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
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerDevelopment.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerDevelopment.debug('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[debug] foo',
            level: Level.debug.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs debug message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerDevelopment.debug('foo');

        // Assert
        verify(
          () => logCommand(
            '[debug] foo',
            level: Level.debug.value,
          ),
        ).called(1);
      });
    });

    group('.info()', () {
      test('logs info message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerDevelopment.info('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[info] foo',
            level: Level.info.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs info message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerDevelopment.info('foo');

        // Assert
        verify(
          () => logCommand(
            '[info] foo',
            level: Level.info.value,
          ),
        ).called(1);
      });
    });

    group('.warning()', () {
      test('logs warning message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerDevelopment.warning('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[warning] foo',
            level: Level.warning.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs warning message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerDevelopment.warning('foo');

        // Assert
        verify(
          () => logCommand(
            '[warning] foo',
            level: Level.warning.value,
          ),
        ).called(1);
      });
    });

    group('.error()', () {
      test('logs error message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerDevelopment.error('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[error] foo',
            level: Level.error.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs error message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerDevelopment.error('foo');

        // Assert
        verify(
          () => logCommand(
            '[error] foo',
            level: Level.error.value,
          ),
        ).called(1);
      });
    });

    group('.wtf()', () {
      test('logs wtf message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerDevelopment.wtf('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[wtf] foo',
            level: Level.wtf.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs wtf message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerDevelopment = _getProjectLinuxLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerDevelopment.wtf('foo');

        // Assert
        verify(
          () => logCommand(
            '[wtf] foo',
            level: Level.wtf.value,
          ),
        ).called(1);
      });
    });
  });

  group('ProjectLinuxLoggerTest', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerTest.verbose('foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerTest.debug('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[debug] foo',
            level: Level.debug.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs debug message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerTest.debug('foo');

        // Assert
        verify(
          () => logCommand(
            '[debug] foo',
            level: Level.debug.value,
          ),
        ).called(1);
      });
    });

    group('.info()', () {
      test('logs info message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerTest.info('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[info] foo',
            level: Level.info.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs info message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerTest.info('foo');

        // Assert
        verify(
          () => logCommand(
            '[info] foo',
            level: Level.info.value,
          ),
        ).called(1);
      });
    });

    group('.warning()', () {
      test('logs warning message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerTest.warning('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[warning] foo',
            level: Level.warning.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs warning message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerTest.warning('foo');

        // Assert
        verify(
          () => logCommand(
            '[warning] foo',
            level: Level.warning.value,
          ),
        ).called(1);
      });
    });

    group('.error()', () {
      test('logs error message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerTest.error('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[error] foo',
            level: Level.error.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs error message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerTest.error('foo');

        // Assert
        verify(
          () => logCommand(
            '[error] foo',
            level: Level.error.value,
          ),
        ).called(1);
      });
    });

    group('.wtf()', () {
      test('logs wtf message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerTest.wtf('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[wtf] foo',
            level: Level.wtf.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs wtf message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerTest = _getProjectLinuxLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerTest.wtf('foo');

        // Assert
        verify(
          () => logCommand(
            '[wtf] foo',
            level: Level.wtf.value,
          ),
        ).called(1);
      });
    });
  });

  group('ProjectLinuxLoggerProduction', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerProduction.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerProduction.debug('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[debug] foo',
            level: Level.debug.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs debug message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerProduction.debug('foo');

        // Assert
        verify(
          () => logCommand(
            '[debug] foo',
            level: Level.debug.value,
          ),
        ).called(1);
      });
    });

    group('.info()', () {
      test('logs info message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerProduction.info('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[info] foo',
            level: Level.info.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs info message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerProduction.info('foo');

        // Assert
        verify(
          () => logCommand(
            '[info] foo',
            level: Level.info.value,
          ),
        ).called(1);
      });
    });

    group('.warning()', () {
      test('logs warning message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerProduction.warning('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[warning] foo',
            level: Level.warning.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs warning message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerProduction.warning('foo');

        // Assert
        verify(
          () => logCommand(
            '[warning] foo',
            level: Level.warning.value,
          ),
        ).called(1);
      });
    });

    group('.error()', () {
      test('logs error message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerProduction.error('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[error] foo',
            level: Level.error.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs error message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerProduction.error('foo');

        // Assert
        verify(
          () => logCommand(
            '[error] foo',
            level: Level.error.value,
          ),
        ).called(1);
      });
    });

    group('.wtf()', () {
      test('logs wtf message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectLinuxLoggerProduction.wtf('foo', {'code': 404}, stackTrace);

        // Assert
        verify(
          () => logCommand(
            '[wtf] foo',
            level: Level.wtf.value,
            error: {'code': 404},
            stackTrace: stackTrace,
          ),
        ).called(1);
      });

      test('logs wtf message without error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectLinuxLoggerProduction = _getProjectLinuxLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectLinuxLoggerProduction.wtf('foo');

        // Assert
        verify(
          () => logCommand(
            '[wtf] foo',
            level: Level.wtf.value,
          ),
        ).called(1);
      });
    });
  });
}
