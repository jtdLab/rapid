import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:project_windows_windows_app/project_windows_windows_app.dart';
import 'package:project_windows_windows_home_page/project_windows_windows_home_page.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';

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
        localizationsDelegate:
            ProjectWindowsWindowsHomePageLocalizations.delegate,
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
        localizationsDelegate:
            ProjectWindowsWindowsHomePageLocalizations.delegate,
        themeMode: themeMode,
      ),
    );
  }
}
