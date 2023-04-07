import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_ui_linux/src/app.dart';
import 'package:project_linux_ui_linux/src/theme_extensions.dart';
import 'package:flutter/material.dart';

import 'mocks.dart';

ProjectLinuxApp _getProjectLinuxApp({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  ThemeMode? themeMode,
}) {
  return ProjectLinuxApp(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    themeMode: themeMode,
  );
}

ProjectLinuxApp _getProjectLinuxAppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  ThemeMode? themeMode,
  required Widget home,
}) {
  return ProjectLinuxApp.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    themeMode: themeMode,
    home: home,
  );
}

void main() {
  group('ProjectLinuxApp', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final projectLinuxApp = _getProjectLinuxApp(
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
      );

      // Act
      await tester.pumpWidget(projectLinuxApp);

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

  group('ProjectLinuxApp.test', () {
    testWidgets('renders MaterialApp correctly', (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final projectLinuxApp = _getProjectLinuxAppTest(
        locale: const Locale('fr'),
        localizationsDelegates: localizationsDelegates,
        themeMode: ThemeMode.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget(projectLinuxApp);

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
