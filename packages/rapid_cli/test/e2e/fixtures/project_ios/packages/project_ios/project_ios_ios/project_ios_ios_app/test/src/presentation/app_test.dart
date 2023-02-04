import 'package:flutter/cupertino.dart' hide Router;
import 'package:flutter_test/flutter_test.dart';
import 'package:project_ios_ios_app/project_ios_ios_app.dart';
import 'package:project_ios_ios_app/src/presentation/localizations.dart';
import 'package:project_ios_ios_routing/project_ios_ios_routing.dart';
import 'package:project_ios_ui_ios/src/app.dart';
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

    late Widget? home;

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

      home = null;
    });

    App app() => App(
          routerObserverBuilder: routerObserverBuilder,
          locale: locale,
          brightness: brightness,
          router: router,
          home: home,
        );

    testWidgets('renders ProjectIosApp with correct properties',
        (tester) async {
      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectIosApp =
          tester.widget<ProjectIosApp>(find.byType(ProjectIosApp));
      expect(projectIosApp.localizationsDelegates, localizationsDelegates);
      expect(projectIosApp.supportedLocales, supportedLocales);
      expect(projectIosApp.routeInformationParser, routeInformationParser);
      expect(projectIosApp.routerDelegate, routerDelegate);
      expect(projectIosApp.locale, locale);
      expect(projectIosApp.brightness, brightness);
      expect(projectIosApp.home, null);
    });

    testWidgets('uses fallback router when router is null', (tester) async {
      // Arrange
      router = null;

      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectIosApp =
          tester.widget<ProjectIosApp>(find.byType(ProjectIosApp));
      expect(projectIosApp.routeInformationParser, isA<DefaultRouteParser>());
      expect(projectIosApp.routerDelegate, isA<AutoRouterDelegate>());
      expect(projectIosApp.home, null);
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
        'renders ProjectIos with correct properties when home is not null',
        (tester) async {
      // Arrange
      home = Container();

      // Act
      await tester.pumpWidget(app());

      // Assert
      final projectIosApp =
          tester.widget<ProjectIosApp>(find.byType(ProjectIosApp));
      expect(projectIosApp.localizationsDelegates, localizationsDelegates);
      expect(projectIosApp.supportedLocales, supportedLocales);
      expect(projectIosApp.routeInformationParser, null);
      expect(projectIosApp.routerDelegate, null);
      expect(projectIosApp.locale, locale);
      expect(projectIosApp.brightness, brightness);
      expect(projectIosApp.home, home);
    });
  });
}
