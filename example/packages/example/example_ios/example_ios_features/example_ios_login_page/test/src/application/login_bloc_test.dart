import 'package:bloc_test/bloc_test.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_login_page/src/application/application.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

LoginBloc _getLoginBloc([IAuthService? authService]) {
  return LoginBloc(authService ?? MockIAuthService());
}

void main() {
  group('LoginBloc', () {
    setUpAll(() {
      registerFallbackValue(Username.empty());
      registerFallbackValue(Password.empty());
    });

    test('has initial state Initial', () {
      // Arrange
      final loginBloc = _getLoginBloc();

      //  Act + Assert
      expect(
        loginBloc.state,
        LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );
    });

    group('UsernameChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits Initial with updated username',
        build: () => _getLoginBloc(),
        act: (bloc) => bloc.add(
          const LoginEvent.usernameChanged(newUsername: 'a'),
        ),
        expect: () => [
          LoginState.initial(
            username: Username('a'),
            password: Password.empty(),
          ),
        ],
      );

      group('emits nothing when state is', () {
        void performTest(LoginState initialState) =>
            testBloc<LoginBloc, LoginState>(
              build: () => _getLoginBloc(),
              seed: () => initialState,
              act: (bloc) => bloc.add(
                const LoginEvent.usernameChanged(newUsername: 'a'),
              ),
              expect: () => [],
            );

        test(
          'LoadInProgress',
          () => performTest(const LoginState.loadInProgress()),
        );

        test(
          'LoadSuccess',
          () => performTest(const LoginState.loadSuccess()),
        );

        // TODO failure = null
        test(
          'LoadFailure',
          () => performTest(const LoginState.loadFailure(failure: null)),
        );
      });
    });

    group('PasswordChanged', () {
      blocTest<LoginBloc, LoginState>(
        'emits Initial with updated password',
        build: () => _getLoginBloc(),
        act: (bloc) => bloc.add(
          const LoginEvent.passwordChanged(newPassword: 'a'),
        ),
        expect: () => [
          LoginState.initial(
            username: Username.empty(),
            password: Password('a'),
          ),
        ],
      );

      group('emits nothing when state is', () {
        void performTest(LoginState initialState) =>
            testBloc<LoginBloc, LoginState>(
              build: () => _getLoginBloc(),
              seed: () => initialState,
              act: (bloc) => bloc.add(
                const LoginEvent.passwordChanged(newPassword: 'a'),
              ),
              expect: () => [],
            );

        test(
          'LoadInProgress',
          () => performTest(const LoginState.loadInProgress()),
        );

        test(
          'LoadSuccess',
          () => performTest(const LoginState.loadSuccess()),
        );

        // TODO failure = null
        test(
          'LoadFailure',
          () => performTest(const LoginState.loadFailure(failure: null)),
        );
      });
    });

    group('LoginPressed', () {
      late IAuthService authService;

      setUp(() {
        authService = MockIAuthService();
      });

      blocTest<LoginBloc, LoginState>(
        'emits [LoadInProgress, LoadSuccess] when login succeeds',
        setUp: () {
          when(
            () => authService.loginWithUsernameAndPassword(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => right(unit));
        },
        build: () => _getLoginBloc(authService),
        seed: () => LoginState.initial(
          username: Username('foo'),
          password: Password('bar'),
        ),
        act: (bloc) => bloc.add(const LoginEvent.loginPressed()),
        wait: const Duration(milliseconds: 500),
        expect: () => const [
          LoginState.loadInProgress(),
          LoginState.loadSuccess(),
        ],
        verify: (_) {
          verify(
            () => authService.loginWithUsernameAndPassword(
              username: Username('foo'),
              password: Password('bar'),
            ),
          ).called(1);
        },
      );

      blocTest<LoginBloc, LoginState>(
        'emits [LoadInProgress, LoadFailure, Initial] when login fails',
        setUp: () {
          when(
            () => authService.loginWithUsernameAndPassword(
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => left(
              const AuthServiceLoginWithUsernameAndPasswordFailure
                  .invalidUsernameAndPasswordCombination(),
            ),
          );
        },
        build: () => _getLoginBloc(authService),
        seed: () => LoginState.initial(
          username: Username('a'),
          password: Password('b'),
        ),
        act: (bloc) => bloc.add(const LoginEvent.loginPressed()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          const LoginState.loadInProgress(),
          const LoginState.loadFailure(
            failure: AuthServiceLoginWithUsernameAndPasswordFailure
                .invalidUsernameAndPasswordCombination(),
          ),
          LoginState.initial(
            username: Username('a'),
            password: Password('b'),
          ),
        ],
        verify: (_) {
          verify(
            () => authService.loginWithUsernameAndPassword(
              username: Username('a'),
              password: Password('b'),
            ),
          ).called(1);
        },
      );

      group('does nothing when state is', () {
        void performTest(LoginState initialState) =>
            testBloc<LoginBloc, LoginState>(
              build: () => _getLoginBloc(authService),
              seed: () => initialState,
              act: (bloc) => bloc.add(const LoginEvent.loginPressed()),
              expect: () => [],
              verify: (_) {
                verifyNever(
                  () => authService.loginWithUsernameAndPassword(
                    username: any(named: 'username'),
                    password: any(named: 'password'),
                  ),
                );
              },
            );

        test(
          'LoadInProgress',
          () => performTest(const LoginState.loadInProgress()),
        );

        test(
          'LoadSuccess',
          () => performTest(const LoginState.loadSuccess()),
        );

        // TODO failure = null
        test(
          'LoadFailure',
          () => performTest(const LoginState.loadFailure(failure: null)),
        );
      });
    });
  });
}
