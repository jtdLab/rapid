import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos/bloc_observer.dart';
import 'package:project_macos_logging/project_macos_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectMacosBlocObserver _getProjectMacosBlocObserver(
    ProjectMacosLogger logger) {
  return ProjectMacosBlocObserver(logger);
}

void main() {
  group('ProjectMacosBlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = MockProjectMacosLogger();

      // Act
      final projectMacosBlocObserver = _getProjectMacosBlocObserver(logger);

      // Act
      expect(projectMacosBlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = MockProjectMacosLogger();
      final projectMacosBlocObserver = _getProjectMacosBlocObserver(logger);

      // Act
      projectMacosBlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = MockProjectMacosLogger();
      final projectMacosBlocObserver = _getProjectMacosBlocObserver(logger);

      // Act
      projectMacosBlocObserver.onEvent(MockBloc(), 88);

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
      final logger = MockProjectMacosLogger();
      final projectMacosBlocObserver = _getProjectMacosBlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      projectMacosBlocObserver.onChange(MockBloc(), change);

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
      final logger = MockProjectMacosLogger();
      final projectMacosBlocObserver = _getProjectMacosBlocObserver(logger);

      // Act
      projectMacosBlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

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
      final logger = MockProjectMacosLogger();
      final projectMacosBlocObserver = _getProjectMacosBlocObserver(logger);

      // Act
      projectMacosBlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
