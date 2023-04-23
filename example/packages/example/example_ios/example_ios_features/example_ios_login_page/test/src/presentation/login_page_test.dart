import 'package:bloc_test/bloc_test.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain/example_domain.dart';
import 'package:example_ios_login_page/src/application/application.dart';
import 'package:example_ios_login_page/src/presentation/presentation.dart';
import 'package:example_ios_navigation/example_ios_navigation.dart';
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

Widget _loginPage(LoginBloc loginBloc) {
  return BlocProvider(
    create: (_) => loginBloc,
    child: const LoginPage(),
  );
}

Widget _loginPageWrapped() {
  return Builder(
    builder: (context) => const LoginPage().wrappedRoute(context),
  );
}

void main() {
  group('LoginPage', () {
    setUpAll(() {
      registerFallbackValue(FakeBuildContext());
    });

    tearDown(() async {
      await getIt.reset();
    });

    testWidgets('injects LoginBloc', (tester) async {
      await tester.setup();

      final loginBloc = MockLoginBloc();
      whenListen(
        loginBloc,
        const Stream<LoginState>.empty(),
        initialState: LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );

      getIt.registerSingleton<LoginBloc>(loginBloc);
      await tester.pumpAppWidget(
        widget: _loginPageWrapped(),
      );
      final context = tester.element(find.byType(LoginPage));
      expect(context.read<LoginBloc>(), loginBloc);
    });

    group('renders correctly', () {
      group('when [LoginInitial]', () {
        testWidgets('(en)', (tester) async {
          await tester.setup();

          final loginBloc = MockLoginBloc();
          whenListen(
            loginBloc,
            const Stream<LoginState>.empty(),
            initialState: LoginState.initial(
              username: Username.empty(),
              password: Password.empty(),
            ),
          );

          await tester.pumpAppWidget(
            widget: _loginPage(loginBloc),
            locale: const Locale('en'),
          );
          expect(find.byType(ExampleScaffold), findsOneWidget);
          expect(find.byType(RapidLogo), findsOneWidget);
          expect(find.text('Login').first, findsOneWidget);
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
          expect(
            find.widgetWithText(ExamplePrimaryButton, 'Login'),
            findsOneWidget,
          );
          expect(find.text('Don\'t have an account?'), findsOneWidget);
          expect(
            find.widgetWithText(ExampleLinkButton, 'Sign up now'),
            findsOneWidget,
          );
        });
      });

      group('when [LoginLoadInProgress]', () {
        testWidgets('(en)', (tester) async {
          await tester.setup();

          final loginBloc = MockLoginBloc();
          whenListen(
            loginBloc,
            const Stream<LoginState>.empty(),
            initialState: const LoginState.loadInProgress(),
          );

          await tester.pumpAppWidget(
            widget: _loginPage(loginBloc),
            locale: const Locale('en'),
          );
          expect(find.byType(ExampleScaffold), findsOneWidget);
          expect(find.byType(RapidLogo), findsOneWidget);
          expect(find.text('Login').first, findsOneWidget);
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
          expect(
            find.descendant(
              of: find.byType(ExamplePrimaryButton),
              matching: find.byType(CupertinoActivityIndicator),
            ),
            findsOneWidget,
          );
          expect(find.text('Don\'t have an account?'), findsOneWidget);
          expect(
            find.widgetWithText(ExampleLinkButton, 'Sign up now'),
            findsOneWidget,
          );
        });
      });
    });

    testWidgets('adds UsernameChanged to LoginBloc', (tester) async {
      await tester.setup();

      final loginBloc = MockLoginBloc();
      whenListen(
        loginBloc,
        const Stream<LoginState>.empty(),
        initialState: LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );

      await tester.pumpAppWidget(
        widget: _loginPage(loginBloc),
      );
      await tester.enterText(
        find.widgetWithText(ExampleTextField, 'Username'),
        'a',
      );
      verify(
        () => loginBloc.add(const LoginEvent.usernameChanged(newUsername: 'a')),
      );
    });

    testWidgets('adds PasswordChanged to LoginBloc', (tester) async {
      await tester.setup();

      final loginBloc = MockLoginBloc();
      whenListen(
        loginBloc,
        const Stream<LoginState>.empty(),
        initialState: LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );

      await tester.pumpAppWidget(
        widget: _loginPage(loginBloc),
      );
      await tester.enterText(
        find.widgetWithText(ExampleTextField, 'Password'),
        'a',
      );
      verify(
        () => loginBloc.add(const LoginEvent.passwordChanged(newPassword: 'a')),
      );
    });

    testWidgets('adds LoginPressed to LoginBloc', (tester) async {
      await tester.setup();

      final loginBloc = MockLoginBloc();
      whenListen(
        loginBloc,
        const Stream<LoginState>.empty(),
        initialState: LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );

      await tester.pumpAppWidget(
        widget: _loginPage(loginBloc),
      );
      await tester.tap(
        find.widgetWithText(ExamplePrimaryButton, 'Login'),
      );
      verify(
        () => loginBloc.add(const LoginEvent.loginPressed()),
      );
    });

    testWidgets('replaces with protected router when [LoginLoadSuccess]',
        (tester) async {
      await tester.setup();

      final protectedRouterNavigator = MockProtectedRouterNavigator();
      getIt.registerSingleton<IProtectedRouterNavigator>(
        protectedRouterNavigator,
      );
      final loginBloc = MockLoginBloc();
      whenListen(
        loginBloc,
        Stream<LoginState>.value(const LoginState.loadSuccess()),
        initialState: LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );

      await tester.pumpAppWidget(
        widget: _loginPage(loginBloc),
      );
      verify(() => protectedRouterNavigator.replace(any())).called(1);
    });

    testWidgets(
        'navigates to sign up page when go-to-sign-up button is pressed',
        (tester) async {
      await tester.setup();

      final signUpPageNavigator = MockSignUpPageNavigator();
      getIt.registerSingleton<ISignUpPageNavigator>(signUpPageNavigator);
      final loginBloc = MockLoginBloc();
      whenListen(
        loginBloc,
        const Stream<LoginState>.empty(),
        initialState: LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );

      await tester.pumpAppWidget(
        widget: _loginPage(loginBloc),
      );
      await tester.tap(
        find.widgetWithText(ExampleLinkButton, 'Sign up now'),
      );
      verify(() => signUpPageNavigator.navigate(any())).called(1);
    });

    group('shows toast when [LoginLoadFailure]', () {
      Future<void> performTest(
        WidgetTester tester, {
        required Locale locale,
        required AuthServiceLoginWithUsernameAndPasswordFailure failure,
        required String expectedMessage,
      }) async {
        await tester.setup();

        final loginBloc = MockLoginBloc();
        whenListen(
          loginBloc,
          Stream<LoginState>.value(LoginState.loadFailure(failure: failure)),
          initialState: LoginState.initial(
            username: Username.empty(),
            password: Password.empty(),
          ),
        );

        await tester.pumpAppWidget(
          widget: _loginPage(loginBloc),
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

      group('with invalid username and password combination', () {
        testWidgets(
          '(en)',
          (tester) => performTest(
            tester,
            locale: const Locale('en'),
            failure: const AuthServiceLoginWithUsernameAndPasswordFailure
                .invalidUsernameAndPasswordCombination(),
            expectedMessage: 'Invalid username or password.',
          ),
        );
      });

      group('with server error', () {
        testWidgets(
          '(en)',
          (tester) => performTest(
            tester,
            locale: const Locale('en'),
            failure: const AuthServiceLoginWithUsernameAndPasswordFailure
                .serverError(),
            expectedMessage: 'Server error. Try again later.',
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

      final loginBloc = MockLoginBloc();
      whenListen(
        loginBloc,
        const Stream<LoginState>.empty(),
        initialState: LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );

      await tester.pumpAppWidget(
        widget: _loginPage(loginBloc),
      );
      await verifyUnfocusesTextField(
        find.widgetWithText(ExampleTextField, 'Username'),
      );
      await verifyUnfocusesTextField(
        find.widgetWithText(ExampleTextField, 'Password'),
      );
    });

    testWidgets('changes focus of text fields correctly when enter is pressed',
        (tester) async {
      await tester.setup();

      final loginBloc = MockLoginBloc();
      whenListen(
        loginBloc,
        const Stream<LoginState>.empty(),
        initialState: LoginState.initial(
          username: Username.empty(),
          password: Password.empty(),
        ),
      );

      await tester.pumpAppWidget(
        widget: _loginPage(loginBloc),
      );
      final usernameTextFieldFinder =
          find.widgetWithText(ExampleTextField, 'Username');
      final passwordTextFieldFinder =
          find.widgetWithText(ExampleTextField, 'Password');
      await tester.tap(usernameTextFieldFinder);
      await tester.pump();
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();
      expect(
        FocusScope.of(tester.element(passwordTextFieldFinder)).hasFocus,
        true,
      );
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();
      expect(
        FocusScope.of(tester.element(passwordTextFieldFinder)).hasFocus,
        false,
      );
    });
  });
}
