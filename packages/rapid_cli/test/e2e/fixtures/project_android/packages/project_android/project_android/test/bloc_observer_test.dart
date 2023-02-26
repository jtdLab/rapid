import 'package:flutter_test/flutter_test.dart';
import 'package:project_android/bloc_observer.dart';
import 'package:project_android_logging/project_android_logging.dart';
import 'package:mocktail/mocktail.dart';

import 'mocks.dart';

ProjectAndroidBlocObserver _getProjectAndroidBlocObserver(
    ProjectAndroidLogger logger) {
  return ProjectAndroidBlocObserver(logger);
}

void main() {
  group('ProjectAndroidBlocObserver', () {
    test('.()', () {
      // Arrange
      final logger = MockProjectAndroidLogger();

      // Act
      final projectAndroidBlocObserver = _getProjectAndroidBlocObserver(logger);

      // Act
      expect(projectAndroidBlocObserver.logger, logger);
    });

    test('.onCreate()', () {
      // Arrange
      final logger = MockProjectAndroidLogger();
      final projectAndroidBlocObserver = _getProjectAndroidBlocObserver(logger);

      // Act
      projectAndroidBlocObserver.onCreate(MockBloc());

      // Assert
      verify(() => logger.debug('onCreate -- MockBloc')).called(1);
    });

    test('.onEvent()', () {
      // Arrange
      final logger = MockProjectAndroidLogger();
      final projectAndroidBlocObserver = _getProjectAndroidBlocObserver(logger);

      // Act
      projectAndroidBlocObserver.onEvent(MockBloc(), 88);

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
      final logger = MockProjectAndroidLogger();
      final projectAndroidBlocObserver = _getProjectAndroidBlocObserver(logger);

      // Act
      final change = MockChange();
      when(() => change.currentState).thenReturn(88);
      when(() => change.nextState).thenReturn(888);
      projectAndroidBlocObserver.onChange(MockBloc(), change);

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
      final logger = MockProjectAndroidLogger();
      final projectAndroidBlocObserver = _getProjectAndroidBlocObserver(logger);

      // Act
      projectAndroidBlocObserver.onError(MockBloc(), Error(), StackTrace.empty);

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
      final logger = MockProjectAndroidLogger();
      final projectAndroidBlocObserver = _getProjectAndroidBlocObserver(logger);

      // Act
      projectAndroidBlocObserver.onClose(MockBloc());

      // Assert
      verify(() => logger.debug('onClose -- MockBloc')).called(1);
    });
  });
}
