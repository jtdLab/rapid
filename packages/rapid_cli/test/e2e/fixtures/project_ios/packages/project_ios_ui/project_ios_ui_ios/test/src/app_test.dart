import 'package:flutter/material.dart' show Theme;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ui_ios/project_ios_ui_ios.dart';
import 'package:project_ios_ui_ios/src/theme_extensions.dart';

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
  group('ProjectIosApp', () {
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

    ProjectIosApp projectIosApp() => ProjectIosApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          locale: locale,
          brightness: brightness,
          home: home,
        );

    testWidgets('renders CupertinoApp with correct properties', (tester) async {
      // Act
      await tester.pumpWidget(projectIosApp());

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.locale, null);
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.supportedLocales, supportedLocales);
      expect(cupertinoApp.routeInformationParser, routeInformationParser);
      expect(cupertinoApp.routerDelegate, routerDelegate);
      expect(cupertinoApp.home, null);
    });

    testWidgets(
        'renders CupertinoApp with correct properties when home is not null and brightness is light',
        (tester) async {
      // Arrange
      locale = const Locale('en');
      brightness = Brightness.light;
      home = Container();

      // Act
      await tester.pumpWidget(projectIosApp());
      await tester.pumpAndSettle();

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.locale, locale);
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.supportedLocales, supportedLocales);
      expect(cupertinoApp.routeInformationParser, null);
      expect(cupertinoApp.routerDelegate, null);
      expect(cupertinoApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), lightExtensions);
    });

    testWidgets(
        'renders CupertinoApp with correct properties when home is not null and brightness is dark',
        (tester) async {
      // Arrange
      locale = const Locale('en');
      brightness = Brightness.dark;
      home = Container();

      // Act
      await tester.pumpWidget(projectIosApp());
      await tester.pumpAndSettle();

      // Assert
      final cupertinoApp =
          tester.widget<CupertinoApp>(find.byType(CupertinoApp));
      expect(cupertinoApp.locale, locale);
      expect(
        cupertinoApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(cupertinoApp.supportedLocales, supportedLocales);
      expect(cupertinoApp.routeInformationParser, null);
      expect(cupertinoApp.routerDelegate, null);
      expect(cupertinoApp.home, home);
      final theme = tester.widget<Theme>(find.byType(Theme));
      expect(theme.data.extensions.values.toSet(), darkExtensions);
    });
  });
}
