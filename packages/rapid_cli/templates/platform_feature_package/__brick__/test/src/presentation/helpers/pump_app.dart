import 'package:flutter_test/flutter_test.dart';{{#android}}import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';import 'package:{{project_name}}_android_routing/{{project_name}}_android_routing.dart';import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';{{/android}}
{{#ios}}import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';import 'package:{{project_name}}_ios_routing/{{project_name}}_ios_routing.dart';import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';{{/ios}}
{{#linux}}import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';import 'package:{{project_name}}_linux_routing/{{project_name}}_linux_routing.dart';import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';{{/linux}}
{{#macos}}import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';import 'package:{{project_name}}_macos_routing/{{project_name}}_macos_routing.dart';import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';{{/macos}}
{{#web}}import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';import 'package:{{project_name}}_web_routing/{{project_name}}_web_routing.dart';import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';{{/web}}
{{#windows}}import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';import 'package:{{project_name}}_windows_routing/{{project_name}}_windows_routing.dart';import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';{{/windows}}

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
  /// Pump [widget] as a child of [route] wrapped with a [{{project_name.pascalCase()}}App].
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
    {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}Brightness? brightness{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}},
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
        {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}brightness: brightness{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}},
      ),
    );
    await pump();
  }
}
