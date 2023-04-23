import 'package:bloc_test/bloc_test.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
import 'package:example_ios_sign_up_page/src/application/application.dart';
import 'package:example_ios_sign_up_page/src/presentation/presentation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks.dart';
import 'helpers/helpers.dart';

extension on WidgetTester {
  Future<void> setup() async {
    // set screen size to common phone size
    await binding.setSurfaceSize(const Size(414.0, 896.0));
    // scale down font size to remove overflow errors caused by Ahem
    binding.platformDispatcher.textScaleFactorTestValue = 0.8;
  }
}

Widget _signUpPage(SignUpBloc signUpBloc) {
  return BlocProvider(
    create: (_) => signUpBloc,
    child: const SignUpPage(),
  );
}

Widget _signUpPageWrapped() {
  return Builder(
    builder: (context) => const SignUpPage().wrappedRoute(context),
  );
}

void main() {
  group('SignUpPage', () {
    setUpAll(() {
      registerFallbackValue(FakeBuildContext());
    });

    tearDown(() async {
      await getIt.reset();
    });

    testWidgets('injects SignUpBloc', (tester) async {
      await tester.setup();

      final signUpBloc = MockSignUpBloc();
      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      getIt.registerSingleton<SignUpBloc>(signUpBloc);
      await tester.pumpAppWidget(
        widget: _signUpPageWrapped(),
      );
      final context = tester.element(find.byType(SignUpPage));
      expect(context.read<SignUpBloc>(), signUpBloc);
    });

    group('renders correctly', () {
      group('when [SignUpInitial]', () {
        testWidgets('(en)', (tester) async {
          await tester.setup();

          final signUpBloc = MockSignUpBloc();
          whenListen(
            signUpBloc,
            const Stream<SignUpState>.empty(),
            initialState: SignUpState.initial(
              emailAddress: EmailAddress.empty(),
              username: Username.empty(),
              password: Password.empty(),
              passwordAgain: Password.empty(),
              showErrorMessages: false,
            ),
          );

          await tester.pumpAppWidget(
            widget: _signUpPage(signUpBloc),
            locale: const Locale('en'),
          );
          expect(find.byType(ExampleScaffold), findsOneWidget);
          expect(find.byType(RapidLogo), findsOneWidget);
          expect(find.text('Sign up').first, findsOneWidget);
          expect(
            find.widgetWithText(ExampleTextField, 'Email address'),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(ExampleTextField, 'Username'),
            findsOneWidget,
          );
          final passwordTextFieldFinder =
              find.widgetWithText(ExampleTextField, 'Password');
          expect(passwordTextFieldFinder, findsOneWidget);
          expect(
            find.descendant(
              of: passwordTextFieldFinder,
              matching: find.byIcon(CupertinoIcons.eye_slash),
            ),
            findsOneWidget,
          );
          final passwordTextField =
              tester.widget<ExampleTextField>(passwordTextFieldFinder);
          expect(passwordTextField.obscureText, true);
          final passwordAgainTextFieldFinder =
              find.widgetWithText(ExampleTextField, 'Password again');
          expect(passwordAgainTextFieldFinder, findsOneWidget);
          expect(
            find.descendant(
              of: passwordAgainTextFieldFinder,
              matching: find.byIcon(CupertinoIcons.eye_slash),
            ),
            findsOneWidget,
          );
          final passwordAgainTextField =
              tester.widget<ExampleTextField>(passwordAgainTextFieldFinder);
          expect(passwordAgainTextField.obscureText, true);
          expect(
            find.widgetWithText(ExamplePrimaryButton, 'Sign up'),
            findsOneWidget,
          );
          expect(find.text('Already have an account?'), findsOneWidget);
          expect(
            find.widgetWithText(ExampleLinkButton, 'Login'),
            findsOneWidget,
          );
        });
      });

      group('when [SignUpInitial] showing error messages', () {
        testWidgets('(en)', (tester) async {
          await tester.setup();

          final signUpBloc = MockSignUpBloc();
          whenListen(
            signUpBloc,
            const Stream<SignUpState>.empty(),
            initialState: SignUpState.initial(
              emailAddress: EmailAddress.empty(),
              username: Username.empty(),
              password: Password.empty(),
              passwordAgain: Password.empty(),
              showErrorMessages: true,
            ),
          );

          await tester.pumpAppWidget(
            widget: _signUpPage(signUpBloc),
            locale: const Locale('en'),
          );
          expect(find.byType(ExampleScaffold), findsOneWidget);
          expect(find.byType(RapidLogo), findsOneWidget);
          expect(find.text('Sign up').first, findsOneWidget);
          final emailTextFieldFinder =
              find.widgetWithText(ExampleTextField, 'Email address');
          expect(emailTextFieldFinder, findsOneWidget);
          final emailTextField =
              tester.widget<ExampleTextField>(emailTextFieldFinder);
          expect(emailTextField.obscureText, false);
          expect(emailTextField.isValid, false);
          expect(emailTextField.errorMessage, 'Invalid email.');
          final usernameTextFieldFinder =
              find.widgetWithText(ExampleTextField, 'Username');
          expect(usernameTextFieldFinder, findsOneWidget);
          final usernameTextField =
              tester.widget<ExampleTextField>(usernameTextFieldFinder);
          expect(usernameTextField.obscureText, false);
          expect(usernameTextField.isValid, false);
          expect(
            usernameTextField.errorMessage,
            'Invalid username. Please use 3-15 characters and only include letters, numbers, ., -, and _.',
          );
          final passwordTextFieldFinder =
              find.widgetWithText(ExampleTextField, 'Password');
          expect(passwordTextFieldFinder, findsOneWidget);
          expect(
            find.descendant(
              of: passwordTextFieldFinder,
              matching: find.byIcon(CupertinoIcons.eye_slash),
            ),
            findsOneWidget,
          );
          final passwordTextField =
              tester.widget<ExampleTextField>(passwordTextFieldFinder);
          expect(passwordTextField.obscureText, true);
          expect(passwordTextField.isValid, false);
          expect(
            passwordTextField.errorMessage,
            'Invalid password. Please use 6-32 non-white space characters.',
          );
          final passwordAgainTextFieldFinder =
              find.widgetWithText(ExampleTextField, 'Password again');
          expect(passwordAgainTextFieldFinder, findsOneWidget);
          expect(
            find.descendant(
              of: passwordAgainTextFieldFinder,
              matching: find.byIcon(CupertinoIcons.eye_slash),
            ),
            findsOneWidget,
          );
          final passwordAgainTextField =
              tester.widget<ExampleTextField>(passwordAgainTextFieldFinder);
          expect(passwordAgainTextField.obscureText, true);
          expect(passwordAgainTextField.isValid, false);
          expect(
              passwordAgainTextField.errorMessage, 'Passwords don\'t match.');
          expect(
            find.widgetWithText(ExamplePrimaryButton, 'Sign up'),
            findsOneWidget,
          );
          expect(find.text('Already have an account?'), findsOneWidget);
          expect(
            find.widgetWithText(ExampleLinkButton, 'Login'),
            findsOneWidget,
          );
        });
      });

      group('when [SignUpLoadInProgress]', () {
        testWidgets('(en)', (tester) async {
          await tester.setup();

          final signUpBloc = MockSignUpBloc();
          whenListen(
            signUpBloc,
            const Stream<SignUpState>.empty(),
            initialState: const SignUpState.loadInProgress(),
          );

          await tester.pumpAppWidget(
            widget: _signUpPage(signUpBloc),
            locale: const Locale('en'),
          );
          expect(find.byType(ExampleScaffold), findsOneWidget);
          expect(find.byType(RapidLogo), findsOneWidget);
          expect(find.text('Sign up').first, findsOneWidget);
          expect(
            find.widgetWithText(ExampleTextField, 'Email address'),
            findsOneWidget,
          );
          expect(
            find.widgetWithText(ExampleTextField, 'Username'),
            findsOneWidget,
          );
          final passwordTextFieldFinder =
              find.widgetWithText(ExampleTextField, 'Password');
          expect(passwordTextFieldFinder, findsOneWidget);
          expect(
            find.descendant(
              of: passwordTextFieldFinder,
              matching: find.byIcon(CupertinoIcons.eye_slash),
            ),
            findsOneWidget,
          );
          final passwordTextField =
              tester.widget<ExampleTextField>(passwordTextFieldFinder);
          expect(passwordTextField.obscureText, true);
          final passwordAgainTextFieldFinder =
              find.widgetWithText(ExampleTextField, 'Password again');
          expect(passwordAgainTextFieldFinder, findsOneWidget);
          expect(
            find.descendant(
              of: passwordAgainTextFieldFinder,
              matching: find.byIcon(CupertinoIcons.eye_slash),
            ),
            findsOneWidget,
          );
          final passwordAgainTextField =
              tester.widget<ExampleTextField>(passwordAgainTextFieldFinder);
          expect(passwordAgainTextField.obscureText, true);
          expect(
            find.descendant(
              of: find.byType(ExamplePrimaryButton),
              matching: find.byType(CupertinoActivityIndicator),
            ),
            findsOneWidget,
          );
          expect(find.text('Already have an account?'), findsOneWidget);
          expect(
            find.widgetWithText(ExampleLinkButton, 'Login'),
            findsOneWidget,
          );
        });
      });
    });

    testWidgets('adds EmailChanged to SignUpBloc', (tester) async {
      await tester.setup();

      final signUpBloc = MockSignUpBloc();

      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      await tester.enterText(
        find.widgetWithText(ExampleTextField, 'Email address'),
        'a',
      );
      verify(
        () => signUpBloc.add(
          const SignUpEvent.emailChanged(newEmailAddress: 'a'),
        ),
      );
    });

    testWidgets('adds UsernameChanged to SignUpBloc', (tester) async {
      await tester.setup();

      final signUpBloc = MockSignUpBloc();

      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      await tester.enterText(
        find.widgetWithText(ExampleTextField, 'Username'),
        'a',
      );
      verify(
        () => signUpBloc.add(
          const SignUpEvent.usernameChanged(newUsername: 'a'),
        ),
      );
    });

    testWidgets('adds PasswordChanged to SignUpBloc', (tester) async {
      await tester.setup();

      final signUpBloc = MockSignUpBloc();
      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      await tester.enterText(
        find.widgetWithText(ExampleTextField, 'Password'),
        'a',
      );
      verify(
        () =>
            signUpBloc.add(const SignUpEvent.passwordChanged(newPassword: 'a')),
      );
    });

    testWidgets('adds PasswordAgainChanged to SignUpBloc', (tester) async {
      await tester.setup();

      final signUpBloc = MockSignUpBloc();
      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      await tester.enterText(
        find.widgetWithText(ExampleTextField, 'Password again'),
        'a',
      );
      verify(
        () => signUpBloc.add(
          const SignUpEvent.passwordAgainChanged(newPasswordAgain: 'a'),
        ),
      );
    });

    testWidgets('adds SignUpPressed to SignUpBloc', (tester) async {
      await tester.setup();

      final signUpBloc = MockSignUpBloc();
      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      await tester.tap(
        find.widgetWithText(ExamplePrimaryButton, 'Sign up'),
      );
      verify(
        () => signUpBloc.add(const SignUpEvent.signUpPressed()),
      );
    });

    testWidgets('replaces with protected router when [SignUpLoadSuccess]',
        (tester) async {
      await tester.setup();

      final protectedRouterNavigator = MockProtectedRouterNavigator();
      getIt.registerSingleton<IProtectedRouterNavigator>(
        protectedRouterNavigator,
      );
      final signUpBloc = MockSignUpBloc();
      whenListen(
        signUpBloc,
        Stream<SignUpState>.value(const SignUpState.loadSuccess()),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      verify(() => protectedRouterNavigator.replace(any())).called(1);
    });

    testWidgets('navigates to login page when go-to-login button is pressed',
        (tester) async {
      await tester.setup();

      final loginPageNavigator = MockLoginPageNavigator();
      getIt.registerSingleton<ILoginPageNavigator>(loginPageNavigator);
      final signUpBloc = MockSignUpBloc();
      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      await tester.tap(
        find.widgetWithText(ExampleLinkButton, 'Login'),
      );
      verify(() => loginPageNavigator.navigate(any())).called(1);
    });

    group('shows toast when [SignUpLoadFailure]', () {
      Future<void> performTest(
        WidgetTester tester, {
        required Locale locale,
        required AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
            failure,
        required String expectedMessage,
      }) async {
        await tester.setup();

        final signUpBloc = MockSignUpBloc();
        whenListen(
          signUpBloc,
          Stream<SignUpState>.value(SignUpState.loadFailure(failure: failure)),
          initialState: SignUpState.initial(
            emailAddress: EmailAddress.empty(),
            username: Username.empty(),
            password: Password.empty(),
            passwordAgain: Password.empty(),
            showErrorMessages: false,
          ),
        );

        await tester.pumpAppWidget(
          widget: _signUpPage(signUpBloc),
          locale: locale,
        );
        await tester.pumpAndSettle();
        final exampleToastFinder = find.descendant(
          of: find.byType(ExampleToast),
          matching: find.text(expectedMessage),
        );
        expect(exampleToastFinder, findsOneWidget);

        await tester.pump(const Duration(seconds: 2));
        await tester.pumpAndSettle();
        expect(exampleToastFinder, findsNothing);
      }

      group('with server error', () {
        testWidgets(
          '(en)',
          (tester) => performTest(
            tester,
            locale: const Locale('en'),
            failure:
                const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                    .serverError(),
            expectedMessage: 'Server error. Try again later.',
          ),
        );
      });

      group('with email already in use', () {
        testWidgets(
          '(en)',
          (tester) => performTest(
            tester,
            locale: const Locale('en'),
            failure:
                const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                    .emailAlreadyInUse(),
            expectedMessage: 'Email already in use.',
          ),
        );
      });

      group('with username already in use', () {
        testWidgets(
          '(en)',
          (tester) => performTest(
            tester,
            locale: const Locale('en'),
            failure:
                const AuthServiceSignUpWithEmailAndUsernameAndPasswordFailure
                    .usernameAlreadyInUse(),
            expectedMessage: 'Username already in use.',
          ),
        );
      });
    });

    testWidgets('unfocuses text fields when screen is tapped', (tester) async {
      Future<void> verifyUnfocusesTextField(Finder finder) async {
        await tester.tap(finder);
        await tester.pump();
        expect(
          FocusScope.of(tester.element(finder)).hasFocus,
          true,
        );
        await tester.tapAt(const Offset(1, 1));
        await tester.pump();
        expect(
          FocusScope.of(tester.element(finder)).hasFocus,
          false,
        );
      }

      await tester.setup();

      final signUpBloc = MockSignUpBloc();
      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      await verifyUnfocusesTextField(
        find.widgetWithText(ExampleTextField, 'Email address'),
      );
      await verifyUnfocusesTextField(
        find.widgetWithText(ExampleTextField, 'Username'),
      );
      await verifyUnfocusesTextField(
        find.widgetWithText(ExampleTextField, 'Password'),
      );
      await verifyUnfocusesTextField(
        find.widgetWithText(ExampleTextField, 'Password again'),
      );
    });

    testWidgets('changes focus of text fields correctly when enter is pressed',
        (tester) async {
      await tester.setup();

      final signUpBloc = MockSignUpBloc();
      whenListen(
        signUpBloc,
        const Stream<SignUpState>.empty(),
        initialState: SignUpState.initial(
          emailAddress: EmailAddress.empty(),
          username: Username.empty(),
          password: Password.empty(),
          passwordAgain: Password.empty(),
          showErrorMessages: false,
        ),
      );

      await tester.pumpAppWidget(
        widget: _signUpPage(signUpBloc),
      );
      final emailTextFieldFinder =
          find.widgetWithText(ExampleTextField, 'Email address');
      final usernameTextFieldFinder =
          find.widgetWithText(ExampleTextField, 'Username');
      final passwordTextFieldFinder =
          find.widgetWithText(ExampleTextField, 'Password');
      final passwordAgainTextFieldFinder =
          find.widgetWithText(ExampleTextField, 'Password again');
      await tester.tap(emailTextFieldFinder);
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expect(
        FocusScope.of(tester.element(usernameTextFieldFinder)).hasFocus,
        true,
      );
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expect(
        FocusScope.of(tester.element(passwordTextFieldFinder)).hasFocus,
        true,
      );
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expect(
        FocusScope.of(tester.element(passwordAgainTextFieldFinder)).hasFocus,
        true,
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(
        FocusScope.of(tester.element(passwordAgainTextFieldFinder)).hasFocus,
        false,
      );
    });
  });
}
