import 'package:flutter_test/flutter_test.dart';
import 'package:example_ios_sign_up_page/src/presentation/presentation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';

import 'helpers/helpers.dart';

void main() {
  group('SignUpPage', () {
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
