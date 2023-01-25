import 'dart:ui';

import 'package:flutter/material.dart' show Theme;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_ui_macos/project_macos_ui_macos.dart';
import 'package:project_macos_ui_macos/src/theme_extensions.dart';

class _MockLocalizationsDelegate extends LocalizationsDelegate<dynamic> {
  @override
  bool isSupported(Locale locale) => true;

  @override
  Future load(Locale locale) async {}

  @override
  bool shouldReload(covariant LocalizationsDelegate old) => false;
}

class _MockRouteInformationParser extends RouteInformationParser<Object> {}

class _MockRouterDelegate extends RouterDelegate<Object> {
  @override
  void addListener(VoidCallback listener) {}

  @override
  Widget build(BuildContext context) => Container();

  @override
  Future<bool> popRoute() async => false;

  @override
  void removeListener(VoidCallback listener) {}

  @override
  Future<void> setNewRoutePath(Object configuration) async {}
}

void main() {
  group('ProjectMacosApp', () {
    late Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
    late Iterable<Locale> supportedLocales;
    late RouteInformationParser<Object> routeInformationParser;
    late RouterDelegate<Object> routerDelegate;
    late Locale? locale;
    late Brightness? brightness;
    late Widget? home;

    setUp(() {
      localizationsDelegates = [_MockLocalizationsDelegate()];
      supportedLocales = {const Locale('en')};
      routeInformationParser = _MockRouteInformationParser();
      routerDelegate = _MockRouterDelegate();
      locale = null;
      brightness = null;
      home = null;
    });

    ProjectMacosApp getApp() => ProjectMacosApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          locale: locale,
          brightness: brightness,
          home: home,
        );

    testWidgets('returns MacosApp with correct properties', (tester) async {
      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.locale, null);
      expect(
        macosApp.localizationsDelegates,
        [
          ...GlobalCupertinoLocalizations.delegates,
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate,
          ...localizationsDelegates
        ],
      );
      expect(macosApp.supportedLocales, supportedLocales);
      expect(macosApp.routeInformationParser, routeInformationParser);
      expect(macosApp.routerDelegate, routerDelegate);
      expect(macosApp.home, null);
    });

    testWidgets(
        'returns MacosApp with correct properties when home is not null and brightness is light',
        (tester) async {
      // Arrange
      locale = const Locale('en');
      brightness = Brightness.light;
      home = Container();

      // Act
      await tester.pumpWidget(getApp());
      await tester.pumpAndSettle();

      // Assert
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.locale, locale);
      expect(
        macosApp.localizationsDelegates,
        [
          ...GlobalCupertinoLocalizations.delegates,
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate,
          ...localizationsDelegates
        ],
      );
      expect(macosApp.supportedLocales, supportedLocales);
      expect(macosApp.routeInformationParser, null);
      expect(macosApp.routerDelegate, null);
      expect(macosApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), lightExtensions);
    });

    testWidgets(
        'returns MacosApp with correct properties when home is not null and brightness is dark',
        (tester) async {
      // Arrange
      locale = const Locale('en');
      brightness = Brightness.dark;
      home = Container();

      // Act
      await tester.pumpWidget(getApp());
      await tester.pumpAndSettle();

      // Assert
      final macosApp = tester.widget<MacosApp>(find.byType(MacosApp));
      expect(macosApp.locale, locale);
      expect(
        macosApp.localizationsDelegates,
        [
          ...GlobalCupertinoLocalizations.delegates,
          ...GlobalMaterialLocalizations.delegates,
          GlobalWidgetsLocalizations.delegate,
          ...localizationsDelegates
        ],
      );
      expect(macosApp.supportedLocales, supportedLocales);
      expect(macosApp.routeInformationParser, null);
      expect(macosApp.routerDelegate, null);
      expect(macosApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), darkExtensions);
    });
  });
}
