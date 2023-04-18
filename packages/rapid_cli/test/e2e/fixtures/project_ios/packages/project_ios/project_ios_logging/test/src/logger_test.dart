import 'package:project_ios_logging/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

ProjectIosLoggerDevelopment _getProjectIosLoggerDevelopment({
  required LogCommand logCommand,
}) {
  return ProjectIosLoggerDevelopment()..logCommandOverrides = logCommand;
}

ProjectIosLoggerTest _getProjectIosLoggerTest({
  required LogCommand logCommand,
}) {
  return ProjectIosLoggerTest()..logCommandOverrides = logCommand;
}

ProjectIosLoggerProduction _getProjectIosLoggerProduction({
  required LogCommand logCommand,
}) {
  return ProjectIosLoggerProduction()..logCommandOverrides = logCommand;
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

  group('ProjectIosLoggerDevelopment', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerDevelopment.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerDevelopment.debug('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerDevelopment.debug('foo');

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerDevelopment.info('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerDevelopment.info('foo');

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerDevelopment.warning('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerDevelopment.warning('foo');

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerDevelopment.error('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerDevelopment.error('foo');

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerDevelopment.wtf('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerDevelopment = _getProjectIosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerDevelopment.wtf('foo');

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

  group('ProjectIosLoggerTest', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerTest.verbose('foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerTest.debug('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerTest.debug('foo');

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerTest.info('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerTest.info('foo');

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerTest.warning('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerTest.warning('foo');

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerTest.error('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerTest.error('foo');

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerTest.wtf('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerTest = _getProjectIosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerTest.wtf('foo');

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

  group('ProjectIosLoggerProduction', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerProduction.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerProduction.debug('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerProduction.debug('foo');

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerProduction.info('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerProduction.info('foo');

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerProduction.warning('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerProduction.warning('foo');

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerProduction.error('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerProduction.error('foo');

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectIosLoggerProduction.wtf('foo', {'code': 404}, stackTrace);

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
        final projectIosLoggerProduction = _getProjectIosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectIosLoggerProduction.wtf('foo');

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
