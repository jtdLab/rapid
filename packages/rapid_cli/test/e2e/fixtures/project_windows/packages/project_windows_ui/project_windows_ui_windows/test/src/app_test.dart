import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_ui_windows/project_windows_ui_windows.dart';
import 'package:project_windows_ui_windows/src/theme_extensions.dart';

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
  group('ProjectWindowsApp', () {
    late Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
    late Iterable<Locale> supportedLocales;
    late RouteInformationParser<Object> routeInformationParser;
    late RouterDelegate<Object> routerDelegate;
    late Locale? locale;
    late ThemeMode? themeMode;
    late Widget? home;

    setUp(() {
      localizationsDelegates = [_MockLocalizationsDelegate()];
      supportedLocales = {const Locale('en')};
      routeInformationParser = _MockRouteInformationParser();
      routerDelegate = _MockRouterDelegate();
      locale = null;
      themeMode = null;
      home = null;
    });

    ProjectWindowsApp projectWindowsApp() => ProjectWindowsApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          locale: locale,
          themeMode: themeMode,
          home: home,
        );

    testWidgets('renders FluentApp with correct properties', (tester) async {
      // Act
      await tester.pumpWidget(projectWindowsApp());

      // Assert
      final fluentApp = tester.widget<FluentApp>(find.byType(FluentApp));
      expect(fluentApp.locale, null);
      expect(
        fluentApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(fluentApp.supportedLocales, supportedLocales);
      expect(fluentApp.theme!.extensions.values.toSet(), lightExtensions);
      expect(fluentApp.darkTheme!.extensions.values.toSet(), darkExtensions);
      expect(fluentApp.routeInformationParser, routeInformationParser);
      expect(fluentApp.routerDelegate, routerDelegate);
      expect(fluentApp.home, null);
    });

    testWidgets(
        'renders FluentApp with correct properties when home is not null',
        (tester) async {
      // Arrange
      locale = const Locale('en');
      themeMode = ThemeMode.light;
      home = Container();

      // Act
      await tester.pumpWidget(projectWindowsApp());

      // Assert
      final fluentApp = tester.widget<FluentApp>(find.byType(FluentApp));
      expect(fluentApp.locale, locale);
      expect(
        fluentApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(fluentApp.supportedLocales, supportedLocales);
      expect(fluentApp.routeInformationParser, null);
      expect(fluentApp.routerDelegate, null);
      expect(fluentApp.theme!.extensions.values.toSet(), lightExtensions);
      expect(fluentApp.darkTheme!.extensions.values.toSet(), darkExtensions);
      expect(fluentApp.themeMode, themeMode);
      expect(fluentApp.home, home);
    });
  });
}
