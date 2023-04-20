import 'package:bloc_test/bloc_test.dart';
import 'package:example_di/example_di.dart';
import 'package:example_domain/example_domain.dart';
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

    testWidgets('renders correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(
        initialRoutes: [
          const SignUpRoute(),
        ],
        locale: const Locale('en'),
      );

      // Assert
      expect(find.byType(ExampleScaffold), findsOneWidget);
      expect(find.text('Sign Up Page title for en'), findsOneWidget);
    });
  });
}
