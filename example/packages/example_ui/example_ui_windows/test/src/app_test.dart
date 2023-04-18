import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_ui_windows/src/app.dart';
import 'package:example_ui_windows/src/theme_extensions.dart';
import 'package:fluent_ui/fluent_ui.dart';

import 'mocks.dart';

ExampleApp _getExampleApp({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  ThemeMode? themeMode,
}) {
  return ExampleApp(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    themeMode: themeMode,
  );
}

ExampleApp _getExampleAppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return ExampleApp.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('ExampleApp', () {
    testWidgets('renders FluentApp correctly', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final exampleApp = _getExampleApp(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
      );

      // Act
      await tester.pumpWidget(exampleApp);

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
      expect(fluentApp.routerConfig, routerConfig);
      expect(fluentApp.home, null);
    });
  });

  group('ExampleApp.test', () {
    testWidgets('renders FluentApp correctly', (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final exampleApp = _getExampleAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget(exampleApp);

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
