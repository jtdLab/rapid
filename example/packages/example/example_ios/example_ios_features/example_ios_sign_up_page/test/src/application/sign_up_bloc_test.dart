import 'package:bloc_test/bloc_test.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_sign_up_page/src/application/application.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';

SignUpBloc _getSignUpBloc([IAuthService? authService]) {
  return SignUpBloc(authService ?? MockAuthService());
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
      final signUpBloc = _getSignUpBloc();

      //  Act + Assert
      expect(
        signUpBloc.state,
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

        test(
          'LoadFailure',
          () => performTest(
            const SignUpState.loadFailure(
              failure: AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                  .serverError(),
            ),
          ),
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

        test(
          'LoadFailure',
          () => performTest(
            const SignUpState.loadFailure(
              failure: AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                  .serverError(),
            ),
          ),
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

        test(
          'LoadFailure',
          () => performTest(
            const SignUpState.loadFailure(
              failure: AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                  .serverError(),
            ),
          ),
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

        test(
          'LoadFailure',
          () => performTest(
            const SignUpState.loadFailure(
              failure: AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                  .serverError(),
            ),
          ),
        );
      });
    });

    group('SignUpPressed', () {
      late IAuthService authService;

      setUp(() {
        authService = MockAuthService();
      });

      blocTest<SignUpBloc, SignUpState>(
        'emits [LoadInProgress, LoadSuccess] when sign up succeeds',
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

      group('emits [Initial] when', () {
        blocTest<SignUpBloc, SignUpState>(
          'email address is invalid',
          build: () => _getSignUpBloc(authService),
          seed: () => SignUpState.initial(
            emailAddress: EmailAddress('a'),
            username: Username('foo123bar'),
            password: Password('foo123'),
            passwordAgain: Password('foo123'),
            showErrorMessages: false,
          ),
          act: (bloc) => bloc.add(const SignUpEvent.signUpPressed()),
          expect: () => [
            SignUpState.initial(
              emailAddress: EmailAddress('a'),
              username: Username('foo123bar'),
              password: Password('foo123'),
              passwordAgain: Password('foo123'),
              showErrorMessages: true,
            ),
          ],
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

        blocTest<SignUpBloc, SignUpState>(
          'username is invalid',
          build: () => _getSignUpBloc(authService),
          seed: () => SignUpState.initial(
            emailAddress: EmailAddress('a.b@c'),
            username: Username('a'),
            password: Password('foo123'),
            passwordAgain: Password('foo123'),
            showErrorMessages: false,
          ),
          act: (bloc) => bloc.add(const SignUpEvent.signUpPressed()),
          expect: () => [
            SignUpState.initial(
              emailAddress: EmailAddress('a.b@c'),
              username: Username('a'),
              password: Password('foo123'),
              passwordAgain: Password('foo123'),
              showErrorMessages: true,
            ),
          ],
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

        blocTest<SignUpBloc, SignUpState>(
          'password is invalid',
          build: () => _getSignUpBloc(authService),
          seed: () => SignUpState.initial(
            emailAddress: EmailAddress('a.b@c'),
            username: Username('foo123bar'),
            password: Password('a'),
            passwordAgain: Password('foo123'),
            showErrorMessages: false,
          ),
          act: (bloc) => bloc.add(const SignUpEvent.signUpPressed()),
          expect: () => [
            SignUpState.initial(
              emailAddress: EmailAddress('a.b@c'),
              username: Username('foo123bar'),
              password: Password('a'),
              passwordAgain: Password('foo123'),
              showErrorMessages: true,
            ),
          ],
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

        blocTest<SignUpBloc, SignUpState>(
          'password and password again do not match',
          build: () => _getSignUpBloc(authService),
          seed: () => SignUpState.initial(
            emailAddress: EmailAddress('a.b@c'),
            username: Username('foo123bar'),
            password: Password('foo123'),
            passwordAgain: Password('bar123'),
            showErrorMessages: false,
          ),
          act: (bloc) => bloc.add(const SignUpEvent.signUpPressed()),
          expect: () => [
            SignUpState.initial(
              emailAddress: EmailAddress('a.b@c'),
              username: Username('foo123bar'),
              password: Password('foo123'),
              passwordAgain: Password('bar123'),
              showErrorMessages: true,
            ),
          ],
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
      });

      blocTest<SignUpBloc, SignUpState>(
        'emits [LoadInProgress, LoadFailure, Initial] when sign up fails',
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
                  .serverError(),
            ),
          );
        },
        build: () => _getSignUpBloc(authService),
        seed: () => SignUpState.initial(
          emailAddress: EmailAddress('a@b.c'),
          username: Username('foo123bar'),
          password: Password('foo123'),
          passwordAgain: Password('foo123'),
          showErrorMessages: false,
        ),
        act: (bloc) => bloc.add(const SignUpEvent.signUpPressed()),
        wait: const Duration(milliseconds: 500),
        expect: () => [
          const SignUpState.loadInProgress(),
          const SignUpState.loadFailure(
            failure: AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                .serverError(),
          ),
          SignUpState.initial(
            emailAddress: EmailAddress('a@b.c'),
            username: Username('foo123bar'),
            password: Password('foo123'),
            passwordAgain: Password('foo123'),
            showErrorMessages: true,
          ),
        ],
        verify: (_) {
          verify(
            () => authService.signUpWithEmailAndUsernameAndPassword(
              emailAddress: EmailAddress('a@b.c'),
              username: Username('foo123bar'),
              password: Password('foo123'),
            ),
          ).called(1);
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

        test(
          'LoadFailure',
          () => performTest(
            const SignUpState.loadFailure(
              failure: AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                  .serverError(),
            ),
          ),
        );
      });
    });
  });
}
