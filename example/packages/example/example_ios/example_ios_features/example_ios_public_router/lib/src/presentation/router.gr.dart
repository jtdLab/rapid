// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i2;
import 'package:example_ios_public_router/src/presentation/public_router_page.dart'
    as _i1;

abstract class $PublicRouter extends _i2.RootStackRouter {
  $PublicRouter({super.navigatorKey});

  @override
  final Map<String, _i2.PageFactory> pagesMap = {
    PublicRouterRoute.name: (routeData) {
      return _i2.AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const _i1.PublicRouterPage(),
      );
    }
  };
}

/// generated route for
/// [_i1.PublicRouterPage]
class PublicRouterRoute extends _i2.PageRouteInfo<void> {
  const PublicRouterRoute({List<_i2.PageRouteInfo>? children})
      : super(
          PublicRouterRoute.name,
          initialChildren: children,
        );

  static const String name = 'PublicRouterRoute';

  static const _i2.PageInfo<void> page = _i2.PageInfo<void>(name);
}
