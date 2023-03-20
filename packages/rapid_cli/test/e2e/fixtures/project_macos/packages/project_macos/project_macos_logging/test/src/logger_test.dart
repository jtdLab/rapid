import 'package:project_macos_logging/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

ProjectMacosLoggerDevelopment _getProjectMacosLoggerDevelopment({
  required LogCommand logCommand,
}) {
  return ProjectMacosLoggerDevelopment()..logCommandOverrides = logCommand;
}

ProjectMacosLoggerTest _getProjectMacosLoggerTest({
  required LogCommand logCommand,
}) {
  return ProjectMacosLoggerTest()..logCommandOverrides = logCommand;
}

ProjectMacosLoggerProduction _getProjectMacosLoggerProduction({
  required LogCommand logCommand,
}) {
  return ProjectMacosLoggerProduction()..logCommandOverrides = logCommand;
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

  group('ProjectMacosLoggerDevelopment', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerDevelopment.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerDevelopment.debug('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerDevelopment.debug('foo');

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerDevelopment.info('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerDevelopment.info('foo');

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerDevelopment.warning('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerDevelopment.warning('foo');

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerDevelopment.error('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerDevelopment.error('foo');

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerDevelopment.wtf('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerDevelopment = _getProjectMacosLoggerDevelopment(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerDevelopment.wtf('foo');

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

  group('ProjectMacosLoggerTest', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerTest.verbose('foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerTest.debug('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerTest.debug('foo');

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerTest.info('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerTest.info('foo');

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerTest.warning('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerTest.warning('foo');

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerTest.error('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerTest.error('foo');

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerTest.wtf('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerTest = _getProjectMacosLoggerTest(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerTest.wtf('foo');

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

  group('ProjectMacosLoggerProduction', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerProduction.verbose(
            'foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerProduction.debug('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerProduction.debug('foo');

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerProduction.info('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerProduction.info('foo');

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerProduction.warning('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerProduction.warning('foo');

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerProduction.error('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerProduction.error('foo');

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        final stackTrace = MockStackTrace();
        projectMacosLoggerProduction.wtf('foo', {'code': 404}, stackTrace);

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
        final projectMacosLoggerProduction = _getProjectMacosLoggerProduction(
          logCommand: logCommand,
        );

        // Act
        projectMacosLoggerProduction.wtf('foo');

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
