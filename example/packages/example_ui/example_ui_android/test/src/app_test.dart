import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_ui_android/src/app.dart';
import 'package:example_ui_android/src/theme_extensions.dart';
import 'package:flutter/material.dart';

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
    testWidgets('renders MaterialApp correctly', (tester) async {
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
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.supportedLocales, supportedLocales);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.locale, null);
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          lightExtensions,
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          darkExtensions,
        ),
      );
      expect(materialApp.routerConfig, routerConfig);
      expect(materialApp.home, null);
    });
  });

  group('ExampleApp.test', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
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
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, const Locale('fr'));
      expect(materialApp.supportedLocales, [const Locale('fr')]);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(
        materialApp.theme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          lightExtensions,
        ),
      );
      expect(
        materialApp.darkTheme,
        isA<ThemeData>().having(
          (theme) => theme.extensions.values,
          'extensions',
          darkExtensions,
        ),
      );
      expect(materialApp.themeMode, ThemeMode.dark);
      expect(materialApp.home, home);
    });
  });
}
