import 'package:flutter_test/flutter_test.dart';
import 'package:project_web/bloc_observer.dart';
import 'package:project_web_logging/project_web_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectWebBlocObserver _getProjectWebBlocObserver(ProjectWebLogger logger) {
  return ProjectWebBlocObserver(logger);
}

void main() {
  group('ProjectWebBlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = MockProjectWebLogger();

      // Act
      final projectWebBlocObserver = _getProjectWebBlocObserver(logger);

      // Act
      expect(projectWebBlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = MockProjectWebLogger();
      final projectWebBlocObserver = _getProjectWebBlocObserver(logger);

      // Act
      projectWebBlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = MockProjectWebLogger();
      final projectWebBlocObserver = _getProjectWebBlocObserver(logger);

      // Act
      projectWebBlocObserver.onEvent(MockBloc(), 88);

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
      final logger = MockProjectWebLogger();
      final projectWebBlocObserver = _getProjectWebBlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      projectWebBlocObserver.onChange(MockBloc(), change);

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
      final logger = MockProjectWebLogger();
      final projectWebBlocObserver = _getProjectWebBlocObserver(logger);

      // Act
      projectWebBlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

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
      final logger = MockProjectWebLogger();
      final projectWebBlocObserver = _getProjectWebBlocObserver(logger);

      // Act
      projectWebBlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
