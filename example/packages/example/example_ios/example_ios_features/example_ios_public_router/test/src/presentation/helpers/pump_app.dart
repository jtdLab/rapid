import 'package:auto_route/auto_route.dart';
import 'package:example_ios_app/example_ios_app.dart';
import 'package:example_ios_public_router/example_ios_public_router.dart';
import 'package:example_ui_ios/example_ui_ios.dart';
import 'package:flutter_test/flutter_test.dart';

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
        localizationsDelegate: ExampleIosPublicRouterLocalizations.delegate,
        router: router ?? PublicRouter(),
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
        localizationsDelegate: ExampleIosPublicRouterLocalizations.delegate,
        brightness: brightness,
      ),
    );
  }
}
