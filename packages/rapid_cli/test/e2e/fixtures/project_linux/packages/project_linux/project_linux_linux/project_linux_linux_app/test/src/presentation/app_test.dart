import 'package:flutter/material.dart' hide Router;
import 'package:flutter_test/flutter_test.dart';
import 'package:project_linux_linux_app/project_linux_linux_app.dart';
import 'package:project_linux_linux_app/src/presentation/localizations.dart';
import 'package:project_linux_linux_routing/project_linux_linux_routing.dart';
import 'package:project_linux_ui_linux/src/app.dart';
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

    testWidgets('renders ProjectLinuxApp with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectLinuxApp =
          tester.widget<ProjectLinuxApp>(find.byType(ProjectLinuxApp));
      expect(projectLinuxApp.localizationsDelegates, localizationsDelegates);
      expect(projectLinuxApp.supportedLocales, supportedLocales);
      expect(projectLinuxApp.routeInformationParser, routeInformationParser);
      expect(projectLinuxApp.routerDelegate, routerDelegate);
      expect(projectLinuxApp.locale, locale);
      expect(projectLinuxApp.themeMode, themeMode);
      expect(projectLinuxApp.home, null);
    });

    testWidgets('uses fallback router when router is null', (tester) async {
      // Arrange
      router = null;

      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectLinuxApp =
          tester.widget<ProjectLinuxApp>(find.byType(ProjectLinuxApp));
      expect(projectLinuxApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(projectLinuxApp.routerDelegate, isA<AutoRouterDelegate>());
      expect(projectLinuxApp.home, null);
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
        'renders ProjectLinux with correct properties when home is not null',
        (tester) async {
      // Arrange
      home = Container();

      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectLinuxApp =
          tester.widget<ProjectLinuxApp>(find.byType(ProjectLinuxApp));
      expect(projectLinuxApp.localizationsDelegates, localizationsDelegates);
      expect(projectLinuxApp.supportedLocales, supportedLocales);
      expect(projectLinuxApp.routeInformationParser, null);
      expect(projectLinuxApp.routerDelegate, null);
      expect(projectLinuxApp.locale, locale);
      expect(projectLinuxApp.themeMode, themeMode);
      expect(projectLinuxApp.home, home);
    });
  });
}
