import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_android_app/project_android_android_app.dart';
import 'package:project_android_android_home_page/project_android_android_home_page.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

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
            ProjectAndroidAndroidHomePageLocalizations.delegate,
        router: router ?? HomePageRouter(),
        initialRoutes: initialRoutes,
        routerObserver: observer,
        themeMode: themeMode,
      ),
    );
    await pump();
  }
}
