import 'package:example_ios_public_router/src/presentation/presentation.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_test/flutter_test.dart';

import 'helpers/helpers.dart';

void main() {
  group('PublicRouter', () {
    testWidgets('renders correctly (en)', (tester) async {
      // Act
      await tester.pumpApp(
        initialRoutes: [
          const PublicRouterRoute(),
        ],
        locale: const Locale('en'),
      );

      // Assert
      expect(find.byType(ExampleScaffold), findsOneWidget);
      expect(find.text('Public Router title for en'), findsOneWidget);
    });
  });
}
