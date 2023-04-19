import 'package:bloc_test/bloc_test.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_sign_up_page/src/application/application.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

SignUpBloc _getSignUpBloc([IAuthService? authService]) {
  return SignUpBloc(authService ?? MockIAuthService());
}

void main() {
  group('SignUpBloc', () {
    setUpAll(() {
      registerFallbackValue(EmailAddress.empty());
      registerFallbackValue(Username.empty());
      registerFallbackValue(Password.empty());
    });

    test('has initial state Initial', () {
      // Arrange
      final loginBloc = _getSignUpBloc();

      //  Act + Assert
      expect(
        loginBloc.state,
        SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );
    });

    group('EmailChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits Initial with updated email',
        build: () => _getSignUpBloc(),
        act: (bloc) => bloc.add(
          const SignUpEvent.emailChanged(newEmailAddress: 'a'),
        ),
        expect: () => [
          SignUpState.initial(
            emailAddress: EmailAddress('a'),
            username: Username.empty(),
            password: Password.empty(),
            passwordAgain: Password.empty(),
            showErrorMessages: false,
          ),
        ],
      );

      group('emits nothing when state is', () {
        void performTest(SignUpState initialState) =>
            testBloc<SignUpBloc, SignUpState>(
              build: () => _getSignUpBloc(),
              seed: () => initialState,
              act: (bloc) => bloc.add(
                const SignUpEvent.emailChanged(newEmailAddress: 'a'),
              ),
              expect: () => [],
            );

        test(
          'LoadInProgress',
          () => performTest(const SignUpState.loadInProgress()),
        );

        test(
          'LoadSuccess',
          () => performTest(const SignUpState.loadSuccess()),
        );

        // TODO failure = null
        test(
          'LoadFailure',
          () => performTest(const SignUpState.loadFailure(failure: null)),
        );
      });
    });

    group('UsernameChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits Initial with updated username',
        build: () => _getSignUpBloc(),
        act: (bloc) => bloc.add(
          const SignUpEvent.usernameChanged(newUsername: 'a'),
        ),
        expect: () => [
          SignUpState.initial(
            emailAddress: EmailAddress.empty(),
            username: Username('a'),
            password: Password.empty(),
            passwordAgain: Password.empty(),
            showErrorMessages: false,
          ),
        ],
      );

      group('emits nothing when state is', () {
        void performTest(SignUpState initialState) =>
            testBloc<SignUpBloc, SignUpState>(
              build: () => _getSignUpBloc(),
              seed: () => initialState,
              act: (bloc) => bloc.add(
                const SignUpEvent.usernameChanged(newUsername: 'a'),
              ),
              expect: () => [],
            );

        test(
          'LoadInProgress',
          () => performTest(const SignUpState.loadInProgress()),
        );

        test(
          'LoadSuccess',
          () => performTest(const SignUpState.loadSuccess()),
        );

        // TODO failure = null
        test(
          'LoadFailure',
          () => performTest(const SignUpState.loadFailure(failure: null)),
        );
      });
    });

    group('PasswordChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits Initial with updated password',
        build: () => _getSignUpBloc(),
        act: (bloc) => bloc.add(
          const SignUpEvent.passwordChanged(newPassword: 'a'),
        ),
        expect: () => [
          SignUpState.initial(
            emailAddress: EmailAddress.empty(),
            username: Username.empty(),
            password: Password('a'),
            passwordAgain: Password.empty(),
            showErrorMessages: false,
          ),
        ],
      );

      group('emits nothing when state is', () {
        void performTest(SignUpState initialState) =>
            testBloc<SignUpBloc, SignUpState>(
              build: () => _getSignUpBloc(),
              seed: () => initialState,
              act: (bloc) => bloc.add(
                const SignUpEvent.passwordChanged(newPassword: 'a'),
              ),
              expect: () => [],
            );

        test(
          'LoadInProgress',
          () => performTest(const SignUpState.loadInProgress()),
        );

        test(
          'LoadSuccess',
          () => performTest(const SignUpState.loadSuccess()),
        );

        // TODO failure = null
        test(
          'LoadFailure',
          () => performTest(const SignUpState.loadFailure(failure: null)),
        );
      });
    });

    group('PasswordAgainChanged', () {
      blocTest<SignUpBloc, SignUpState>(
        'emits Initial with updated password',
        build: () => _getSignUpBloc(),
        act: (bloc) => bloc.add(
          const SignUpEvent.passwordAgainChanged(newPasswordAgain: 'a'),
        ),
        expect: () => [
          SignUpState.initial(
            emailAddress: EmailAddress.empty(),
            username: Username.empty(),
            password: Password.empty(),
            passwordAgain: Password('a'),
            showErrorMessages: false,
          ),
        ],
      );

      group('emits nothing when state is', () {
        void performTest(SignUpState initialState) =>
            testBloc<SignUpBloc, SignUpState>(
              build: () => _getSignUpBloc(),
              seed: () => initialState,
              act: (bloc) => bloc.add(
                const SignUpEvent.passwordAgainChanged(newPasswordAgain: 'a'),
              ),
              expect: () => [],
            );

        test(
          'LoadInProgress',
          () => performTest(const SignUpState.loadInProgress()),
        );

        test(
          'LoadSuccess',
          () => performTest(const SignUpState.loadSuccess()),
        );

        // TODO failure = null
        test(
          'LoadFailure',
          () => performTest(const SignUpState.loadFailure(failure: null)),
        );
      });
    });

    group('SignUpPressed', () {
      late IAuthService authService;

      setUp(() {
        authService = MockIAuthService();
      });

      blocTest<SignUpBloc, SignUpState>(
        'emits [LoadInProgress, LoadSuccess] when login succeeds',
        setUp: () {
          when(
            () => authService.signUpWithEmailAndUsernameAndPassword(
              emailAddress: any(named: 'emailAddress'),
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => right(unit));
        },
        build: () => _getSignUpBloc(authService),
        seed: () => SignUpState.initial(
          emailAddress: EmailAddress('a@b.c'),
          username: Username('foo123bar'),
          password: Password('123foo345'),
          passwordAgain: Password('123foo345'),
          showErrorMessages: false,
        ),
        act: (bloc) => bloc.add(const SignUpEvent.signUpPressed()),
        wait: const Duration(milliseconds: 500),
        expect: () => const [
          SignUpState.loadInProgress(),
          SignUpState.loadSuccess(),
        ],
        verify: (_) {
          verify(
            () => authService.signUpWithEmailAndUsernameAndPassword(
              emailAddress: EmailAddress('a@b.c'),
              username: Username('foo123bar'),
              password: Password('123foo345'),
            ),
          ).called(1);
        },
      );

      blocTest<SignUpBloc, SignUpState>(
        'emits [Initial] when login fails',
        setUp: () {
          when(
            () => authService.signUpWithEmailAndUsernameAndPassword(
              emailAddress: any(named: 'emailAddress'),
              username: any(named: 'username'),
              password: any(named: 'password'),
            ),
          ).thenAnswer(
            (_) async => left(
              const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                  .invalidEmail(),
            ),
          );
        },
        build: () => _getSignUpBloc(authService),
        seed: () => SignUpState.initial(
          emailAddress: EmailAddress('a'),
          username: Username('b'),
          password: Password('c'),
          passwordAgain: Password('c'),
          showErrorMessages: false,
        ),
        act: (bloc) => bloc.add(const SignUpEvent.signUpPressed()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          SignUpState.initial(
            emailAddress: EmailAddress('a'),
            username: Username('b'),
            password: Password('c'),
            passwordAgain: Password('c'),
            showErrorMessages: true,
          ),
        ],
        verify: (_) {
          verifyNever(
            () => authService.signUpWithEmailAndUsernameAndPassword(
              emailAddress: EmailAddress('a'),
              username: Username('b'),
              password: Password('c'),
            ),
          );
        },
      );

      group('does nothing when state is', () {
        void performTest(SignUpState initialState) =>
            testBloc<SignUpBloc, SignUpState>(
              build: () => _getSignUpBloc(authService),
              seed: () => initialState,
              act: (bloc) => bloc.add(const SignUpEvent.signUpPressed()),
              expect: () => [],
              verify: (_) {
                verifyNever(
                  () => authService.signUpWithEmailAndUsernameAndPassword(
                    emailAddress: any(named: 'emailAddress'),
                    username: any(named: 'username'),
                    password: any(named: 'password'),
                  ),
                );
              },
            );

        test(
          'LoadInProgress',
          () => performTest(const SignUpState.loadInProgress()),
        );

        test(
          'LoadSuccess',
          () => performTest(const SignUpState.loadSuccess()),
        );

        // TODO failure = null
        test(
          'LoadFailure',
          () => performTest(const SignUpState.loadFailure(failure: null)),
        );
      });
    });
  });
}
