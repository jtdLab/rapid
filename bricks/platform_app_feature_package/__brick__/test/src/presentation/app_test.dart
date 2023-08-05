import 'package:auto_route/auto_route.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name}}_ui_{{platform}}/{{project_name}}_ui_{{platform}}.dart';
import 'package:{{project_name}}_{{platform}}_app/src/presentation/app.dart';
import 'package:{{project_name}}_{{platform}}_localization/{{project_name}}_{{platform}}_localization.dart';

import '../../mocks.dart';

App _getApp({
  required RootStackRouter router,
  List<AutoRouterObserver> Function()? navigatorObserverBuilder,
}) {
  return App(
    router: router,
    navigatorObserverBuilder: navigatorObserverBuilder,
  );
}

App _getAppTest({
  Locale? locale,
  required RootStackRouter router,
  List<PageRouteInfo<dynamic>>? initialRoutes,
  AutoRouterObserver? navigatorObserver,
  {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}ThemeMode? themeMode{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}}{{#mobile}}ThemeMode? themeMode{{/mobile}},
}) {
  return App.test(
    locale: locale,
    router: router,
    initialRoutes: initialRoutes,
    navigatorObserver: navigatorObserver,
    {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}themeMode: themeMode{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}}{{#mobile}}themeMode: themeMode{{/mobile}},
  );
}

App _getAppTestWidget({
  required Widget widget,
  Locale? locale,
  {{#android}}ThemeMode? themeMode{{/android}}{{#ios}}Brightness? brightness{{/ios}}{{#linux}}ThemeMode? themeMode{{/linux}}{{#macos}}ThemeMode? themeMode{{/macos}}{{#web}}ThemeMode? themeMode{{/web}}{{#windows}}ThemeMode? themeMode{{/windows}}{{#mobile}}ThemeMode? themeMode{{/mobile}},
}) {
  return App.testWidget(
    widget: widget,
    locale: locale,
    {{#android}}themeMode: themeMode{{/android}}{{#ios}}brightness: brightness{{/ios}}{{#linux}}themeMode: themeMode{{/linux}}{{#macos}}themeMode: themeMode{{/macos}}{{#web}}themeMode: themeMode{{/web}}{{#windows}}themeMode: themeMode{{/windows}}{{#mobile}}themeMode: themeMode{{/mobile}},
  );
}

void main() {
  group('App', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      navigatorObserverBuilder() => <AutoRouterObserver>[];
      final app = _getApp(
        router: router,
        navigatorObserverBuilder: navigatorObserverBuilder,
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.supportedLocales, {{project_name.pascalCase()}}Localizations.supportedLocales);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains({{project_name.pascalCase()}}Localizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                  .having(
                    (delegate) => delegate.navigatorObservers,
                    'navigatorObservers',
                    navigatorObserverBuilder,
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
    });
  });

  group('App.test', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final router = FakeRouter();
      final navigatorObserver= MockAutoRouterObserver();
      final app = _getAppTest(
        locale: {{project_name.pascalCase()}}Localizations.supportedLocales.first,
        router: router,
        initialRoutes: const [FakePageRouteInfo()],
        navigatorObserver: navigatorObserver,
        {{#android}}themeMode: ThemeMode.dark{{/android}}{{#ios}}brightness: Brightness.dark{{/ios}}{{#linux}}themeMode: ThemeMode.dark{{/linux}}{{#macos}}themeMode: ThemeMode.dark{{/macos}}{{#web}}themeMode: ThemeMode.dark{{/web}}{{#windows}}themeMode: ThemeMode.dark{{/windows}}{{#mobile}}themeMode: ThemeMode.dark{{/mobile}},
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.locale, {{project_name.pascalCase()}}Localizations.supportedLocales.first);
      expect({{project_name.camelCase()}}App.supportedLocales, {{project_name.pascalCase()}}Localizations.supportedLocales);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains({{project_name.pascalCase()}}Localizations.delegate),
      );
      expect(
        {{project_name.camelCase()}}App.routerConfig,
        isA<RouterConfig<UrlState>>()
            .having(
              (routerConfig) => routerConfig.routeInformationParser,
              'routeInformationParser',
              isA<DefaultRouteParser>(),
            )
            .having(
              (routerConfig) => routerConfig.routeInformationProvider,
              'routeInformationProvider',
              isA<AutoRouteInformationProvider>(),
            )
            .having(
              (routerConfig) => routerConfig.routerDelegate,
              'routerDelegate',
              isA<AutoRouterDelegate>()
                 .having(
                    (delegate) => delegate.deepLinkBuilder,
                    'deepLinkBuilder',
                    isNotNull,
                  )
                  .having(
                    (delegate) => delegate.navigatorObservers(),
                    'navigatorObservers',
                    equals([navigatorObserver]),
                  )
                  .having(
                    (delegate) => delegate.controller,
                    'controller',
                    router,
                  ),
            ),
      );
      expect({{project_name.camelCase()}}App.{{#android}}themeMode{{/android}}{{#ios}}brightness{{/ios}}{{#linux}}themeMode{{/linux}}{{#macos}}themeMode{{/macos}}{{#web}}themeMode{{/web}}{{#windows}}themeMode{{/windows}}{{#mobile}}themeMode{{/mobile}}, {{#android}}ThemeMode.dark{{/android}}{{#ios}}Brightness.dark{{/ios}}{{#linux}}ThemeMode.dark{{/linux}}{{#macos}}ThemeMode.dark{{/macos}}{{#web}}ThemeMode.dark{{/web}}{{#windows}}ThemeMode.dark{{/windows}}{{#mobile}}ThemeMode.dark{{/mobile}});
    });
  });

  group('App.testWidget', () {
    testWidgets('renders {{project_name.pascalCase()}}App correctly', (tester) async {
      // Arrange
      final widget = Container();
      final app = _getAppTestWidget(
        locale: {{project_name.pascalCase()}}Localizations.supportedLocales.first,
        widget: widget,
        {{#android}}themeMode: ThemeMode.dark{{/android}}{{#ios}}brightness: Brightness.dark{{/ios}}{{#linux}}themeMode: ThemeMode.dark{{/linux}}{{#macos}}themeMode: ThemeMode.dark{{/macos}}{{#web}}themeMode: ThemeMode.dark{{/web}}{{#windows}}themeMode: ThemeMode.dark{{/windows}}{{#mobile}}themeMode: ThemeMode.dark{{/mobile}},
      );

      // Act
      await tester.pumpWidget(app);

      // Assert
      final {{project_name.camelCase()}}App = tester.widget<{{project_name.pascalCase()}}App>(
        find.byWidgetPredicate((widget) => widget is {{project_name.pascalCase()}}App),
      );
      expect({{project_name.camelCase()}}App.home, widget);
      expect({{project_name.camelCase()}}App.locale, {{project_name.pascalCase()}}Localizations.supportedLocales.first);
      expect({{project_name.camelCase()}}App.supportedLocales, {{project_name.pascalCase()}}Localizations.supportedLocales);
      expect(
        {{project_name.camelCase()}}App.localizationsDelegates,
        contains({{project_name.pascalCase()}}Localizations.delegate),
      );
      expect({{project_name.camelCase()}}App.routerConfig, null);
      expect({{project_name.camelCase()}}App.{{#android}}themeMode{{/android}}{{#ios}}brightness{{/ios}}{{#linux}}themeMode{{/linux}}{{#macos}}themeMode{{/macos}}{{#web}}themeMode{{/web}}{{#windows}}themeMode{{/windows}}{{#mobile}}themeMode{{/mobile}}, {{#android}}ThemeMode.dark{{/android}}{{#ios}}Brightness.dark{{/ios}}{{#linux}}ThemeMode.dark{{/linux}}{{#macos}}ThemeMode.dark{{/macos}}{{#web}}ThemeMode.dark{{/web}}{{#windows}}ThemeMode.dark{{/windows}}{{#mobile}}ThemeMode.dark{{/mobile}});
    });
  });
}
