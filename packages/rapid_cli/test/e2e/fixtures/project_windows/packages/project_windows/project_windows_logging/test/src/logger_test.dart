import 'package:project_windows_logging/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

ProjectWindowsLoggerDevelopment _getProjectWindowsLoggerDevelopment({
  required LogCommand logCommand,
}) {
  return ProjectWindowsLoggerDevelopment()..logCommandOverrides = logCommand;
}

ProjectWindowsLoggerTest _getProjectWindowsLoggerTest({
  required LogCommand logCommand,
}) {
  return ProjectWindowsLoggerTest()..logCommandOverrides = logCommand;
}

ProjectWindowsLoggerProduction _getProjectWindowsLoggerProduction({
  required LogCommand logCommand,
}) {
  return ProjectWindowsLoggerProduction()..logCommandOverrides = logCommand;
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

  group('ProjectWindowsLoggerDevelopment', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerDevelopment.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerDevelopment.debug('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerDevelopment.debug('foo');

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerDevelopment.info('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerDevelopment.info('foo');

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerDevelopment.warning(
            'foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerDevelopment.warning('foo');

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerDevelopment.error('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerDevelopment.error('foo');

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerDevelopment.wtf('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerDevelopment =
            _getProjectWindowsLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerDevelopment.wtf('foo');

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

  group('ProjectWindowsLoggerTest', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerTest.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerTest.debug('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerTest.debug('foo');

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerTest.info('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerTest.info('foo');

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerTest.warning('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerTest.warning('foo');

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerTest.error('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerTest.error('foo');

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerTest.wtf('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerTest = _getProjectWindowsLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerTest.wtf('foo');

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

  group('ProjectWindowsLoggerProduction', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerProduction.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerProduction.debug('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerProduction.debug('foo');

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerProduction.info('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerProduction.info('foo');

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerProduction.warning(
            'foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerProduction.warning('foo');

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerProduction.error('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerProduction.error('foo');

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectWindowsLoggerProduction.wtf('foo', {'code': 404}, stackTrace);

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
        final projectWindowsLoggerProduction =
            _getProjectWindowsLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectWindowsLoggerProduction.wtf('foo');

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
