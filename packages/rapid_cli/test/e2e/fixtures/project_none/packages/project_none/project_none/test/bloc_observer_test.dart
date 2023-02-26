import 'package:flutter_test/flutter_test.dart';
import 'package:project_none/bloc_observer.dart';
import 'package:project_none_logging/project_none_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectNoneBlocObserver _getProjectNoneBlocObserver(ProjectNoneLogger logger) {
  return ProjectNoneBlocObserver(logger);
}

void main() {
  group('ProjectNoneBlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = MockProjectNoneLogger();

      // Act
      final projectNoneBlocObserver = _getProjectNoneBlocObserver(logger);

      // Act
      expect(projectNoneBlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = MockProjectNoneLogger();
      final projectNoneBlocObserver = _getProjectNoneBlocObserver(logger);

      // Act
      projectNoneBlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = MockProjectNoneLogger();
      final projectNoneBlocObserver = _getProjectNoneBlocObserver(logger);

      // Act
      projectNoneBlocObserver.onEvent(MockBloc(), 88);

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
      final logger = MockProjectNoneLogger();
      final projectNoneBlocObserver = _getProjectNoneBlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      projectNoneBlocObserver.onChange(MockBloc(), change);

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
      final logger = MockProjectNoneLogger();
      final projectNoneBlocObserver = _getProjectNoneBlocObserver(logger);

      // Act
      projectNoneBlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

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
      final logger = MockProjectNoneLogger();
      final projectNoneBlocObserver = _getProjectNoneBlocObserver(logger);

      // Act
      projectNoneBlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
