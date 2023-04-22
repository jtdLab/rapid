import 'package:example_di/example_di.dart';
import 'package:example_ios_home_page/example_ios_home_page.dart';
import 'package:example_ios_protected_router/src/presentation/presentation.dart';
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

ProtectedRouterRoute _protectedRouterRoute() {
  getIt.registerSingleton<AuthGuard>(MockAuthGuard());

  return const ProtectedRouterRoute();
}

void main() {
  group('ProtectedRouterPage', () {
    tearDown(() async {
      await getIt.reset();
    });

    testWidgets('renders correctly', (tester) async {
      await tester.setup();

      await tester.pumpApp(
        initialRoutes: [
          _protectedRouterRoute(),
        ],
      );
      await tester.pump();
      expect(find.byType(HomePage), findsOneWidget);
    });
  });
}
