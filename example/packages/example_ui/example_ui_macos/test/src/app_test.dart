import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:example_ui_macos/src/app.dart';
import 'package:example_ui_macos/src/theme_extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Brightness, Theme;
import 'package:macos_ui/macos_ui.dart';

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
    testWidgets('renders MacosApp correctly when brightness is light',
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
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.supportedLocales, supportedLocales);
      expect(
        macosApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(macosApp.locale, const Locale('en'));
      expect(
        macosApp.routeInformationProvider,
        routerConfig.routeInformationProvider,
      );
      expect(macosApp.routerDelegate, routerConfig.routerDelegate);
      expect(
        macosApp.routeInformationParser,
        routerConfig.routeInformationParser,
      );
      expect(macosApp.home, null);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), lightExtensions);
    });

    testWidgets('renders MacosApp correctly when brightness is dark',
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
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.supportedLocales, supportedLocales);
      expect(
        macosApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(macosApp.locale, const Locale('en'));
      expect(
        macosApp.routeInformationProvider,
        routerConfig.routeInformationProvider,
      );
      expect(macosApp.routerDelegate, routerConfig.routerDelegate);
      expect(
        macosApp.routeInformationParser,
        routerConfig.routeInformationParser,
      );
      expect(macosApp.home, null);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), darkExtensions);
    });
  });

  group('ExampleApp.test', () {
    testWidgets('renders MacosApp correctly when brightness is light',
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
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.locale, const Locale('en'));
      expect(
        macosApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(macosApp.supportedLocales, equals([const Locale('en')]));
      expect(macosApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), lightExtensions);
    });

    testWidgets('renders MacosApp correctly when brightness is dark',
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
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.locale, const Locale('en'));
      expect(
        macosApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(macosApp.supportedLocales, equals([const Locale('en')]));
      expect(macosApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), darkExtensions);
    });
  });
}
