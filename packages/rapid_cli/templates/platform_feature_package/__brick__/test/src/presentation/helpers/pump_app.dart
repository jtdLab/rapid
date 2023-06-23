{{#routable}}import 'package:auto_route/auto_route.dart';{{/routable}}{{#isWidget}}import 'package:auto_route/auto_route.dart';{{/isWidget}}import 'package:flutter_bloc/flutter_bloc.dart';import 'package:flutter_test/flutter_test.dart';{{#android}}import 'package:{{project_name}}_android_app/{{project_name}}_android_app.dart';{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_android_{{name.snakeCase()}}/{{project_name}}_android_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}{{^isWidget}}import 'package:{{project_name}}_android_{{name.snakeCase()}}/{{project_name}}_android_{{name.snakeCase()}}.dart';{{/isWidget}}{{#isWidget}}{{#localization}}import 'package:{{project_name}}_android_{{name.snakeCase()}}/{{project_name}}_android_{{name.snakeCase()}}.dart';{{/localization}}{{/isWidget}}import 'package:{{project_name}}_ui_android/{{project_name}}_ui_android.dart';{{/android}}
{{#ios}}import 'package:{{project_name}}_ios_app/{{project_name}}_ios_app.dart';{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_ios_{{name.snakeCase()}}/{{project_name}}_ios_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}{{^isWidget}}import 'package:{{project_name}}_ios_{{name.snakeCase()}}/{{project_name}}_ios_{{name.snakeCase()}}.dart';{{/isWidget}}{{#isWidget}}{{#localization}}import 'package:{{project_name}}_ios_{{name.snakeCase()}}/{{project_name}}_ios_{{name.snakeCase()}}.dart';{{/localization}}{{/isWidget}}import 'package:{{project_name}}_ui_ios/{{project_name}}_ui_ios.dart';{{/ios}}
{{#linux}}import 'package:{{project_name}}_linux_app/{{project_name}}_linux_app.dart';{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_linux_{{name.snakeCase()}}/{{project_name}}_linux_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}{{^isWidget}}import 'package:{{project_name}}_linux_{{name.snakeCase()}}/{{project_name}}_linux_{{name.snakeCase()}}.dart';{{/isWidget}}{{#isWidget}}{{#localization}}import 'package:{{project_name}}_linux_{{name.snakeCase()}}/{{project_name}}_linux_{{name.snakeCase()}}.dart';{{/localization}}{{/isWidget}}import 'package:{{project_name}}_ui_linux/{{project_name}}_ui_linux.dart';{{/linux}}
{{#macos}}import 'package:{{project_name}}_macos_app/{{project_name}}_macos_app.dart';{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_macos_{{name.snakeCase()}}/{{project_name}}_macos_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}{{^isWidget}}import 'package:{{project_name}}_macos_{{name.snakeCase()}}/{{project_name}}_macos_{{name.snakeCase()}}.dart';{{/isWidget}}{{#isWidget}}{{#localization}}import 'package:{{project_name}}_macos_{{name.snakeCase()}}/{{project_name}}_macos_{{name.snakeCase()}}.dart';{{/localization}}{{/isWidget}}import 'package:{{project_name}}_ui_macos/{{project_name}}_ui_macos.dart';import 'package:flutter/material.dart' show ThemeMode;{{/macos}}
{{#web}}import 'package:{{project_name}}_web_app/{{project_name}}_web_app.dart';{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_web_{{name.snakeCase()}}/{{project_name}}_web_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}{{^isWidget}}import 'package:{{project_name}}_web_{{name.snakeCase()}}/{{project_name}}_web_{{name.snakeCase()}}.dart';{{/isWidget}}{{#isWidget}}{{#localization}}import 'package:{{project_name}}_web_{{name.snakeCase()}}/{{project_name}}_web_{{name.snakeCase()}}.dart';{{/localization}}{{/isWidget}}import 'package:{{project_name}}_ui_web/{{project_name}}_ui_web.dart';{{/web}}
{{#windows}}import 'package:{{project_name}}_windows_app/{{project_name}}_windows_app.dart';{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_windows_{{name.snakeCase()}}/{{project_name}}_windows_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}{{^isWidget}}import 'package:{{project_name}}_windows_{{name.snakeCase()}}/{{project_name}}_windows_{{name.snakeCase()}}.dart';{{/isWidget}}{{#isWidget}}{{#localization}}import 'package:{{project_name}}_windows_{{name.snakeCase()}}/{{project_name}}_windows_{{name.snakeCase()}}.dart';{{/localization}}{{/isWidget}}import 'package:{{project_name}}_ui_windows/{{project_name}}_ui_windows.dart';{{/windows}}
{{#mobile}}import 'package:{{project_name}}_mobile_app/{{project_name}}_mobile_app.dart';{{#isTabFlow}}{{#subRoutes}}import 'package:{{project_name}}_mobile_{{name.snakeCase()}}/{{project_name}}_mobile_{{name.snakeCase()}}.dart';{{/subRoutes}}{{/isTabFlow}}{{^isWidget}}import 'package:{{project_name}}_mobile_{{name.snakeCase()}}/{{project_name}}_mobile_{{name.snakeCase()}}.dart';{{/isWidget}}{{#isWidget}}{{#localization}}import 'package:{{project_name}}_mobile_{{name.snakeCase()}}/{{project_name}}_mobile_{{name.snakeCase()}}.dart';{{/localization}}{{/isWidget}}import 'package:{{project_name}}_ui_mobile/{{project_name}}_ui_mobile.dart';{{/mobile}}

/// Wraps [widget] with a fully functional [App].
///
{{#localization}}/// Use the [locale] parameter to set the language of the app.
///
{{/localization}}/// Use the [themeMode] parameter to customize the app's appearance.
///
/// The [observer] parameter allows inspection of navigation events.
/// Typically, a mocked instance is used for verification purposes.
///
/// The [providers] parameter enables injection of blocs or cubits
/// into the widget tree above [widget].
///
/// Set the [withScaffold] option to wrap [widget] with an [ApfelHaScaffold].
/// This is particularly useful when testing subwidgets within a page or flow.
Widget appWrapper({
  {{#localization}}Locale? locale,{{/localization}}
  {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}ThemeMode? themeMode{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}}{{#mobile}}ThemeMode? themeMode{{/mobile}},
  NavigatorObserver? observer,
  List<BlocProvider> providers = const [],
  bool withScaffold = false,
  required Widget widget,
}) {
  Widget child;
  if (providers.isEmpty) {
    child = widget;
  } else {
    child = MultiBlocProvider(
      providers: providers,
      child: widget,
    );
  }

  if (withScaffold) {
    child = {{projectName.pascalCase()}}Scaffold(body: child);
  }

  return App.test(
    {{#localization}}locale: locale ?? const Locale('{{default_language}}'),
    localizationsDelegates: const [
      {{project_name.pascalCase()}}{{#android}}Android{{/android}}{{#ios}}Ios{{/ios}}{{#linux}}Linux{{/linux}}{{#macos}}Macos{{/macos}}{{#web}}Web{{/web}}{{#windows}}Windows{{/windows}}{{#mobile}}Mobile{{/mobile}}{{name.pascalCase()}}Localizations.delegate,
    ],{{/localization}}
    {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}themeMode: themeMode{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}}{{#mobile}}themeMode: themeMode{{/mobile}},
    router: _TestRouter(child),
    navigatorObserver: observer,
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp({
    {{#localization}}Locale? locale,{{/localization}}
    ThemeMode? themeMode,
    NavigatorObserver? observer,
    List<BlocProvider> providers = const [],
    bool withScaffold = false,
    required Widget widget,
  }) async {
    await pumpWidget(
      appWrapper(
        {{#localization}}locale: locale,{{/localization}}
        themeMode: themeMode,
        observer: observer,
        providers: providers,
        withScaffold: withScaffold,
        widget: widget,
      ),
    );
    await pump();
  }
}

{{#isFlow}}const nestedRouteA = _TestRoute(name: 'NestedRouteA');{{/isFlow}}

class _TestRouter extends RootStackRouter {
  final Widget widget;

  _TestRouter(this.widget);

  @override
  Map<String, PageFactory> get pagesMap => {
        {{#isWidget}}'__route__'{{/isWidget}}{{^isWidget}}{{name.pascalCase()}}Route.name{{/isWidget}}: (routeData) {
          return AutoRoutePage<dynamic>(
            routeData: routeData,
            child: widget,
          );
        },
{{#isFlow}}        nestedRouteA.name: (routeData) {
          return AutoRoutePage<dynamic>(
            routeData: routeData,
            child: _Placeholder(name: nestedRouteA.name),
          );
        },{{/isFlow}} 
{{#isTabFlow}}{{#subRoutes}}         {{name.pascalCase()}}Route.name: (routeData) {
          return AutoRoutePage<dynamic>(
            routeData: routeData,
            child: const _Placeholder(name: {{name.pascalCase()}}Route.name),
          );
        },{{/subRoutes}}{{/isTabFlow}} 
      };

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: const PageInfo({{#isWidget}}'__route__'{{/isWidget}}{{^isWidget}}{{name.pascalCase()}}Route.name{{/isWidget}}),
{{#isFlow}}          children: [
            AutoRoute(
              initial: true,
              page: nestedRouteA.page,
            ),
          ],{{/isFlow}}
{{#isTabFlow}}          children: [{{#subRoutes}}
            AutoRoute(
{{#isFirst}}              initial: true,{{/isFirst}}
              page: {{name.pascalCase()}}Route.page,
            ),{{/subRoutes}}
          ],{{/isTabFlow}}
        ),
      ];
}

{{#isFlow}}class _TestRoute extends PageRouteInfo<void> {
  const _TestRoute({
    required this.name,
    List<PageRouteInfo>? children,
  }) : super(
          name,
          initialChildren: children,
        );

  final String name;

  PageInfo<void> get page => PageInfo<void>(name);
}

class _Placeholder extends StatelessWidget {
  final String name;

  const _Placeholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Placeholder(),
          Center(
            child: Container(
              color: const Color(0xFFFFFFFF),
              child: Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}{{/isFlow}}{{#isTabFlow}}
class _Placeholder extends StatelessWidget {
  final String name;

  const _Placeholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Placeholder(),
          Center(
            child: Container(
              color: const Color(0xFFFFFFFF),
              child: Text(
                name,
                style: const TextStyle(
                  color: Color(0xFF000000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}{{/isTabFlow}}