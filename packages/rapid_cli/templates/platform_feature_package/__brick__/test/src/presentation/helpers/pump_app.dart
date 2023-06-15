{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}import 'package:flutter_test/flutter_test.dart';{{#android}}import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';import 'package:{{project_name}}_android_{{name.snakeCase()}}/{{project_name}}_android_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';{{/android}}
{{#ios}}import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';import 'package:{{project_name}}_ios_{{name.snakeCase()}}/{{project_name}}_ios_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';{{/ios}}
{{#linux}}import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';import 'package:{{project_name}}_linux_{{name.snakeCase()}}/{{project_name}}_linux_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';{{/linux}}
{{#macos}}import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';import 'package:{{project_name}}_macos_{{name.snakeCase()}}/{{project_name}}_macos_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';import 'package:flutter/material.dart' show ThemeMode;{{/macos}}
{{#web}}import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';import 'package:{{project_name}}_web_{{name.snakeCase()}}/{{project_name}}_web_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';{{/web}}
{{#windows}}import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';import 'package:{{project_name}}_windows_{{name.snakeCase()}}/{{project_name}}_windows_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';{{/windows}}
{{#mobile}}import 'package:{{project_name}}_mobile_app/{{project_name}}_mobile_app.dart';import 'package:{{project_name}}_mobile_{{name.snakeCase()}}/{{project_name}}_mobile_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_mobile/{{project_name}}_ui_mobile.dart';{{/mobile}}

{{#routable}}class _TestRouter extends RootStackRouter {
  @override
  Map<String, PageFactory> get pagesMap => {
        ...{{name.pascalCase()}}Module().pagesMap,
      };

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: {{route_name}}Route.page, path: '/'),
      ];
}{{/routable}}

extension WidgetTesterX on WidgetTester {
{{#routable}}  Future<void> pumpApp({
    required List<PageRouteInfo<dynamic>> initialRoutes,
    RootStackRouter? router,
    NavigatorObserver? observer,
    Locale? locale,
    {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}ThemeMode? themeMode{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}}{{#mobile}}ThemeMode? themeMode{{/mobile}},
  }) async {
    await pumpWidget(
      App.test(
        locale: locale ?? const Locale('{{default_language}}'),
        localizationsDelegates: const [
         {{project_name.pascalCase()}}{{#android}}Android{{/android}}{{#ios}}Ios{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}Macos{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}{{#mobile}}Mobile{{/mobile}}{{name.pascalCase()}}Localizations.delegate,
        ],
        router: router ?? _TestRouter(),
        initialRoutes: initialRoutes,
        navigatorObserver: observer,
        {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}themeMode: themeMode{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}}{{#mobile}}themeMode: themeMode{{/mobile}},
      ),
    );
    await pump();
  }{{/routable}}

  Future<void> pumpAppWidget({
    required Widget widget,
    Locale? locale,
    {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}ThemeMode? themeMode{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}}{{#mobile}}ThemeMode? themeMode{{/mobile}},
  }) async {
    await pumpWidget(
      App.testWidget(
        widget: widget,
        locale: locale ?? const Locale('{{default_language}}'),
        localizationsDelegates: const [
          {{project_name.pascalCase()}}{{#android}}Android{{/android}}{{#ios}}Ios{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}Macos{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}{{#mobile}}Mobile{{/mobile}}{{name.pascalCase()}}Localizations.delegate,
        ],
        {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}themeMode: themeMode{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}}{{#mobile}}themeMode: themeMode{{/mobile}},
      ),
    );
  }
}
