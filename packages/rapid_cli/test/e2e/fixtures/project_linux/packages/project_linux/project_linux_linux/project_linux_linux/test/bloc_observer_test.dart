import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_linux/bloc_observer.dart';
import 'package:project_linux_logging/project_linux_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectLinuxBlocObserver _getProjectLinuxBlocObserver(
    ProjectLinuxLogger logger) {
  return ProjectLinuxBlocObserver(logger);
}

void main() {
  group('ProjectLinuxBlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = MockProjectLinuxLogger();

      // Act
      final projectLinuxBlocObserver = _getProjectLinuxBlocObserver(logger);

      // Act
      expect(projectLinuxBlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = MockProjectLinuxLogger();
      final projectLinuxBlocObserver = _getProjectLinuxBlocObserver(logger);

      // Act
      projectLinuxBlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = MockProjectLinuxLogger();
      final projectLinuxBlocObserver = _getProjectLinuxBlocObserver(logger);

      // Act
      projectLinuxBlocObserver.onEvent(MockBloc(), 88);

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
      final logger = MockProjectLinuxLogger();
      final projectLinuxBlocObserver = _getProjectLinuxBlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      projectLinuxBlocObserver.onChange(MockBloc(), change);

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
      final logger = MockProjectLinuxLogger();
      final projectLinuxBlocObserver = _getProjectLinuxBlocObserver(logger);

      // Act
      projectLinuxBlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

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
      final logger = MockProjectLinuxLogger();
      final projectLinuxBlocObserver = _getProjectLinuxBlocObserver(logger);

      // Act
      projectLinuxBlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
