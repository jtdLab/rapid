{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}import 'package:flutter_test/flutter_test.dart';{{#android}}import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';import 'package:{{project_name}}_android_{{name.snakeCase()}}/{{project_name}}_android_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';{{/android}}
{{#ios}}import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';import 'package:{{project_name}}_ios_{{name.snakeCase()}}/{{project_name}}_ios_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';{{/ios}}
{{#linux}}import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';import 'package:{{project_name}}_linux_{{name.snakeCase()}}/{{project_name}}_linux_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';{{/linux}}
{{#macos}}import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';import 'package:{{project_name}}_macos_{{name.snakeCase()}}/{{project_name}}_macos_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';{{/macos}}
{{#web}}import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';import 'package:{{project_name}}_web_{{name.snakeCase()}}/{{project_name}}_web_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';{{/web}}
{{#windows}}import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';import 'package:{{project_name}}_windows_{{name.snakeCase()}}/{{project_name}}_windows_{{name.snakeCase()}}.dart';import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';{{/windows}}

extension WidgetTesterX on WidgetTester {
{{#routable}}  Future<void> pumpApp({
    required List<PageRouteInfo<dynamic>> initialRoutes,
    RootStackRouter? router,
    AutoRouterObserver? observer,
    Locale? locale,
    {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}Brightness? brightness{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}},
  }) async {
    await pumpWidget(
      App.test(
        locale: locale ?? const Locale('{{default_language}}'),
        localizationsDelegates: const [
         {{project_name.pascalCase()}}{{#android}}Android{{/android}}{{#ios}}Ios{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}Macos{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}{{name.pascalCase()}}Localizations.delegate,
        ],
        router: router ?? {{name.pascalCase()}}Router(),
        initialRoutes: initialRoutes,
        routerObserver: observer,
        {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}brightness: brightness{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}},
      ),
    );
    await pump();
  }{{/routable}}

  Future<void> pumpAppWidget({
    required Widget widget,
    Locale? locale,
    {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}Brightness? brightness{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}},
  }) async {
    await pumpWidget(
      App.testWidget(
        widget: widget,
        locale: locale ?? const Locale('{{default_language}}'),
        localizationsDelegates: const [
          {{project_name.pascalCase()}}{{#android}}Android{{/android}}{{#ios}}Ios{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}Macos{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}{{name.pascalCase()}}Localizations.delegate,
        ],
        {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}brightness: brightness{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}},
      ),
    );
  }
}
