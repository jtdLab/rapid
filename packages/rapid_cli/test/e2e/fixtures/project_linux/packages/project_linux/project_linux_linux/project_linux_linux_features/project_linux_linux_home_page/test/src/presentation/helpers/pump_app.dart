import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_linux_linux_app/project_linux_linux_app.dart';
import 'package:project_linux_linux_home_page/project_linux_linux_home_page.dart';
import 'package:project_linux_ui_linux/project_linux_ui_linux.dart';

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp({
    required List<PageRouteInfo<dynamic>> initialRoutes,
    RootStackRouter? router,
    AutoRouterObserver? observer,
    Locale? locale,
    ThemeMode? themeMode,
  }) async {
    await pumpWidget(
      App.test(
        locale: locale ?? const Locale('en'),
        localizationsDelegate: ProjectLinuxLinuxHomePageLocalizations.delegate,
        router: router ?? HomePageRouter(),
        initialRoutes: initialRoutes,
        routerObserver: observer,
        themeMode: themeMode,
      ),
    );
    await pump();
  }

  Future<void> pumpAppWidget({
    required Widget widget,
    Locale? locale,
    ThemeMode? themeMode,
  }) async {
    await pumpWidget(
      App.testWidget(
        widget: widget,
        locale: locale ?? const Locale('en'),
        localizationsDelegate: ProjectLinuxLinuxHomePageLocalizations.delegate,
        themeMode: themeMode,
      ),
    );
  }
}
