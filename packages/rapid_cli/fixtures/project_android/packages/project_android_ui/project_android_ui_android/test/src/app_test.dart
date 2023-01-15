import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_ui_android/src/app.dart';

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
    late Locale? locale;
    late Iterable<LocalizationsDelegate<dynamic>> localizationsDelegates;
    late Iterable<Locale> supportedLocales;
    late RouteInformationParser<Object> routeInformationParser;
    late RouterDelegate<Object> routerDelegate;

    setUp(() {
      locale = const Locale('en');
      localizationsDelegates = [_MockLocalizationsDelegate()];
      supportedLocales = {const Locale('en')};
      routeInformationParser = _MockRouteInformationParser();
      routerDelegate = _MockRouterDelegate();
    });

    ProjectAndroidApp getApp() => ProjectAndroidApp(
          locale: locale,
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          routeInformationParser: routeInformationParser,
          routerDelegate: routerDelegate,
        );

    testWidgets('returns MaterialApp with correct properties', (tester) async {
      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.supportedLocales, supportedLocales);
      expect(materialApp.locale, locale);
      expect(materialApp.routeInformationParser, routeInformationParser);
      expect(materialApp.routerDelegate, routerDelegate);
    });

    testWidgets(
        'returns MaterialApp with correct properties when locale is null',
        (tester) async {
      // Arrange
      locale = null;

      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final materialApp = tester.widget<MaterialApp>(find.byType(MaterialApp));
      expect(
        materialApp.localizationsDelegates,
        [...GlobalMaterialLocalizations.delegates, ...localizationsDelegates],
      );
      expect(materialApp.supportedLocales, supportedLocales);
      expect(materialApp.locale, locale);
      expect(materialApp.routeInformationParser, routeInformationParser);
      expect(materialApp.routerDelegate, routerDelegate);
    });
  });
}
