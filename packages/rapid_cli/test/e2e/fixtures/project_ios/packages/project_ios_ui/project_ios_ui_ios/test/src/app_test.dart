import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ui_ios/src/app.dart';
import 'package:project_ios_ui_ios/src/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;

import 'mocks.dart';

ProjectIosApp _getProjectIosApp({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  Brightness? brightness,
}) {
  return ProjectIosApp(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    brightness: brightness,
  );
}

ProjectIosApp _getProjectIosAppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Brightness? brightness,
  required Widget home,
}) {
  return ProjectIosApp.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    brightness: brightness,
    home: home,
  );
}

void main() {
  group('ProjectIosApp', () {
    testWidgets('renders CupertinoApp correctly when brightness is light',
        (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final projectIosApp = _getProjectIosApp(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        brightness: Brightness.light,
      );

      // Act
      await tester.pumpWidget(projectIosApp);
      await tester.pump();

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.supportedLocales, supportedLocales);
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.locale, const Locale('en'));
      expect(cupertinoApp.routerConfig, routerConfig);
      expect(cupertinoApp.home, null);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), lightExtensions);
    });

    testWidgets('renders CupertinoApp correctly when brightness is dark',
        (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final projectIosApp = _getProjectIosApp(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        brightness: Brightness.dark,
      );

      // Act
      await tester.pumpWidget(projectIosApp);
      await tester.pump();

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.supportedLocales, supportedLocales);
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.locale, const Locale('en'));
      expect(cupertinoApp.routerConfig, routerConfig);
      expect(cupertinoApp.home, null);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), darkExtensions);
    });
  });

  group('ProjectIosApp.test', () {
    testWidgets('renders CupertinoApp correctly when brightness is light',
        (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final projectIosApp = _getProjectIosAppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        brightness: Brightness.light,
        home: home,
      );

      // Act
      await tester.pumpWidget(projectIosApp);
      await tester.pumpAndSettle();

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.locale, const Locale('en'));
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.supportedLocales, equals([const Locale('en')]));
      expect(cupertinoApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), lightExtensions);
    });

    testWidgets('renders CupertinoApp correctly when brightness is dark',
        (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final projectIosApp = _getProjectIosAppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        brightness: Brightness.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget(projectIosApp);
      await tester.pumpAndSettle();

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.locale, const Locale('en'));
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.supportedLocales, equals([const Locale('en')]));
      expect(cupertinoApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), darkExtensions);
    });
  });
}
