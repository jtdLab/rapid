import 'package:flutter/material.dart' hide Router;
import 'package:flutter_test/flutter_test.dart';
import 'package:project_windows_ui_windows/src/app.dart';
import 'package:project_windows_windows_app/project_windows_windows_app.dart';
import 'package:project_windows_windows_app/src/presentation/localizations.dart';
import 'package:project_windows_windows_routing/project_windows_windows_routing.dart';
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

    late Widget? home;

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

      home = null;
    });

    App app() => App(
          routerObserverBuilder: routerObserverBuilder,
          locale: locale,
          themeMode: themeMode,
          router: router,
          home: home,
        );

    testWidgets('renders ProjectWindowsApp with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectWindowsApp =
          tester.widget<ProjectWindowsApp>(find.byType(ProjectWindowsApp));
      expect(projectWindowsApp.localizationsDelegates, localizationsDelegates);
      expect(projectWindowsApp.supportedLocales, supportedLocales);
      expect(projectWindowsApp.routeInformationParser, routeInformationParser);
      expect(projectWindowsApp.routerDelegate, routerDelegate);
      expect(projectWindowsApp.locale, locale);
      expect(projectWindowsApp.themeMode, themeMode);
      expect(projectWindowsApp.home, null);
    });

    testWidgets('uses fallback router when router is null', (tester) async {
      // Arrange
      router = null;

      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectWindowsApp =
          tester.widget<ProjectWindowsApp>(find.byType(ProjectWindowsApp));
      expect(
          projectWindowsApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(projectWindowsApp.routerDelegate, isA<AutoRouterDelegate>());
      expect(projectWindowsApp.home, null);
    });

    testWidgets(
        'uses fallback observer builder when routerObserverBuilder is null ',
        (tester) async {
      // Arrange
      routerObserverBuilder = null;

      // Act
      await tester.pumpWidget(app());

      // Assert
      verify(
        () => router!.delegate(
          navigatorObservers:
              AutoRouterDelegate.defaultNavigatorObserversBuilder,
        ),
      );
    });

    testWidgets(
        'renders ProjectWindows with correct properties when home is not null',
        (tester) async {
      // Arrange
      home = Container();

      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectWindowsApp =
          tester.widget<ProjectWindowsApp>(find.byType(ProjectWindowsApp));
      expect(projectWindowsApp.localizationsDelegates, localizationsDelegates);
      expect(projectWindowsApp.supportedLocales, supportedLocales);
      expect(projectWindowsApp.routeInformationParser, null);
      expect(projectWindowsApp.routerDelegate, null);
      expect(projectWindowsApp.locale, locale);
      expect(projectWindowsApp.themeMode, themeMode);
      expect(projectWindowsApp.home, home);
    });
  });
}
