import 'package:flutter_test/flutter_test.dart';
import 'package:example_ios_protected_router/src/presentation/presentation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';

import 'helpers/helpers.dart';

void main() {
  group('ProtectedRouter', () {
    testWidgets('renders correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(
        initialRoutes: [
          const ProtectedRouterRoute(),
        ],
        locale: const Locale('en'),
      );

      // Assert
      expect(find.byType(ExampleScaffold), findsOneWidget);
      expect(find.text('Protected Router title for en'), findsOneWidget);
    });
  });
}
