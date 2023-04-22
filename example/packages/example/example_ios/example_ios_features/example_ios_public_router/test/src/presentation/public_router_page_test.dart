import 'package:example_di/example_di.dart';
import 'package:example_ios_login_page/example_ios_login_page.dart';
import 'package:example_ios_public_router/src/presentation/presentation.dart';
import 'package:example_ios_sign_up_page/example_ios_sign_up_page.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_test/flutter_test.dart';

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

PublicRouterRoute _publicRouterRoute() {
  getIt.registerSingleton<LoginBloc>(MockLoginBloc());
  getIt.registerSingleton<SignUpBloc>(MockSignUpBloc());

  return const PublicRouterRoute();
}

void main() {
  group('PublicRouterPage', () {
    tearDown(() async {
      await getIt.reset();
    });

    testWidgets('renders correctly', (tester) async {
      await tester.setup();

      await tester.pumpApp(
        initialRoutes: [
          _publicRouterRoute(),
        ],
      );
      final pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);
      expect(
        find.descendant(of: pageViewFinder, matching: find.byType(LoginPage)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: pageViewFinder, matching: find.byType(SignUpPage)),
        findsNothing,
      );
    });

    testWidgets('renders correctly after swip left', (tester) async {
      await tester.setup();

      await tester.pumpApp(
        initialRoutes: [
          _publicRouterRoute(),
        ],
      );
      final screenCenter = tester.getCenter(find.byType(CupertinoPageScaffold));
      await tester.flingFrom(screenCenter, const Offset(-500, 0), 800);
      final pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);
      expect(
        find.descendant(of: pageViewFinder, matching: find.byType(SignUpPage)),
        findsOneWidget,
      );
      expect(
        find.descendant(of: pageViewFinder, matching: find.byType(LoginPage)),
        findsNothing,
      );
    });
  });
}
