import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_ios_app/example_ios_app.dart';
import 'package:example_ios_protected_router/example_ios_protected_router.dart';
import 'package:example_ui_ios/example_ui_ios.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp({
    required List<PageRouteInfo<dynamic>> initialRoutes,
    RootStackRouter? router,
    AutoRouterObserver? observer,
    Locale? locale,
    Brightness? brightness,
  }) async {
    await pumpWidget(
      App.test(
        locale: locale ?? const Locale('en'),
        localizationsDelegates: const [
          ExampleIosProtectedRouterLocalizations.delegate,
        ],
        router: router ?? ProtectedRouter(),
        initialRoutes: initialRoutes,
        routerObserver: observer,
        brightness: brightness,
      ),
    );
    await pump();
  }

  Future<void> pumpAppWidget({
    required Widget widget,
    Locale? locale,
    Brightness? brightness,
  }) async {
    await pumpWidget(
      App.testWidget(
        widget: widget,
        locale: locale ?? const Locale('en'),
        localizationsDelegates: const [
          ExampleIosProtectedRouterLocalizations.delegate,
        ],
        brightness: brightness,
      ),
    );
  }
}
