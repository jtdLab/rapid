import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_{{platform}}_app/{{project_name}}_{{platform}}_app.dart';
import 'package:{{project_name}}_{{platform}}_{{name.snakeCase()}}/{{project_name}}_{{platform}}_{{name.snakeCase()}}.dart';
import 'package:{{project_name}}_ui_{{platform}}/{{project_name}}_ui_{{platform}}.dart';

/// Wraps [widget] with a fully functional [App].
///
/// Use the [locale] parameter to set the language of the app.
///
/// Use the [themeMode] parameter to customize the app's appearance.
///
/// The [observer] parameter allows inspection of navigation events.
/// Typically, a mocked instance is used for verification purposes.
///
/// The [providers] parameter enables injection of blocs or cubits
/// into the widget tree above [widget].
///
/// Set the [withScaffold] option to wrap [widget] with an [{{project_name.pascalCase()}}Scaffold].
/// This is particularly useful when testing subwidgets within a page or flow.
Widget appWrapper({
  Locale? locale,
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
{{^macos}}    child = {{project_name.pascalCase()}}Scaffold(body: child);{{/macos}}
{{#macos}}    child = {{project_name.pascalCase()}}Scaffold(children: [child]);{{/macos}}
  }

  return App.test(
    locale: locale ?? const Locale('{{default_language}}'),
    localizationsDelegates: const [
      {{project_name.pascalCase()}}Localizations.delegate,
    ],
    {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}themeMode: themeMode{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}}{{#mobile}}themeMode: themeMode{{/mobile}},
    router: _TestRouter(child),
    navigatorObserver: observer,
  );
}

extension WidgetTesterX on WidgetTester {
  Future<void> pumpApp({
    Locale? locale,
    {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}ThemeMode? themeMode{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}}{{#mobile}}ThemeMode? themeMode{{/mobile}},
    NavigatorObserver? observer,
    List<BlocProvider> providers = const [],
    bool withScaffold = false,
    required Widget widget,
  }) async {
    await pumpWidget(
      appWrapper(
        locale: locale,
        {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}themeMode: themeMode{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}}{{#mobile}}themeMode: themeMode{{/mobile}},
        observer: observer,
        providers: providers,
        withScaffold: withScaffold,
        widget: widget,
      ),
    );
    await pump();
  }
}

class _TestRouter extends RootStackRouter {
  final Widget widget;

  _TestRouter(this.widget);

  @override
  Map<String, PageFactory> get pagesMap => {
        {{name.pascalCase()}}Route.name: (routeData) {
          return AutoRoutePage<dynamic>(
            routeData: routeData,
            child: widget,
          );
        },
{{#subRoutes}}         {{name.pascalCase()}}Route.name: (routeData) {
          return AutoRoutePage<dynamic>(
            routeData: routeData,
            child: const _Placeholder(name: {{name.pascalCase()}}Route.name),
          );
        },{{/subRoutes}}
      };

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: const PageInfo({{name.pascalCase()}}Route.name),
          children: [{{#subRoutes}}
            AutoRoute(
{{#isFirst}}              initial: true,{{/isFirst}}
              page: {{name.pascalCase()}}Route.page,
            ),{{/subRoutes}}
          ],
        ),
      ];
}

class _Placeholder extends StatelessWidget {
  final String name;

  const _Placeholder({required this.name});

  @override
  Widget build(BuildContext context) {
    return {{project_name.pascalCase()}}Scaffold(
{{#macos}}      children: [
        ContentArea(
          builder: (context, _) {
            return Stack(
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
            );
          },
        ),
      ],
{{/macos}}{{^macos}}      body: Stack(
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
      ),{{/macos}}
    );
  }
}