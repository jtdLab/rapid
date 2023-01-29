import 'package:flutter/material.dart' hide Router;
import 'package:flutter_test/flutter_test.dart';
import 'package:project_android_android_app/project_android_android_app.dart';
import 'package:project_android_android_app/src/presentation/localizations.dart';
import 'package:project_android_android_routing/project_android_android_routing.dart';
import 'package:project_android_ui_android/src/app.dart';
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

    testWidgets('renders ProjectAndroidApp with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectAndroidApp =
          tester.widget<ProjectAndroidApp>(find.byType(ProjectAndroidApp));
      expect(projectAndroidApp.localizationsDelegates, localizationsDelegates);
      expect(projectAndroidApp.supportedLocales, supportedLocales);
      expect(projectAndroidApp.routeInformationParser, routeInformationParser);
      expect(projectAndroidApp.routerDelegate, routerDelegate);
      expect(projectAndroidApp.locale, locale);
      expect(projectAndroidApp.themeMode, themeMode);
      expect(projectAndroidApp.home, null);
    });

    testWidgets('uses fallback router when router is null', (tester) async {
      // Arrange
      router = null;

      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectAndroidApp =
          tester.widget<ProjectAndroidApp>(find.byType(ProjectAndroidApp));
      expect(
          projectAndroidApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(projectAndroidApp.routerDelegate, isA<AutoRouterDelegate>());
      expect(projectAndroidApp.home, null);
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
        'renders ProjectAndroid with correct properties when home is not null',
        (tester) async {
      // Arrange
      home = Container();

      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectAndroidApp =
          tester.widget<ProjectAndroidApp>(find.byType(ProjectAndroidApp));
      expect(projectAndroidApp.localizationsDelegates, localizationsDelegates);
      expect(projectAndroidApp.supportedLocales, supportedLocales);
      expect(projectAndroidApp.routeInformationParser, null);
      expect(projectAndroidApp.routerDelegate, null);
      expect(projectAndroidApp.locale, locale);
      expect(projectAndroidApp.themeMode, themeMode);
      expect(projectAndroidApp.home, home);
    });
  });
}
