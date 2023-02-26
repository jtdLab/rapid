import 'package:flutter_test/flutter_test.dart';

import 'package:project_macos_macos_app/project_macos_macos_app.dart';
import 'package:project_macos_macos_routing/project_macos_macos_routing.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';

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
  /// Pump [widget] as a child of [route] wrapped with a [ProjectMacosApp].
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
    Brightness? brightness,
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
        brightness: brightness,
      ),
    );
    await pump();
  }
}
