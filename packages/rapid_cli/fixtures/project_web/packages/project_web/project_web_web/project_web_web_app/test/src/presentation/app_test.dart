import 'package:flutter/material.dart' hide Router;
import 'package:flutter_test/flutter_test.dart';
import 'package:project_web_ui_web/src/app.dart';
import 'package:project_web_web_app/project_web_web_app.dart';
import 'package:project_web_web_app/src/presentation/localizations.dart';
import 'package:project_web_web_routing/project_web_web_routing.dart';
import 'package:mocktail/mocktail.dart';

class _MockRouter extends Mock implements Router {}

void main() {
  group('App', () {
    late List<AutoRouterObserver> Function()? routerObserverBuilder;

    late Locale? locale;

    late ThemeMode? themeMode;

    late Router? router;
    late DefaultRouteParser routeInformationParser;
    late AutoRouterDelegate routerDelegate;

    setUp(() {
      routerObserverBuilder = () => [];

      locale = const Locale('en');

      themeMode = ThemeMode.light;

      router = _MockRouter();
      routeInformationParser = Router().defaultRouteParser();
      routerDelegate = Router().delegate();
      when(() => router?.defaultRouteParser())
          .thenReturn(routeInformationParser);
      when(() => router?.delegate(
              navigatorObservers: any(named: 'navigatorObservers')))
          .thenReturn(routerDelegate);
    });

    App getApp() => App(
          routerObserverBuilder: routerObserverBuilder,
          locale: locale,
          themeMode: themeMode,
          router: router,
        );

    testWidgets('renders ProjectWebApp with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final projectWebApp =
          tester.widget<ProjectWebApp>(find.byType(ProjectWebApp));
      expect(projectWebApp.localizationsDelegates, localizationsDelegates);
      expect(projectWebApp.supportedLocales, supportedLocales);
      expect(projectWebApp.routeInformationParser, routeInformationParser);
      expect(projectWebApp.routerDelegate, routerDelegate);
      expect(projectWebApp.locale, locale);
      expect(projectWebApp.themeMode, themeMode);
    });

    testWidgets('uses fallback router when router is null', (tester) async {
      // Arrange
      router = null;

      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final projectWebApp =
          tester.widget<ProjectWebApp>(find.byType(ProjectWebApp));
      expect(projectWebApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(projectWebApp.routerDelegate, isA<AutoRouterDelegate>());
    });

    testWidgets(
        'uses fallback observer builder when routerObserverBuilder is null ',
        (tester) async {
      // Arrange
      routerObserverBuilder = null;

      // Act
      await tester.pumpWidget(getApp());

      // Assert
      verify(
        () => router!.delegate(
          navigatorObservers:
              AutoRouterDelegate.defaultNavigatorObserversBuilder,
        ),
      );
    });
  });
}
