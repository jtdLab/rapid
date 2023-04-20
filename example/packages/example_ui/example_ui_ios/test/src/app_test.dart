import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_ui_ios/src/app.dart';
import 'package:example_ui_ios/src/theme_extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Theme;

import 'mocks.dart';

ExampleApp _getExampleApp({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  Brightness? brightness,
}) {
  return ExampleApp(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    brightness: brightness,
  );
}

ExampleApp _getExampleAppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Brightness? brightness,
  required Widget home,
}) {
  return ExampleApp.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    brightness: brightness,
    home: home,
  );
}

void main() {
  group('ExampleApp', () {
    testWidgets('renders CupertinoApp correctly when brightness is light',
        (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final exampleApp = _getExampleApp(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        brightness: Brightness.light,
      );

      // Act
      await tester.pumpWidget(exampleApp);
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
      final exampleApp = _getExampleApp(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        brightness: Brightness.dark,
      );

      // Act
      await tester.pumpWidget(exampleApp);
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

  group('ExampleApp.test', () {
    testWidgets('renders CupertinoApp correctly when brightness is light',
        (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final exampleApp = _getExampleAppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        brightness: Brightness.light,
        home: home,
      );

      // Act
      await tester.pumpWidget(exampleApp);
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
      final exampleApp = _getExampleAppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        brightness: Brightness.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget(exampleApp);
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
