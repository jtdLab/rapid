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
/// Use the [{{^ios}}themeMode{{/ios}}{{#ios}}brightness{{/ios}}] parameter to customize the app's appearance.
///
/// The [observer] parameter allows inspection of navigation events.
/// Typically, a mocked instance is used for verification purposes.
///
/// The [providers] parameter enables injection of blocs or cubits
/// into the widget tree above [widget].
///
/// Set the [withScaffold] option to wrap [widget] with a
/// [{{project_name.pascalCase()}}Scaffold].
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
    locale: locale,
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

const nestedRouteA = _TestRoute(name: 'NestedRouteA');

class _TestRouter extends RootStackRouter {
  _TestRouter(this.widget);

  final Widget widget;

  @override
  Map<String, PageFactory> get pagesMap => {
        {{name.pascalCase()}}Route.name: (routeData) {
          return AutoRoutePage<dynamic>(
            routeData: routeData,
            child: widget,
          );
        },
        nestedRouteA.name: (routeData) {
          return AutoRoutePage<dynamic>(
            routeData: routeData,
            child: _Placeholder(name: nestedRouteA.name),
          );
        },
      };

  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          initial: true,
          page: const PageInfo({{name.pascalCase()}}Route.name),
          children: [
            AutoRoute(
              initial: true,
              page: nestedRouteA.page,
            ),
          ],
        ),
      ];
}

class _TestRoute extends PageRouteInfo<void> {
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
  const _Placeholder({required this.name});

  final String name;

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
                  child: ColoredBox(
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
            child: ColoredBox(
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
