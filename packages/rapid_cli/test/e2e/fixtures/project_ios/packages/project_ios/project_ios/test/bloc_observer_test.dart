import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios/bloc_observer.dart';
import 'package:project_ios_logging/project_ios_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectIosBlocObserver _getProjectIosBlocObserver(ProjectIosLogger logger) {
  return ProjectIosBlocObserver(logger);
}

void main() {
  group('ProjectIosBlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = MockProjectIosLogger();

      // Act
      final projectIosBlocObserver = _getProjectIosBlocObserver(logger);

      // Act
      expect(projectIosBlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = MockProjectIosLogger();
      final projectIosBlocObserver = _getProjectIosBlocObserver(logger);

      // Act
      projectIosBlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = MockProjectIosLogger();
      final projectIosBlocObserver = _getProjectIosBlocObserver(logger);

      // Act
      projectIosBlocObserver.onEvent(MockBloc(), 88);

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
      final logger = MockProjectIosLogger();
      final projectIosBlocObserver = _getProjectIosBlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      projectIosBlocObserver.onChange(MockBloc(), change);

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
      final logger = MockProjectIosLogger();
      final projectIosBlocObserver = _getProjectIosBlocObserver(logger);

      // Act
      projectIosBlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

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
      final logger = MockProjectIosLogger();
      final projectIosBlocObserver = _getProjectIosBlocObserver(logger);

      // Act
      projectIosBlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
