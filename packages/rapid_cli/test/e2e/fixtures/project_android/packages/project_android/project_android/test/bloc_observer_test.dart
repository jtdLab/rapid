import 'package:bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android/bloc_observer.dart';
import 'package:project_android_logging/project_android_logging.dart';
import 'package:mocktail/mocktail.dart';

class _MockProjectAndroidLogger extends Mock implements ProjectAndroidLogger {}

class _MockBloc extends Mock implements Bloc {}

class _MockChange extends Mock implements Change {}

void main() {
  group('ProjectAndroidBlocObserver', () {
    late ProjectAndroidLogger logger;
    late ProjectAndroidBlocObserver underTest;

    setUp(() {
      logger = _MockProjectAndroidLogger();
      when(() => logger.debug(any())).thenReturn(null);
      underTest = ProjectAndroidBlocObserver(logger);
    });

    group('.', () {
      test('assigns params correctly', () {
        // Assert
        expect(underTest.logger, logger);
      });
    });

    group('onCreate', () {
      late BlocBase bloc;

      setUp(() {
        bloc = _MockBloc();
      });

      test('logs debug message', () {
        // Act
        underTest.onCreate(bloc);

        // Assert
        verify(() => logger.debug('onCreate -- _MockBloc')).called(1);
      });
    });

    group('onEvent', () {
      late Bloc bloc;
      late Object? event;

      setUp(() {
        bloc = _MockBloc();
        event = 88;
      });

      test('logs debug message', () {
        // Act
        underTest.onEvent(bloc, event);

        // Assert
        verify(
          () => logger.debug(
            'onEvent -- _MockBloc\n'
            '\n'
            '$event',
          ),
        ).called(1);
      });
    });

    group('onChange', () {
      late BlocBase bloc;
      late dynamic currentState;
      late dynamic nextState;
      late Change change;

      setUp(() {
        bloc = _MockBloc();
        currentState = 88;
        nextState = 888;
        change = _MockChange();
        when(() => change.currentState).thenReturn(currentState);
        when(() => change.nextState).thenReturn(nextState);
      });

      test('logs debug message', () {
        // Act
        underTest.onChange(bloc, change);

        // Assert
        verify(
          () => logger.debug(
            'onChange -- _MockBloc\n'
            '\n'
            'currentState: $currentState\n'
            'nextState: $nextState',
          ),
        ).called(1);
      });
    });

    group('onError', () {
      late BlocBase bloc;
      late Object error;
      late StackTrace stackTrace;

      setUp(() {
        bloc = _MockBloc();
        error = Error();
        stackTrace = StackTrace.empty;
      });

      test('logs debug message', () {
        // Act
        underTest.onError(bloc, error, stackTrace);

        // Assert
        verify(
          () => logger.debug(
            'onError -- _MockBloc\n'
            '\n'
            '$error',
          ),
        ).called(1);
      });
    });

    group('onClose', () {
      late BlocBase bloc;

      setUp(() {
        bloc = _MockBloc();
      });

      test('logs debug message', () {
        // Act
        underTest.onClose(bloc);

        // Assert
        verify(() => logger.debug('onClose -- _MockBloc')).called(1);
      });
    });
  });
}
