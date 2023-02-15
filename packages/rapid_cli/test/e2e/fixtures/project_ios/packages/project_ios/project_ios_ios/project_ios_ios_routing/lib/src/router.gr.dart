// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

part of 'router.dart';

class _$Router extends RootStackRouter {
  _$Router([GlobalKey<NavigatorState>? navigatorKey]) : super(navigatorKey);

  @override
  final Map<String, PageFactory> pagesMap = {
    HomePageRoute.name: (routeData) {
      return CupertinoPageX<dynamic>(
        routeData: routeData,
        child: const HomePage(),
      );
    }
  };

  @override
  List<RouteConfig> get routes => [
        RouteConfig(
          HomePageRoute.name,
          path: '/',
        )
      ];
}

/// generated route for
/// [HomePage]
class HomePageRoute extends PageRouteInfo<void> {
  const HomePageRoute()
      : super(
          HomePageRoute.name,
          path: '/',
        );

  static const String name = 'HomePageRoute';
}
