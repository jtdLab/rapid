import 'package:auto_route/auto_route.dart';
import 'package:flutter/widgets.dart';
import 'package:mocktail/mocktail.dart';

class FakePageRouteInfo extends PageRouteInfo {
  const FakePageRouteInfo() : super('test');
}

class FakeRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: const PageInfo('test'), path: '/'),
      ];

  @override
  Map<String, PageFactory> get pagesMap => {
        'test': (routeData) => AutoRoutePage(
              routeData: routeData,
              child: Container(),
            ),
      };
}

class MockAutoRouterObserver extends Mock implements AutoRouterObserver {}
