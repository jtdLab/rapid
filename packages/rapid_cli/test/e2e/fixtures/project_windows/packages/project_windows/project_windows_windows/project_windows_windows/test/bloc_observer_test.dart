import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_windows/bloc_observer.dart';
import 'package:project_windows_logging/project_windows_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectWindowsBlocObserver _getProjectWindowsBlocObserver(
    ProjectWindowsLogger logger) {
  return ProjectWindowsBlocObserver(logger);
}

void main() {
  group('ProjectWindowsBlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = MockProjectWindowsLogger();

      // Act
      final projectWindowsBlocObserver = _getProjectWindowsBlocObserver(logger);

      // Act
      expect(projectWindowsBlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = MockProjectWindowsLogger();
      final projectWindowsBlocObserver = _getProjectWindowsBlocObserver(logger);

      // Act
      projectWindowsBlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = MockProjectWindowsLogger();
      final projectWindowsBlocObserver = _getProjectWindowsBlocObserver(logger);

      // Act
      projectWindowsBlocObserver.onEvent(MockBloc(), 88);

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
      final logger = MockProjectWindowsLogger();
      final projectWindowsBlocObserver = _getProjectWindowsBlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      projectWindowsBlocObserver.onChange(MockBloc(), change);

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
      final logger = MockProjectWindowsLogger();
      final projectWindowsBlocObserver = _getProjectWindowsBlocObserver(logger);

      // Act
      projectWindowsBlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

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
      final logger = MockProjectWindowsLogger();
      final projectWindowsBlocObserver = _getProjectWindowsBlocObserver(logger);

      // Act
      projectWindowsBlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
