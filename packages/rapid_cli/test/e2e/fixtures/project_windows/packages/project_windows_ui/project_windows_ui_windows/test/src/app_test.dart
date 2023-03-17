import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_ui_windows/src/app.dart';
import 'package:project_windows_ui_windows/src/theme_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'mocks.dart';

ProjectWindowsApp _getProjectWindowsApp({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouteInformationParser<Object> routeInformationParser,
  required RouterDelegate<Object> routerDelegate,
  ThemeMode? themeMode,
}) {
  return ProjectWindowsApp(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routeInformationParser: routeInformationParser,
    routerDelegate: routerDelegate,
    themeMode: themeMode,
  );
}

ProjectWindowsApp _getProjectWindowsAppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return ProjectWindowsApp.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('ProjectWindowsApp', () {
    testWidgets('renders FluentApp correctly', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routeInformationParser = FakeRouteInformationParser();
      final routerDelegate = FakeRouterDelegate();
      final projectWindowsApp = _getProjectWindowsApp(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routeInformationParser: routeInformationParser,
        routerDelegate: routerDelegate,
      );

      // Act
      await tester.pumpWidget(projectWindowsApp);

      // Assert
      final fluentApp = tester.widget<FluentApp>(find.byType(FluentApp));
      expect(fluentApp.supportedLocales, supportedLocales);
      expect(
        fluentApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(fluentApp.locale, null);
      expect(
        fluentApp.theme,
        isA<FluentThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          lightExtensions,
        ),
      );
      expect(
        fluentApp.darkTheme,
        isA<FluentThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          darkExtensions,
        ),
      );
      expect(fluentApp.routeInformationParser, routeInformationParser);
      expect(fluentApp.routerDelegate, routerDelegate);
      expect(fluentApp.home, null);
    });
  });

  group('ProjectWindowsApp.test', () {
    testWidgets('renders FluentApp correctly', (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final projectWindowsApp = _getProjectWindowsAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget(projectWindowsApp);

      // Assert
      final fluentApp = tester.widget<FluentApp>(find.byType(FluentApp));
      expect(fluentApp.locale, const Locale('fr'));
      expect(fluentApp.supportedLocales, [const Locale('fr')]);
      expect(
        fluentApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(
        fluentApp.theme,
        isA<FluentThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          lightExtensions,
        ),
      );
      expect(
        fluentApp.darkTheme,
        isA<FluentThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          darkExtensions,
        ),
      );
      expect(fluentApp.themeMode, ThemeMode.dark);
      expect(fluentApp.home, home);
    });
  });
}
