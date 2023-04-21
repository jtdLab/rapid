import 'package:example_di/example_di.dart';
import 'package:example_ios_login_page/example_ios_login_page.dart';
import 'package:example_ios_public_router/src/presentation/presentation.dart';
import 'package:example_ios_sign_up_page/example_ios_sign_up_page.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../mocks.dart';
import 'helpers/helpers.dart';

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
      // Act
      await tester.pumpApp(
        initialRoutes: [
          _publicRouterRoute(),
        ],
      );

      // Assert
      final pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);
      expect(
        find.ancestor(of: pageViewFinder, matching: find.byType(LoginPage)),
        findsOneWidget,
      );
    });
  });
}
