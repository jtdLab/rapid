import 'package:flutter/cupertino.dart' hide Router;
import 'package:flutter_test/flutter_test.dart';
import 'package:project_macos_macos_app/project_macos_macos_app.dart';
import 'package:project_macos_macos_app/src/presentation/localizations.dart';
import 'package:project_macos_macos_routing/project_macos_macos_routing.dart';
import 'package:project_macos_ui_macos/src/app.dart';
import 'package:mocktail/mocktail.dart';

class _MockRouter extends Mock implements Router {}

void main() {
  group('App', () {
    late List<AutoRouterObserver> Function()? routerObserverBuilder;

    late Locale? locale;

    late Brightness? brightness;

    late Router? router;
    late DefaultRouteParser routeInformationParser;
    late AutoRouterDelegate routerDelegate;

    setUp(() {
      routerObserverBuilder = () => [];

      locale = const Locale('en');

      brightness = Brightness.light;

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
          brightness: brightness,
          router: router,
        );

    testWidgets('renders ProjectMacosApp with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final projectMacosApp =
          tester.widget<ProjectMacosApp>(find.byType(ProjectMacosApp));
      expect(projectMacosApp.localizationsDelegates, localizationsDelegates);
      expect(projectMacosApp.supportedLocales, supportedLocales);
      expect(projectMacosApp.routeInformationParser, routeInformationParser);
      expect(projectMacosApp.routerDelegate, routerDelegate);
      expect(projectMacosApp.locale, locale);
      expect(projectMacosApp.brightness, brightness);
    });

    testWidgets('uses fallback router when router is null', (tester) async {
      // Arrange
      router = null;

      // Act
      await tester.pumpWidget(getApp());

      // Assert
      final projectMacosApp =
          tester.widget<ProjectMacosApp>(find.byType(ProjectMacosApp));
      expect(projectMacosApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(projectMacosApp.routerDelegate, isA<AutoRouterDelegate>());
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
