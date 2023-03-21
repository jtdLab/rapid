import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_ui_macos/src/app.dart';
import 'package:project_macos_ui_macos/src/theme_extensions.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Brightness, Theme;
import 'package:macos_ui/macos_ui.dart';

import 'mocks.dart';

ProjectMacosApp _getProjectMacosApp({
  Locale? locale,
  required Iterable<Locale> supportedLocales,
  required Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates,
  required RouterConfig<Object> routerConfig,
  Brightness? brightness,
}) {
  return ProjectMacosApp(
    locale: locale,
    supportedLocales: supportedLocales,
    localizationsDelegates: localizationsDelegates,
    routerConfig: routerConfig,
    brightness: brightness,
  );
}

ProjectMacosApp _getProjectMacosAppTest({
  Locale? locale,
  Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates,
  Brightness? brightness,
  required Widget home,
}) {
  return ProjectMacosApp.test(
    locale: locale,
    localizationsDelegates: localizationsDelegates,
    brightness: brightness,
    home: home,
  );
}

void main() {
  group('ProjectMacosApp', () {
    testWidgets('renders MacosApp correctly when brightness is light',
        (tester) async {
      // Arrange
      final supportedLocales = {const Locale('en')};
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final routerConfig = FakeRouterConfig();
      final projectMacosApp = _getProjectMacosApp(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        brightness: Brightness.light,
      );

      // Act
      await tester.pumpWidget(projectMacosApp);
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
      final projectMacosApp = _getProjectMacosApp(
        locale: const Locale('en'),
        supportedLocales: supportedLocales,
        localizationsDelegates: localizationsDelegates,
        routerConfig: routerConfig,
        brightness: Brightness.dark,
      );

      // Act
      await tester.pumpWidget(projectMacosApp);
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

  group('ProjectMacosApp.test', () {
    testWidgets('renders MacosApp correctly when brightness is light',
        (tester) async {
      // Arrange
      final localizationsDelegates = [FakeLocalizationsDelegate()];
      final home = Container();
      final projectMacosApp = _getProjectMacosAppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        brightness: Brightness.light,
        home: home,
      );

      // Act
      await tester.pumpWidget(projectMacosApp);
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
      final projectMacosApp = _getProjectMacosAppTest(
        locale: const Locale('en'),
        localizationsDelegates: localizationsDelegates,
        brightness: Brightness.dark,
        home: home,
      );

      // Act
      await tester.pumpWidget(projectMacosApp);
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
