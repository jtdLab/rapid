import 'package:project_none_logging/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

ProjectNoneLoggerDevelopment _getProjectNoneLoggerDevelopment({
  required LogCommand logCommand,
}) {
  return ProjectNoneLoggerDevelopment()..logCommandOverrides = logCommand;
}

ProjectNoneLoggerTest _getProjectNoneLoggerTest({
  required LogCommand logCommand,
}) {
  return ProjectNoneLoggerTest()..logCommandOverrides = logCommand;
}

ProjectNoneLoggerProduction _getProjectNoneLoggerProduction({
  required LogCommand logCommand,
}) {
  return ProjectNoneLoggerProduction()..logCommandOverrides = logCommand;
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

  group('ProjectNoneLoggerDevelopment', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerDevelopment.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerDevelopment.debug('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerDevelopment.debug('foo');

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerDevelopment.info('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerDevelopment.info('foo');

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerDevelopment.warning('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerDevelopment.warning('foo');

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerDevelopment.error('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerDevelopment.error('foo');

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerDevelopment.wtf('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerDevelopment = _getProjectNoneLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerDevelopment.wtf('foo');

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

  group('ProjectNoneLoggerTest', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerTest.verbose('foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerTest.debug('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerTest.debug('foo');

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerTest.info('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerTest.info('foo');

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerTest.warning('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerTest.warning('foo');

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerTest.error('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerTest.error('foo');

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerTest.wtf('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerTest = _getProjectNoneLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerTest.wtf('foo');

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

  group('ProjectNoneLoggerProduction', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerProduction.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerProduction.debug('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerProduction.debug('foo');

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerProduction.info('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerProduction.info('foo');

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerProduction.warning('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerProduction.warning('foo');

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerProduction.error('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerProduction.error('foo');

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectNoneLoggerProduction.wtf('foo', {'code': 404}, stackTrace);

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
        final projectNoneLoggerProduction = _getProjectNoneLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectNoneLoggerProduction.wtf('foo');

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
