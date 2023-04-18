import 'package:flutter_test/flutter_test.dart';
import 'package:example_windows/bloc_observer.dart';
import 'package:example_logging/example_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ExampleBlocObserver _getExampleBlocObserver(ExampleLogger logger) {
  return ExampleBlocObserver(logger);
}

void main() {
  group('ExampleBlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = MockExampleLogger();

      // Act
      final exampleBlocObserver = _getExampleBlocObserver(logger);

      // Act
      expect(exampleBlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleBlocObserver = _getExampleBlocObserver(logger);

      // Act
      exampleBlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleBlocObserver = _getExampleBlocObserver(logger);

      // Act
      exampleBlocObserver.onEvent(MockBloc(), 88);

      // Assert
      verify(
        () => logger.debug(
          'onEvent -- MockBloc\n'
          '\n'
          '88',
        ),
      ).called(1);
    });

    test('.onChange()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleBlocObserver = _getExampleBlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      exampleBlocObserver.onChange(MockBloc(), change);

      // Assert
      verify(
        () => logger.debug(
          'onChange -- MockBloc\n'
          '\n'
          'currentState: 88\n'
          'nextState: 888',
        ),
      ).called(1);
    });

    test('.onError()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleBlocObserver = _getExampleBlocObserver(logger);

      // Act
      exampleBlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

      // Assert
      verify(
        () => logger.debug(
          'onError -- MockBloc\n'
          '\n'
          'Instance of \'Error\'',
        ),
      ).called(1);
    });

    test('.onClose()', () {
      // Arrange
      final logger = MockExampleLogger();
      final exampleBlocObserver = _getExampleBlocObserver(logger);

      // Act
      exampleBlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
