import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_macos_macos_app/project_macos_macos_app.dart';
import 'package:project_macos_macos_home_page/project_macos_macos_home_page.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';

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
        localizationsDelegate: ProjectMacosMacosHomePageLocalizations.delegate,
        router: router ?? HomePageRouter(),
        initialRoutes: initialRoutes,
        routerObserver: observer,
        brightness: brightness,
      ),
    );
    await pump();
  }
}
