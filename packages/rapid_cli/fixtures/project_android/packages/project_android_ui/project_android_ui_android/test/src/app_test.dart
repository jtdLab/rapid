import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui_android/project_android_ui_android.dart';
import 'package:project_android_ui_android/src/theme_extensions.dart';

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
  group('ProjectAndroidApp', () {
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

    ProjectAndroidApp getApp() => ProjectAndroidApp(
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
          locale: locale,
          themeMode: themeMode,
          home: home,
        );

    testWidgets('returns MaterialApp with correct properties', (tester) async {
      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, null);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.supportedLocales, supportedLocales);
      expect(materialApp.theme!.extensions.values.toSet(), lightExtensions);
      expect(materialApp.darkTheme!.extensions.values.toSet(), darkExtensions);
      expect(materialApp.routeInformationParser, routeInformationParser);
      expect(materialApp.routerDelegate, routerDelegate);
      expect(materialApp.home, null);
    });

    testWidgets(
        'returns MaterialApp with correct properties when home is not null',
        (tester) async {
      // Arrange
      locale = const Locale('en');
      themeMode = ThemeMode.light;
      home = Container();

      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(materialApp.locale, locale);
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.supportedLocales, supportedLocales);
      expect(materialApp.routeInformationParser, null);
      expect(materialApp.routerDelegate, null);
      expect(materialApp.theme!.extensions.values.toSet(), lightExtensions);
      expect(materialApp.darkTheme!.extensions.values.toSet(), darkExtensions);
      expect(materialApp.themeMode, themeMode);
      expect(materialApp.home, home);
    });
  });
}
