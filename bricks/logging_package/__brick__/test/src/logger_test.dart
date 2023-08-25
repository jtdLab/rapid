import 'package:{{project_name}}_logging/src/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

import '../mocks.dart';

{{project_name.pascalCase()}}LoggerDevelopment _get{{project_name.pascalCase()}}LoggerDevelopment({
  required LogCommand logCommand,
}) {
  return {{project_name.pascalCase()}}LoggerDevelopment()..logCommandOverrides = logCommand;
}

{{project_name.pascalCase()}}LoggerTest _get{{project_name.pascalCase()}}LoggerTest({
  required LogCommand logCommand,
}) {
  return {{project_name.pascalCase()}}LoggerTest()..logCommandOverrides = logCommand;
}

{{project_name.pascalCase()}}LoggerProduction _get{{project_name.pascalCase()}}LoggerProduction({
  required LogCommand logCommand,
}) {
  return {{project_name.pascalCase()}}LoggerProduction()..logCommandOverrides = logCommand;
}

void main() {
  group('Level', () {
    group('.verbose', () {
      const verbose = Level.verbose;

      test('.value', () {
        expect(verbose.value, 0);
      });
    });

    group('.debug', () {
      const debug = Level.debug;

      test('.value', () {
        expect(debug.value, 500);
      });
    });

    group('.info', () {
      const info = Level.info;

      test('.value', () {
        expect(info.value, 800);
      });
    });

    group('.warning', () {
      const warning = Level.warning;

      test('.value', () {
        expect(warning.value, 900);
      });
    });

    group('.error', () {
      const error = Level.error;

      test('.value', () {
        expect(error.value, 1000);
      });
    });

    group('.wtf', () {
      const wtf = Level.wtf;

      test('.value', () {
        expect(wtf.value, 1200);
      });
    });

    group('.nothing', () {
      const nothing = Level.nothing;

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

  group('{{project_name.pascalCase()}}LoggerDevelopment', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerDevelopment.verbose('foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerDevelopment.debug('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerDevelopment.debug('foo');

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerDevelopment.info('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerDevelopment.info('foo');

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerDevelopment.warning('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerDevelopment.warning('foo');

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerDevelopment.error('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerDevelopment.error('foo');

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerDevelopment.wtf('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerDevelopment = _get{{project_name.pascalCase()}}LoggerDevelopment(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerDevelopment.wtf('foo');

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

  group('{{project_name.pascalCase()}}LoggerTest', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerTest.verbose('foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerTest.debug('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerTest.debug('foo');

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerTest.info('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerTest.info('foo');

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerTest.warning('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerTest.warning('foo');

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerTest.error('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerTest.error('foo');

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerTest.wtf('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerTest = _get{{project_name.pascalCase()}}LoggerTest(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerTest.wtf('foo');

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

  group('{{project_name.pascalCase()}}LoggerProduction', () {
    group('.verbose()', () {
      test('does nothing', () {
        // Arrange
        final logCommand = MockLogCommand();
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerProduction.verbose('foo', {'code': 404}, MockStackTrace());

        // Assert
        verifyNever(() => logCommand(any()));
      });
    });

    group('.debug()', () {
      test('logs debug message with error and stackTrace', () {
        // Arrange
        final logCommand = MockLogCommand();
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerProduction.debug('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerProduction.debug('foo');

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerProduction.info('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerProduction.info('foo');

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerProduction.warning('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerProduction.warning('foo');

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerProduction.error('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerProduction.error('foo');

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        final stackTrace = MockStackTrace();
        {{project_name.camelCase()}}LoggerProduction.wtf('foo', {'code': 404}, stackTrace);

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
        final {{project_name.camelCase()}}LoggerProduction = _get{{project_name.pascalCase()}}LoggerProduction(
          logCommand: logCommand.call,
        );

        // Act
        {{project_name.camelCase()}}LoggerProduction.wtf('foo');

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
