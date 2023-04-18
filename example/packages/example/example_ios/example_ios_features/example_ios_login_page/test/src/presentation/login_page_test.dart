import 'package:flutter_test/flutter_test.dart';
import 'package:example_ios_login_page/src/presentation/presentation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';

import 'helpers/helpers.dart';

void main() {
  group('LoginPage', () {
    testWidgets('renders correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(
        initialRoutes: [
          const LoginRoute(),
        ],
        locale: const Locale('en'),
      );

      // Assert
      expect(find.byType(ExampleScaffold), findsOneWidget);
      expect(find.text('Login Page title for en'), findsOneWidget);
    });
  });
}
