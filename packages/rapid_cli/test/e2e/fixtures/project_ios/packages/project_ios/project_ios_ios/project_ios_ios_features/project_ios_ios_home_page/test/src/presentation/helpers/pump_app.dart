import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ios_app/project_ios_ios_app.dart';
import 'package:project_ios_ios_home_page/project_ios_ios_home_page.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';

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
        localizationsDelegate: ProjectIosIosHomePageLocalizations.delegate,
        router: router ?? HomePageRouter(),
        initialRoutes: initialRoutes,
        routerObserver: observer,
        brightness: brightness,
      ),
    );
    await pump();
  }
}
