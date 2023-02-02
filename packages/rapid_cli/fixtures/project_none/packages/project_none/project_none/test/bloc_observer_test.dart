import 'package:bloc/bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_none/bloc_observer.dart';
import 'package:project_none_logging/project_none_logging.dart';
import 'package:mocktail/mocktail.dart';

class _MockProjectNoneLogger extends Mock implements ProjectNoneLogger {}

class _MockBloc extends Mock implements Bloc {}

class _MockChange extends Mock implements Change {}

void main() {
  group('ProjectNoneBlocObserver', () {
    late ProjectNoneLogger logger;
    late ProjectNoneBlocObserver underTest;

    setUp(() {
      logger = _MockProjectNoneLogger();
      when(() => logger.debug(any())).thenReturn(null);
      underTest = ProjectNoneBlocObserver(logger);
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