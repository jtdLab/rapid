import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_android_app/project_android_android_app.dart';
import 'package:project_android_android_routing/project_android_android_routing.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';

class _TestRouter extends Router {
  _TestRouter({
    required this.route,
    required this.widget,
  });

  final PageRouteInfo route;
  final Widget widget;

  @override
  Map<String, PageFactory> get pagesMap {
    return {
      ...super.pagesMap,
      route.routeName: (routeData) {
        return MaterialPageX<dynamic>(
          routeData: routeData,
          child: widget,
        );
      },
    };
  }
}

extension WidgetTesterX on WidgetTester {
  /// Pump [widget] as a child of [route] wrapped with a [ProjectAndroidApp].
  ///
  /// Specify [routerObserver] to test routing.
  /// To do so pass a mock instance of [AutoRouterObserver] and verify calls to its methods.
  ///
  /// Example:
  ///
  /// ```dart
  /// testWidgets('my test', (tester) async {
  ///   // Arrange
  ///   final observer = MockAutoRouterObserver();
  ///   await tester.pumpApp(
  ///     const MyPageRoute(),
  ///     const MyWidget(),
  ///     routerObserver: observer,
  ///   );
  ///
  ///   // Act
  ///   // some action
  ///
  ///   // Assert
  ///   verify(
  ///     () => observer.didPush(
  ///       any(that: isRoute('SomePageRoute')),
  ///       any(),
  ///     ),
  ///   ).called(1);
  /// });
  /// ```
  ///
  /// Specify [locale] to test localization.
  ///
  /// Specify [themeMode] to test different appearances.
  Future<void> pumpApp(
    PageRouteInfo route,
    Widget widget, {
    AutoRouterObserver? routerObserver,
    Locale? locale,
    ThemeMode? themeMode,
  }) async {
    await pumpWidget(
      App.test(
        router: _TestRouter(
          route: route,
          widget: widget,
        ),
        initialRoutes: [route],
        routerObserver: routerObserver,
        locale: locale,
        themeMode: themeMode,
      ),
    );
    await pump();
  }
}
